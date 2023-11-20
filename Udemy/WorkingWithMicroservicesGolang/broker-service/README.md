# Broker Microservice

## Initial Setup
1. Create new folder for the service, called "broker-service"
2. Inside that folder run `go mod init broker`
  1. This could be `go mod init github.com/username/broker`

## Dependencies
go v. 1.18 or later

```bash
go get github.com/go-chi/chi/v5
go get github.com/go-chi/chi/middleware
go get github.com/go-chi/cors
```

package net/http

## Files

### cmd/api/main.go

Creates Listener on Port 80

### cmd/api/routes.go

| Route | Method  | Handler |
| ----- | ------- | ------- |
| `GET`  | "/ping" | middleware.Heartbeat  |
| `POST` | "/"     | app.Broker |

### cmd/api/handlers.go

**app.Broker**
Currently just Writes "Hit the broker" to the HTTP Response

## To Run:
```bash
go run ./cmd/api
```