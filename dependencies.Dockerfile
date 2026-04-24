# This is a renovate-friendly source of Docker images.
FROM davidanson/markdownlint-cli2:v0.22.1@sha256:0ed9a5f4c77ef447da2a2ac6e67caf74b214a7f80288819565e8b7d2ac148fe5 AS markdown
FROM gradle:9.4.1-jdk21-noble@sha256:2d34fc215310891039e1b2b7797632de8d59eab54496c134bc2da711ba651c50 AS gradle-java
FROM ghcr.io/astral-sh/uv:python3.9-trixie-slim@sha256:906a3dbcd57a9c56b2d14019717c74b59443de7f1991f3e1d7fa56cc0242e954 AS python39
FROM ghcr.io/astral-sh/uv:python3.14-trixie-slim@sha256:abc097534bf1c917a8ed6408e28c87cf191560c4da3ced2016bf8b9da74b5831 AS python314
