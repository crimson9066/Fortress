package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"
	"sync"
	"time"
)

const (
	maxItemName        = 100
	maxItemDescription = 1000
)

var errInvalidItem = errors.New("invalid item")

type itemInput struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}
type item struct {
	ID          string    `json:"id"`
	Name        string    `json:"name"`
	Description string    `json:"description,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
}

func parseItem(r io.Reader, maxBytes int64) (itemInput, error) {
	decoder := json.NewDecoder(io.LimitReader(r, maxBytes+1))
	decoder.DisallowUnknownFields()

	var input itemInput
	if err := decoder.Decode(&input); err != nil {
		return itemInput{}, fmt.Errorf("%w: invalid JSON", errInvalidItem)
	}
	if err := validateItem(input); err != nil {
		return itemInput{}, err
	}

	var extra any
	if err := decoder.Decode(&extra); err != io.EOF {
		return itemInput{}, fmt.Errorf("%w: exactly one JSON object is required", errInvalidItem)
	}
	return input, nil
}

func validateItem(input itemInput) error {
	input.Name = strings.TrimSpace(input.Name)
	if input.Name == "" || len([]rune(input.Name)) > maxItemName {
		return fmt.Errorf("%w: name must be 1-%d characters", errInvalidItem, maxItemName)
	}
	if len([]rune(input.Description)) > maxItemDescription {
		return fmt.Errorf("%w: description must be at most %d characters", errInvalidItem, maxItemDescription)
	}
	return nil
}

type itemStore struct {
	mu    sync.RWMutex
	items []item
	next  uint64
}

func (s *itemStore) add(input itemInput) item {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.next++
	result := item{
		ID:          fmt.Sprintf("%d", s.next),
		Name:        strings.TrimSpace(input.Name),
		Description: input.Description,
		CreatedAt:   time.Now().UTC(),
	}
	s.items = append(s.items, result)
	return result
}

func (s *itemStore) list() []item {
	s.mu.RLock()
	defer s.mu.RUnlock()
	result := make([]item, len(s.items))
	copy(result, s.items)
	return result
}
