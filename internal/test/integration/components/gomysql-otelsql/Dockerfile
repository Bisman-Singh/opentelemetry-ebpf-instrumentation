# Build the testserver binary
# Docker command must be invoked from the project root directory
FROM golang:1.26.2@sha256:1e598ea5752ae26c093b746fd73c5095af97d6f2d679c43e83e0eac484a33dc3 AS builder

ARG TARGETARCH

ENV GOARCH=$TARGETARCH

WORKDIR /src

# Copy the go manifests and source
COPY go.mod go.mod
COPY gomysql_otelsql.go gomysql_otelsql.go

# Build - download dependencies and build
RUN go mod tidy
RUN go build -o gomysql_otelsql gomysql_otelsql.go

# Create final image from minimal + built binary
FROM debian:bookworm-slim@sha256:74d56e3931e0d5a1dd51f8c8a2466d21de84a271cd3b5a733b803aa91abf4421

WORKDIR /
COPY --from=builder /src/gomysql_otelsql .
USER 0:0

CMD [ "/gomysql_otelsql" ]
