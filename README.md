# RuoYi-Vue Docker 部署方案

基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 和 [RuoYi-Vue3](https://github.com/yangzongzhuan/RuoYi-Vue3) 的 Docker Compose 一键部署方案。

## 项目结构

```
.
├── docker-compose.yml          # Docker Compose 编排文件
├── .env.example                # 环境变量模板
├── docker/
│   ├── ruoyi-vue/
│   │   └── Dockerfile          # 后端 Spring Boot 镜像
│   ├── ruoyi-vue3/
│   │   ├── Dockerfile          # 前端 Vue3 + Nginx 镜像
│   │   └── entrypoint.sh       # Nginx 启动脚本
│   └── nginx/
│       └── nginx.conf          # Nginx 配置文件
├── mysql/
│   └── init/
│       ├── 00-init-database.sh # MySQL 初始化包装脚本（解决中文乱码）
│       └── 01-init.sql         # 数据库表结构和数据
├── redis/
│   └── redis.conf              # Redis 配置文件
├── RuoYi-Vue/                  # 后端源码（git submodule 或手动放置）
└── RuoYi-Vue3/                 # 前端源码（git submodule 或手动放置）
```

## 快速开始

### 1. 克隆本项目

```bash
git clone https://github.com/your-username/ruoyi-docker-deploy.git
cd ruoyi-docker-deploy
```

### 2. 放置源码

**方式一：使用 git submodule（推荐）**

```bash
git submodule add https://gitee.com/y_project/RuoYi-Vue.git RuoYi-Vue
git submodule add https://github.com/yangzongzhuan/RuoYi-Vue3.git RuoYi-Vue3
git submodule update --init --recursive
```

**方式二：手动下载**

下载 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 和 [RuoYi-Vue3](https://github.com/yangzongzhuan/RuoYi-Vue3) 源码，分别放置到 `RuoYi-Vue/` 和 `RuoYi-Vue3/` 目录。

### 3. 配置环境变量

```bash
cp .env.example .env
vim .env
```

修改数据库密码等配置：

```env
MYSQL_ROOT_PASSWORD=YourStrongPassword123!
MYSQL_PASSWORD=YourStrongPassword123!
```

### 4. 启动服务

```bash
docker-compose up -d
```

### 5. 访问系统

- 前端：http://localhost
- 后端 API：http://localhost:8080
- 默认账号：`admin` / `admin123`

## 常用命令

```bash
# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 完全重置（包括数据库数据）
docker-compose down -v
```

## 生产环境部署

参考 [deploy-guide.md](deploy-guide.md) 了解阿里云服务器部署的详细步骤。

## 中文乱码避坑

参考 [mysql-charset-pitfall-guide.md](mysql-charset-pitfall-guide.md) 了解 Docker 部署 MySQL 中文乱码的踩坑记录。

## 技术栈

- **后端**：Spring Boot 3.x + MyBatis + Druid
- **前端**：Vue 3 + Vite + Element Plus + Pinia
- **数据库**：MySQL 8.0
- **缓存**：Redis 7
- **容器**：Docker + Docker Compose

## 许可证

本项目遵循 [MIT](LICENSE) 许可证。

RuoYi 相关代码遵循其原始许可证。
