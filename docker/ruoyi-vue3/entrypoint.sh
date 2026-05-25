#!/bin/sh

envsubst '$API_BASE_URL' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'