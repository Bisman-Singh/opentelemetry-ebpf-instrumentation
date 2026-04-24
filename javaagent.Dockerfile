# Build JNI native library using Go image (has gcc, no apt install needed)
FROM golang:1.26.2@sha256:1e598ea5752ae26c093b746fd73c5095af97d6f2d679c43e83e0eac484a33dc3 AS jni-builder
COPY --from=gradle:9.4.1-jdk21-noble@sha256:2d34fc215310891039e1b2b7797632de8d59eab54496c134bc2da711ba651c50 /opt/java/openjdk/include /opt/java/include
WORKDIR /build
COPY pkg/internal/java/agent/src/main/c/ src/main/c/
COPY pkg/internal/java/agent/Makefile.jni Makefile.jni
RUN make -f Makefile.jni CC=gcc JAVA_HOME=/opt/java JNI_HEADERS_DIR=src/main/c

FROM gradle:9.4.1-jdk21-noble@sha256:2d34fc215310891039e1b2b7797632de8d59eab54496c134bc2da711ba651c50 AS builder

WORKDIR /build

# Copy build files
COPY pkg/internal/java .
# Pre-built native library from jni-builder stage
COPY --from=jni-builder /build/target/classes/libobijni.so agent/target/classes/libobijni.so

# Build the project (skip native lib compilation, already done above)
RUN gradle build -x buildNativeLib --no-daemon

FROM scratch AS export
COPY --from=builder /build/build/obi-java-agent.jar /obi-java-agent.jar