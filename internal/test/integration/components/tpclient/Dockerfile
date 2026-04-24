FROM node:24-slim@sha256:03eae3ef7e88a9de535496fb488d67e02b9d96a063a8967bae657744ecd513f2

WORKDIR /app

COPY internal/test/integration/components/tpclient/package*.json ./
RUN npm ci

COPY internal/test/integration/components/tpclient/service.js ./
COPY internal/test/integration/components/tpclient/start-all.js ./

EXPOSE 6000 6001 6002

CMD ["node", "start-all.js"]
