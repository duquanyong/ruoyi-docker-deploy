# Docker Compose 部署 MySQL 中文乱码避坑指南

> 基于 RuoYi-Vue + MySQL 8.0 Docker 部署踩坑实录

## 问题现象

使用 Docker Compose 部署若依后台管理系统时，遇到以下中文乱码问题：

1. **Navicat 查询中文乱码**：数据库表中的中文字段显示为乱码（如 `è‹¥ä¾ç§‘æŠ€`）
2. **系统菜单接口返回乱码**：前端页面菜单名称、部门名称等中文内容显示异常
3. **后端日志中的中文也是乱码**

![Navicat 查询乱码](navicat-中查询也是乱码.png)

![系统菜单乱码](系统菜单是乱码.png)

## 根本原因

MySQL 官方 Docker 镜像在执行 `/docker-entrypoint-initdb.d/*.sql` 初始化脚本时，**默认使用 `latin1` 客户端字符集**，导致 UTF-8 编码的 SQL 文件被错误解析。

即使你在 `docker-compose.yml` 中配置了：

```yaml
command: >
  --character-set-server=utf8mb4
  --collation-server=utf8mb4_unicode_ci
```

这些参数只影响 **MySQL Server 运行时的字符集**，不影响 **entrypoint 执行初始化脚本时的客户端字符集**。

## 踩坑过程

### 坑 1：以为配置了 server 字符集就万事大吉

```yaml
# 错误示范 ❌
command: >
  --character-set-server=utf8mb4
  --collation-server=utf8mb4_unicode_ci
```

结果：
- `SHOW VARIABLES LIKE 'character_set_server';` → `utf8mb4` ✅
- 但初始化后的数据仍然是乱码 ❌

### 坑 2：SQL 文件开头加 `SET NAMES utf8mb4`

```sql
-- 无效 ❌
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
```

结果：entrypoint 执行 SQL 时，第一个连接就已经是 latin1，`SET NAMES` 只能修复后续语句，但前面的数据已经写入乱码。

### 坑 3：挂载 my.cnf 配置文件

```yaml
volumes:
  - ./mysql/conf/my.cnf:/etc/mysql/conf.d/my.cnf
```

结果：
```
World-writable config file '/etc/mysql/conf.d/my.cnf' is ignored.
```

Windows 挂载到 Docker 后文件权限变成 777，MySQL 出于安全考虑直接忽略该配置。

### 坑 4：使用 `--skip-character-set-client-handshake`

```yaml
command: >
  --skip-character-set-client-handshake
```

结果：这个参数确实能让客户端强制使用 server 字符集，但 **entrypoint 执行初始化脚本时可能尚未生效**，导致初始化数据仍然乱码。

## 正确解决方案

### 方案：Shell 脚本包装器（推荐）

创建 `00-init-database.sh`，显式指定 `--default-character-set=utf8mb4` 执行 SQL：

```bash
#!/bin/bash
set -e

# 使用 utf8mb4 字符集执行初始化 SQL
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 < /docker-entrypoint-initdb.d/01-init.sql
```

SQL 文件（`01-init.sql`）：

```sql
USE `ry-vue`;

-- 建表 + 插入数据...
```

**关键点**：
1. `.sh` 脚本在 `.sql` 之前执行（按文件名排序）
2. `mysql` 命令显式指定 `--default-character-set=utf8mb4`
3. SQL 文件中包含 `USE db_name;`

### 完整 docker-compose.yml 配置

```yaml
services:
  mysql:
    image: docker.1ms.run/mysql:8.0
    container_name: ruoyi-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ruoyi123456
      MYSQL_DATABASE: ry-vue
      TZ: Asia/Shanghai
    command: >
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --default-time-zone=+08:00
    volumes:
      - ./mysql_data:/var/lib/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
```

### 目录结构

```
docker/mysql/init/
├── 00-init-database.sh    # Shell 包装器（关键！）
└── 01-init.sql            # 数据库初始化 SQL
```

## 验证方法

### 1. 检查 MySQL 字符集

```bash
docker exec ruoyi-mysql mysql -uroot -p -e "SHOW VARIABLES LIKE 'character_set%';"
```

期望结果：
```
+--------------------------+---------+
| Variable_name            | Value   |
+--------------------------+---------+
| character_set_client     | utf8mb4 |
| character_set_connection | utf8mb4 |
| character_set_database   | utf8mb4 |
| character_set_results    | utf8mb4 |
| character_set_server     | utf8mb4 |
+--------------------------+---------+
```

### 2. 检查数据是否正确

```bash
docker exec ruoyi-mysql sh -c 'mysql -uroot -p -e "SELECT dept_name FROM \`ry-vue\`.sys_dept WHERE dept_id=100;"'
```

期望结果：
```
dept_name
若依科技
```

### 3. Navicat 连接设置

- **编码**：选择 `Auto` 或 `utf8mb4`
- **高级** → **编码**：`65001 (UTF-8)`

## 总结

| 方案 | 效果 | 原因 |
|------|------|------|
| `--character-set-server=utf8mb4` | ❌ 无效 | 只影响 server，不影响初始化客户端 |
| SQL 中加 `SET NAMES utf8mb4` | ❌ 无效 | 执行时已用 latin1 连接 |
| 挂载 my.cnf | ❌ 无效 | Windows 权限问题被忽略 |
| `--skip-character-set-client-handshake` | ⚠️ 不稳定 | entrypoint 执行时机不确定 |
| **Shell 脚本 + `--default-character-set=utf8mb4`** | ✅ **有效** | 直接控制初始化连接的字符集 |

## 一句话总结

> **Docker 部署 MySQL 时，初始化 SQL 一定要用 Shell 脚本包装，显式指定 `--default-character-set=utf8mb4`，否则中文必乱码！**

---

*踩坑不易，如果对你有帮助，欢迎点赞收藏！*
