# 若依前端 Dockerfile
FROM docker.1ms.run/node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY RuoYi-Vue3/package.json RuoYi-Vue3/yarn.lock ./
RUN yarn install --frozen-lockfile --registry=https://registry.npmmirror.com

COPY RuoYi-Vue3/ .
RUN yarn build:prod

FROM docker.1ms.run/nginx:alpine

RUN apk add --no-cache gettext

COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf.template
COPY docker/ruoyi-vue3/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]