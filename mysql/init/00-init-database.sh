#!/bin/bash
set -e

mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 ry-vue < /docker-entrypoint-initdb.d/01-init.sql