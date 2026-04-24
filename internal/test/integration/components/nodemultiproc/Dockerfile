FROM node:24-slim@sha256:03eae3ef7e88a9de535496fb488d67e02b9d96a063a8967bae657744ecd513f2

WORKDIR /app

COPY internal/test/integration/components/nodemultiproc/package*.json ./
RUN npm ci

COPY internal/test/integration/components/nodemultiproc/service.js .
COPY internal/test/integration/components/nodemultiproc/start-all.js .

EXPOSE 5000 5001 5002 5003

CMD [ "node", "start-all.js" ]

