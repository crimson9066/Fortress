package main

import (
	"net/http"
	"os"
	"strconv"
	"time"
)

type config struct {
	addr                  string
	maxBodyBytes          int64
	rateLimit             int
	rateWindow            time.Duration
	shutdownTimeout       time.Duration
	faultInjectionEnabled bool
	faultInjectionStatus  int
	faultInjectionDelay   time.Duration
}

func loadConfig() config {
	return config{
		addr:                  envString("FORTRESS_ADDR", ":8080"),
		maxBodyBytes:          envInt64("FORTRESS_MAX_BODY_BYTES", 1<<20),
		rateLimit:             int(envInt64("FORTRESS_RATE_LIMIT", 60)),
		rateWindow:            envDuration("FORTRESS_RATE_WINDOW", time.Minute),
		shutdownTimeout:       envDuration("FORTRESS_SHUTDOWN_TIMEOUT", 10*time.Second),
		faultInjectionEnabled: envBool("FORTRESS_FAULT_INJECTION_ENABLED", false),
		faultInjectionStatus:  envHTTPStatus("FORTRESS_FAULT_INJECTION_STATUS", http.StatusInternalServerError),
		faultInjectionDelay:   envDuration("FORTRESS_FAULT_INJECTION_DELAY", 500*time.Millisecond),
	}
}

func envString(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

func envInt64(key string, fallback int64) int64 {
	value, err := strconv.ParseInt(os.Getenv(key), 10, 64)
	if err != nil || value <= 0 {
		return fallback
	}
	return value
}

func envDuration(key string, fallback time.Duration) time.Duration {
	value, err := time.ParseDuration(os.Getenv(key))
	if err != nil || value <= 0 {
		return fallback
	}
	return value
}

func envBool(key string, fallback bool) bool {
	value, err := strconv.ParseBool(os.Getenv(key))
	if err != nil {
		return fallback
	}
	return value
}

func envHTTPStatus(key string, fallback int) int {
	value, err := strconv.Atoi(os.Getenv(key))
	if err != nil || value < 400 || value > 599 {
		return fallback
	}
	return value
}
