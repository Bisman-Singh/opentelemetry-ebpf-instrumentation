FROM gcc:15.2.0-trixie@sha256:7c7782df5e7281b07fbd616c77310253a42c144068eefb71e202ad27c8be8488 AS builder

COPY splice_proxy_t.c .

RUN gcc -pthread -o splice_proxy_t splice_proxy_t.c

FROM node:25.8.1-trixie@sha256:394048fb359d02efc485852ab638cac322a35af228c2cef83d23fc7dd01f4a36

COPY --from=builder /splice_proxy_t proxy
EXPOSE 8080

# Copy the source code into the image for building
COPY app.js .
COPY package-lock.json .
COPY package.json .

COPY run.sh .

# Install dependencies from committed lockfile
RUN npm ci

ENTRYPOINT [ "bash", "/run.sh" ]