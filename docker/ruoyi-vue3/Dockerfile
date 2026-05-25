# 若依前端 Dockerfile（本地预构建版）
# 使用前请确保 RuoYi-Vue3/dist 目录已存在（通过 yarn build:prod 生成）

FROM docker.1ms.run/nginx:alpine

RUN apk add --no-cache gettext

COPY RuoYi-Vue3/dist /usr/share/nginx/html
COPY docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf.template
COPY docker/ruoyi-vue3/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
