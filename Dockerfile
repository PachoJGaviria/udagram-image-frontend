FROM node:12 AS builder

WORKDIR /usr/frontend/app
COPY ["package.json", "package-lock.json", "./"]
RUN npm ci && npm cache clean --force
ENV PATH="./node_modules/.bin:$PATH" 
COPY ./angular.json ./angular.json
COPY ./ionic.config.json ./ionic.config.json
COPY ./tsconfig.json ./tsconfig.json
COPY ./src ./src
RUN npm run build

FROM nginx:1-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/frontend/app/www /usr/share/nginx/html
