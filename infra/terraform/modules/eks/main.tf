data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "eks"
    Project   = "fortress"
  })
  control_plane_logs = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

resource "aws_kms_key" "eks" {
  description             = "KMS key for ${var.name} EKS secrets encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.eks_kms.json

  tags = merge(local.common_tags, {
    Name = "${var.name}-eks-secrets"
  })
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.name}-eks-secrets"
  target_key_id = aws_kms_key.eks.key_id
}

data "aws_iam_policy_document" "eks_kms" {
  statement {
    sid    = "EnableAccountAdministration"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "control_plane" {
  name              = "/aws/eks/${var.name}/cluster"
  retention_in_days = var.cluster_log_retention_days
  kms_key_id        = aws_kms_key.eks.arn

  tags = merge(local.common_tags, {
    Name = "${var.name}-control-plane-logs"
  })
}

data "aws_iam_policy_document" "cluster_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name                 = "${var.name}-cluster"
  assume_role_policy   = data.aws_iam_policy_document.cluster_assume.json
  max_session_duration = 3600
  tags                 = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "node_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "node" {
  name                 = "${var.name}-node"
  assume_role_policy   = data.aws_iam_policy_document.node_assume.json
  max_session_duration = 3600
  tags                 = local.common_tags
}

resource "aws_iam_role_policy_attachment" "node" {
  for_each = var.node_role_policy_arns

  role       = aws_iam_role.node.name
  policy_arn = each.value
}

resource "aws_launch_template" "node" {
  name                   = "${var.name}-node"
  update_default_version = true

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      encrypted   = true
      volume_size = var.node_disk_size_gib
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.name}-node"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

resource "aws_eks_cluster" "this" {
  name                          = var.name
  role_arn                      = aws_iam_role.cluster.arn
  version                       = var.kubernetes_version
  enabled_cluster_log_types     = local.control_plane_logs
  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.api_public_access_cidrs
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }

  depends_on = [aws_cloudwatch_log_group.control_plane]

  tags = merge(local.common_tags, {
    Name = var.name
  })
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = local.common_tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-managed"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types
  capacity_type   = "ON_DEMAND"

  scaling_config {
    min_size     = var.node_min_size
    max_size     = var.node_max_size
    desired_size = var.node_desired_size
  }

  launch_template {
    id      = aws_launch_template.node.id
    version = aws_launch_template.node.latest_version
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.common_tags

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}

resource "aws_eks_access_entry" "this" {
  for_each = var.access_entries

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"
  user_name     = "fortress:${each.key}"
}

resource "aws_eks_access_policy_association" "this" {
  for_each = merge([
    for entry_name, entry in var.access_entries : {
      for policy_arn in entry.policy_arns :
      "${entry_name}-${replace(policy_arn, ":", "-")}" => {
        entry_name = entry_name
        policy_arn = policy_arn
        scope      = entry.access_scope
      }
    }
  ]...)

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.access_entries[each.value.entry_name].principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = each.value.scope.type
    namespaces = each.value.scope.type == "namespace" ? each.value.scope.namespaces : null
  }
}
