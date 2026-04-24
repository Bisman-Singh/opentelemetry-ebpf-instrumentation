FROM node:24-slim@sha256:03eae3ef7e88a9de535496fb488d67e02b9d96a063a8967bae657744ecd513f2

# Set the working directory to /build
WORKDIR /

# Copy the source code into the image for building
COPY internal/test/integration/components/nodejsserver .

# Install dependencies from committed lockfile
RUN npm ci

EXPOSE 3030
EXPOSE 3033

# Run the node app
CMD [ "node", "app" ]
