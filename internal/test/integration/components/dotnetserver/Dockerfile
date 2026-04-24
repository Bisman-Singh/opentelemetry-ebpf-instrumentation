FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:8a90a473da5205a16979de99d2fc20975e922c68304f5c79d564e666dc3982fc AS builder

# Set the working directory to /build
WORKDIR /build

# Copy the source code into the image for building
COPY internal/test/integration/components/dotnetserver .

RUN dotnet dev-certs https
RUN dotnet build


# Create final image from minimal + built binary
FROM mcr.microsoft.com/dotnet/aspnet:10.0@sha256:55e37c7795bfaf6b9cc5d77c155811d9569f529d86e20647704bc1d7dd9741d4

WORKDIR /
COPY --from=builder /build/bin/Debug/net7.0/* .
COPY --from=builder /root/.dotnet/corefx/cryptography/x509stores/my/* /root/.dotnet/corefx/cryptography/x509stores/my/
ENV ASPNETCORE_URLS="https://0.0.0.0:7033;http://0.0.0.0:5266"

EXPOSE 7033
EXPOSE 5266

# Run the .net app
CMD [ "/dotnetserver"]
