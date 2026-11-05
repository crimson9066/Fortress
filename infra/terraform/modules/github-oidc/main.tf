locals {
  issuer_url  = "https://token.actions.githubusercontent.com"
  issuer_host = "token.actions.githubusercontent.com"
  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "github-oidc"
    Project   = "fortress"
  })
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = local.issuer_url
  client_id_list = ["sts.amazonaws.com"]
  tags           = local.common_tags
}

data "aws_iam_policy_document" "plan_trust" {
  statement {
    sid     = "GitHubPullRequestsOnly"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host}:sub"
      values   = ["repo:${var.repository}:pull_request"]
    }
  }
}

resource "aws_iam_role" "plan" {
  name                 = "${var.name}-plan"
  assume_role_policy   = data.aws_iam_policy_document.plan_trust.json
  max_session_duration = 3600
  managed_policy_arns  = var.plan_policy_arns
  tags                 = local.common_tags
}

data "aws_iam_policy_document" "apply_trust" {
  statement {
    sid     = "GitHubMainProductionEnvironmentOnly"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host}:sub"
      values   = ["repo:${var.repository}:environment:${var.production_environment}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host}:workflow_ref"
      values   = ["${var.repository}/${var.apply_workflow_file}@refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "apply" {
  name                 = "${var.name}-apply"
  assume_role_policy   = data.aws_iam_policy_document.apply_trust.json
  max_session_duration = 3600
  managed_policy_arns  = var.apply_policy_arns
  tags                 = local.common_tags
}

