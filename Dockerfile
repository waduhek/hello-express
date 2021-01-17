FROM node:14.15.4 AS builder
WORKDIR /hello-express
COPY ["package*.json", "webpack.config.js", "tsconfig.json", "/hello-express/"]
RUN npm install
COPY ./src ./src
RUN npm run build

FROM node:14.15.4-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /hello-express/build .
EXPOSE 3000
CMD [ "node", "server.js" ]