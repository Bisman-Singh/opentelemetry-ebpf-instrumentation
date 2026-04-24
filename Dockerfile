ARG TAG=0.2.11@sha256:c9a11deeda1de354aa334817f693efbf5ccee15dcd18caee6a9b221eed0e5773

# Build JNI native library using Go image (has gcc, no apt install needed)
FROM golang:1.26.2@sha256:1e598ea5752ae26c093b746fd73c5095af97d6f2d679c43e83e0eac484a33dc3 AS jni-builder
COPY --from=gradle:9.4.1-jdk21-noble@sha256:2d34fc215310891039e1b2b7797632de8d59eab54496c134bc2da711ba651c50 /opt/java/openjdk/include /opt/java/include
WORKDIR /build
COPY pkg/internal/java/agent/src/main/c/ src/main/c/
COPY pkg/internal/java/agent/Makefile.jni Makefile.jni
RUN make -f Makefile.jni CC=gcc JAVA_HOME=/opt/java JNI_HEADERS_DIR=src/main/c

# Build the Java OBI agent
FROM gradle:9.4.1-jdk21-noble@sha256:2d34fc215310891039e1b2b7797632de8d59eab54496c134bc2da711ba651c50 AS javaagent-builder

WORKDIR /build

# Copy build files
COPY pkg/internal/java .
# Pre-built native library from jni-builder stage
COPY --from=jni-builder /build/target/classes/libobijni.so agent/target/classes/libobijni.so

# Build the project (skip native lib compilation, already done above)
RUN gradle build -x buildNativeLib --no-daemon

# Build the autoinstrumenter binary
FROM ghcr.io/open-telemetry/obi-generator:${TAG} AS builder

# TODO: embed software version in executable

ARG TARGETARCH

ENV GOARCH=$TARGETARCH

WORKDIR /src

RUN apk add make git bash

COPY go.mod go.sum ./
# Cache module cache.
RUN --mount=type=cache,target=/go/pkg/mod go mod download

COPY .git/ .git/
COPY bpf/ bpf/
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY Makefile dependencies.Dockerfile ./
COPY --from=javaagent-builder /build/build/obi-java-agent.jar /src/pkg/internal/java/embedded/obi-java-agent.jar

# Build
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
	/generate.sh \
	&& make compile

# Create final image from minimal + built binary
FROM scratch

LABEL maintainer="The OpenTelemetry Authors"

WORKDIR /

COPY --from=builder /src/bin/obi .
COPY LICENSE NOTICE ./
COPY NOTICES ./NOTICES

COPY --from=builder /etc/ssl/certs /etc/ssl/certs

ENTRYPOINT [ "/obi" ]
