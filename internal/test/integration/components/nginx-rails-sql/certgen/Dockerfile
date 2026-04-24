FROM golang:1.26.2@sha256:1e598ea5752ae26c093b746fd73c5095af97d6f2d679c43e83e0eac484a33dc3 AS builder

WORKDIR /src
COPY . .
RUN GO111MODULE=off CGO_ENABLED=0 go build -o /out/certgen ./main.go

FROM scratch

COPY --from=builder /out/certgen /usr/local/bin/certgen

ENTRYPOINT ["/usr/local/bin/certgen"]
