FROM golang:1.22 AS base-stage

WORKDIR /snippetbox

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /web ./cmd/web


FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=base-stage /web /web

EXPOSE 8080

USER nonroot:nonroot

CMD ["./web"]
