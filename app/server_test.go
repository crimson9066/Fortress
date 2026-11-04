package main

import (
	"bytes"
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func testApp() *server {
	return newServer(config{maxBodyBytes: 1024, rateLimit: 100, rateWindow: time.Minute}, slog.New(slog.NewJSONHandler(io.Discard, nil)))
}

func TestParseItem(t *testing.T) {
	tests := []struct {
		name    string
		payload string
		wantErr bool
	}{
		{"valid", `{"name":"widget","description":"small"}`, false},
		{"unknown field", `{"name":"widget","extra":"nope"}`, true},
		{"missing name", `{"description":"small"}`, true},
		{"multiple objects", `{"name":"widget"}{"name":"other"}`, true},
		{"invalid JSON", `{"name":`, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := parseItem(strings.NewReader(tt.payload), 1024)
			if (err != nil) != tt.wantErr {
				t.Fatalf("parseItem() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func FuzzParseItem(f *testing.F) {
	f.Add(`{"name":"widget"}`)
	f.Add(`{"name":`)
	f.Fuzz(func(t *testing.T, payload string) {
		_, _ = parseItem(strings.NewReader(payload), 1024)
	})
}

func TestItemsAPI(t *testing.T) {
	app := testApp()
	ts := httptest.NewServer(app.routes())
	defer ts.Close()

	resp, err := http.Post(ts.URL+"/v1/items", "application/json", bytes.NewBufferString(`{"name":"widget"}`))
	if err != nil {
		t.Fatal(err)
	}
	if resp.StatusCode != http.StatusCreated {
		t.Fatalf("POST status = %d, want %d", resp.StatusCode, http.StatusCreated)
	}
	_ = resp.Body.Close()

	resp, err = http.Get(ts.URL + "/v1/items")
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()
	var items []item
	if err := json.NewDecoder(resp.Body).Decode(&items); err != nil {
		t.Fatal(err)
	}
	if len(items) != 1 || items[0].Name != "widget" {
		t.Fatalf("unexpected items: %+v", items)
	}
}

func TestRequestLimitAndHeaders(t *testing.T) {
	app := testApp()
	req := httptest.NewRequest(http.MethodPost, "/v1/items", strings.NewReader(`{"name":"widget","unknown":true}`))
	rec := httptest.NewRecorder()
	app.routes().ServeHTTP(rec, req)
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d", rec.Code, http.StatusBadRequest)
	}
	if rec.Header().Get("X-Content-Type-Options") != "nosniff" {
		t.Fatal("security header missing")
	}
}
