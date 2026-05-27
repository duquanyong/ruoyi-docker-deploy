#!/bin/bash
set -e

mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 ry-vue < /docker-entrypoint-initdb.d/01-init.sql
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 ry-vue < /docker-entrypoint-initdb.d/02-store.sql
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 ry-vue < /docker-entrypoint-initdb.d/06-store-complete-init.sql