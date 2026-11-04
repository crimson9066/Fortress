package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	cfg := loadConfig()
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelInfo}))
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	logger.Info("server starting", "addr", cfg.addr)
	if err := runServer(ctx, cfg, logger); err != nil {
		logger.Error("server stopped unexpectedly", "error", err)
		os.Exit(1)
	}
}
