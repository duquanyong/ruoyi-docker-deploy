# 若依后台管理系统 - Docker Compose 阿里云部署指南

## 一、服务器准备

### 1.1 购买阿里云 ECS（推荐配置）
| 配置项 | 最低要求 | 推荐配置 |
|--------|---------|---------|
| CPU | 2核 | 4核 |
| 内存 | 4GB | 8GB |
| 带宽 | 3Mbps | 5Mbps+ |
| 系统盘 | 40GB SSD | 100GB SSD |
| 操作系统 | CentOS 7.9 / Ubuntu 22.04 | Ubuntu 22.04 LTS |

### 1.2 安全组配置
开放以下端口：
- `22` - SSH（必须）
- `80` - HTTP（前端访问）
- `443` - HTTPS（SSL）
- `3306` - MySQL（可选，建议只对内网开放）
- `6379` - Redis（可选，建议只对内网开放）
- `8080` - 后端 API（可选，建议只对内网开放）

> **安全建议**：生产环境建议只开放 80/443，数据库和 Redis 不暴露公网

---

## 二、服务器环境初始化

### 2.1 连接服务器
```bash
# Windows 用 PowerShell 或 Git Bash
ssh root@你的服务器公网IP

# 或使用密钥
ssh -i ~/.ssh/your-key.pem root@你的服务器公网IP
```

### 2.2 系统更新
```bash
# Ubuntu/Debian
apt update && apt upgrade -y

# CentOS
yum update -y
```

### 2.3 安装 Docker
```bash
# 一键安装脚本（推荐）
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

# 启动 Docker
systemctl start docker
systemctl enable docker

# 验证
docker --version
```

### 2.4 安装 Docker Compose
```bash
# 下载最新版
DOCKER_COMPOSE_VERSION=v2.27.0
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 添加执行权限
chmod +x /usr/local/bin/docker-compose

# 创建软链接
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 验证
docker-compose --version
```

### 2.5 配置 Docker 镜像加速（阿里云）
```bash
# 登录阿里云控制台 → 容器镜像服务 → 镜像工具 → 镜像加速器
# 复制你的专属加速器地址

mkdir -p /etc/docker

cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://你的阿里云镜像加速器地址.mirror.aliyuncs.com",
    "https://docker.1ms.run"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF

# 重启 Docker
systemctl daemon-reload
systemctl restart docker
```

---

## 三、项目部署

### 3.1 创建项目目录
```bash
mkdir -p /opt/ruoyi
cd /opt/ruoyi
```

### 3.2 上传项目文件
**方式一：使用 git（推荐）**
```bash
# 安装 git
apt install git -y  # Ubuntu
# yum install git -y  # CentOS

# 克隆项目（假设代码在 GitHub/Gitee）
git clone https://github.com/your-repo/ruoyi-vue.git
```

**方式二：使用 scp 本地上传**
```bash
# 在本地电脑执行
scp -r D:\WorkSpace\若依后台管理系统\docker root@服务器IP:/opt/ruoyi/
scp -r D:\WorkSpace\若依后台管理系统\RuoYi-Vue root@服务器IP:/opt/ruoyi/
scp -r D:\WorkSpace\若依后台管理系统\RuoYi-Vue3 root@服务器IP:/opt/ruoyi/
```

**方式三：使用 rz/sz（已连接服务器时）**
```bash
# 服务器上安装
apt install lrzsz -y

# 上传压缩包
rz  # 选择本地压缩包

# 解压
unzip ruoyi-project.zip
```

### 3.3 目录结构确认
```
/opt/ruoyi/
├── docker/                    # Docker 配置目录
│   ├── docker-compose.yml     # 编排文件
│   ├── mysql/
│   │   ├── init/
│   │   │   ├── 00-init-database.sh
│   │   │   └── 01-init.sql
│   │   └── conf/
│   │       └── my.cnf
│   ├── redis/
│   │   └── redis.conf
│   ├── nginx/
│   │   └── nginx.conf
│   ├── ruoyi-vue/
│   │   └── Dockerfile         # 后端 Dockerfile
│   └── ruoyi-vue3/
│       └── Dockerfile         # 前端 Dockerfile
├── RuoYi-Vue/                 # 后端源码
└── RuoYi-Vue3/                # 前端源码
```

### 3.4 修改配置文件

#### 3.4.1 修改 docker-compose.yml
```bash
cd /opt/ruoyi/docker
vim docker-compose.yml
```

关键修改项：
```yaml
services:
  mysql:
    # 修改密码（生产环境务必使用强密码）
    environment:
      MYSQL_ROOT_PASSWORD: YourStrongPassword123!
      MYSQL_PASSWORD: YourStrongPassword123!
    
    # 生产环境建议不暴露 3306 端口，或只绑定 127.0.0.1
    ports:
      - "127.0.0.1:3306:3306"  # 只允许本机访问
  
  redis:
    # 生产环境建议设置密码
    command: redis-server /usr/local/etc/redis/redis.conf --requirepass YourRedisPassword
    
    # 不暴露公网
    ports:
      - "127.0.0.1:6379:6379"
  
  ruoyi-backend:
    environment:
      # 修改数据库密码
      SPRING_DATASOURCE_DRUID_MASTER_PASSWORD: YourStrongPassword123!
      # 修改 Redis 密码
      SPRING_DATA_REDIS_PASSWORD: YourRedisPassword
  
  ruoyi-frontend:
    # 生产环境使用域名
    environment:
      API_BASE_URL: http://你的域名或IP:8080
```

#### 3.4.2 修改 Redis 配置
```bash
vim redis/redis.conf
```

添加密码：
```conf
# 安全
protected-mode yes
requirepass YourRedisPassword
```

#### 3.4.3 修改后端数据库连接（可选）
如果后端代码里硬编码了数据库配置，需要修改：
```bash
cd /opt/ruoyi/RuoYi-Vue/ruoyi-admin/src/main/resources
vim application-druid.yml
```

### 3.5 启动服务
```bash
cd /opt/ruoyi/docker

# 构建镜像
docker-compose build

# 启动所有服务（后台运行）
docker-compose up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 3.6 验证部署
```bash
# 检查容器状态
docker-compose ps

# 测试后端
curl http://localhost:8080

# 测试前端
curl -I http://localhost:80

# 查看 MySQL 字符集
docker exec ruoyi-mysql mysql -uroot -pYourStrongPassword123! -e "SHOW VARIABLES LIKE 'character_set%';"
```

---

## 四、域名和 HTTPS 配置（推荐）

### 4.1 域名解析
在阿里云域名控制台，添加 A 记录：
- 主机记录：`@` 或 `www`
- 记录值：你的服务器公网 IP

### 4.2 安装 Nginx（宿主机）
```bash
# Ubuntu
apt install nginx -y

# CentOS
yum install nginx -y
systemctl start nginx
```

### 4.3 配置反向代理
```bash
vim /etc/nginx/sites-available/ruoyi  # Ubuntu
# 或
vim /etc/nginx/conf.d/ruoyi.conf      # CentOS
```

配置内容：
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # 前端静态资源
    location / {
        proxy_pass http://127.0.0.1:8082;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # API 代理
    location /prod-api/ {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4.4 申请 SSL 证书（Let's Encrypt）
```bash
# 安装 certbot
apt install certbot python3-certbot-nginx -y

# 申请证书
certbot --nginx -d your-domain.com

# 自动续期测试
certbot renew --dry-run
```

---

## 五、生产环境优化

### 5.1 数据库备份脚本
```bash
cat > /opt/ruoyi/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/ruoyi/backup"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="ry-vue"
DB_PASSWORD="YourStrongPassword123!"

mkdir -p $BACKUP_DIR

# 备份数据库
docker exec ruoyi-mysql mysqldump -uroot -p$DB_PASSWORD --default-character-set=utf8mb4 $DB_NAME > $BACKUP_DIR/ruoyi_$DATE.sql

# 保留最近 7 天的备份
find $BACKUP_DIR -name "ruoyi_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/ruoyi_$DATE.sql"
EOF

chmod +x /opt/ruoyi/backup.sh

# 添加定时任务（每天凌晨 2 点备份）
crontab -e
# 添加：
0 2 * * * /opt/ruoyi/backup.sh >> /opt/ruoyi/backup/backup.log 2>&1
```

### 5.2 日志管理
```bash
# 限制容器日志大小
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://你的加速器地址.mirror.aliyuncs.com"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF

systemctl restart docker
```

### 5.3 系统监控（可选）
```bash
# 安装 Prometheus + Grafana 监控
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana
```

---

## 六、常见问题

### Q1: 容器启动失败
```bash
# 查看具体错误
docker-compose logs 服务名

# 例如
docker-compose logs ruoyi-backend
```

### Q2: 数据库连接失败
```bash
# 检查 MySQL 是否健康
docker-compose ps

# 进入 MySQL 容器检查
docker exec -it ruoyi-mysql bash
mysql -uroot -p
```

### Q3: 前端访问 502
```bash
# 检查前端容器
docker-compose logs ruoyi-frontend

# 检查 Nginx 配置
docker exec ruoyi-frontend cat /etc/nginx/conf.d/default.conf
```

### Q4: 中文乱码
确保：
1. SQL 文件是 UTF-8 编码
2. MySQL 字符集是 utf8mb4
3. 初始化脚本 `00-init-database.sh` 存在且可执行

### Q5: 内存不足
```bash
# 添加 Swap 分区
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# 永久生效
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

---

## 七、更新部署

### 7.1 更新前端代码
```bash
cd /opt/ruoyi/RuoYi-Vue3
git pull origin main  # 或手动上传新代码

cd /opt/ruoyi/docker
docker-compose build ruoyi-frontend
docker-compose up -d ruoyi-frontend
```

### 7.2 更新后端代码
```bash
cd /opt/ruoyi/RuoYi-Vue
git pull origin main

cd /opt/ruoyi/docker
docker-compose build ruoyi-backend
docker-compose up -d ruoyi-backend
```

### 7.3 全量更新
```bash
cd /opt/ruoyi/docker
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 八、安全加固清单

- [ ] 修改所有默认密码（MySQL root、Redis、后端数据库连接）
- [ ] 关闭不必要的端口暴露（3306、6379、8080 只监听 127.0.0.1）
- [ ] 配置防火墙（ufw/firewalld）
- [ ] 启用 HTTPS（SSL 证书）
- [ ] 定期备份数据库
- [ ] 设置 Docker 容器资源限制
- [ ] 配置日志审计
- [ ] 禁用 root 直接登录，使用普通用户 + sudo
- [ ] 配置 SSH 密钥登录，禁用密码登录
- [ ] 安装 fail2ban 防止暴力破解

---

## 附录：一键部署脚本

```bash
#!/bin/bash
# save as: deploy.sh

set -e

PROJECT_DIR="/opt/ruoyi"

echo "=== 若依管理系统部署脚本 ==="

# 1. 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "安装 Docker..."
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    systemctl start docker
    systemctl enable docker
fi

# 2. 检查 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "安装 Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

# 3. 创建目录
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# 4. 提示上传代码
echo "请确保项目代码已上传到 $PROJECT_DIR"
echo "目录结构应为："
echo "  $PROJECT_DIR/docker/"
echo "  $PROJECT_DIR/RuoYi-Vue/"
echo "  $PROJECT_DIR/RuoYi-Vue3/"
read -p "按回车继续..."

# 5. 启动服务
cd $PROJECT_DIR/docker
docker-compose down -v 2>/dev/null || true
docker-compose build
docker-compose up -d

# 6. 验证
echo ""
echo "=== 部署完成 ==="
echo "前端访问: http://$(curl -s ifconfig.me):8082"
echo "后端 API: http://$(curl -s ifconfig.me):8080"
echo ""
echo "查看状态: docker-compose ps"
echo "查看日志: docker-compose logs -f"
```

---

**部署完成！** 🎉

访问 `http://你的服务器IP` 即可使用若依管理系统。
