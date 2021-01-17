FROM node:14.15.4 AS builder
WORKDIR /first-docker-app
COPY ["package*.json", "webpack.config.js", "tsconfig.json", "/first-docker-app/"]
RUN npm install
COPY ./src ./src
RUN npm run build

FROM node:14.15.4-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /first-docker-app/build .
EXPOSE 3000
CMD [ "node", "server.js" ]