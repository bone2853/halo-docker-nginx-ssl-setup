#!/bin/bash

DOMAIN="dafei168.win"
EMAIL="351688151@qq.com"
WWW_DOMAIN="www.$DOMAIN"
WEB_PORT=8090

echo "🟡 开始安装 Docker 和 Docker Compose ..."
apt update && apt install -y curl ca-certificates gnupg lsb-release software-properties-common

# 安装 Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt install -y docker-ce docker-ce-cli containerd.io

# 安装 Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "✅ Docker 和 Compose 安装完成"

# 启动 Halo 容器
echo "🟡 启动 Halo 博客容器..."
docker-compose up -d

# 安装 Nginx 和 Certbot
echo "🟡 安装 Nginx 和 Certbot ..."
apt install -y nginx certbot python3-certbot-nginx

# 写入 Nginx 配置
NGINX_CONF="/etc/nginx/sites-available/halo"
echo "🟡 写入 Nginx 配置..."

cat > "$NGINX_CONF" <<EOF
server {
    listen 80;
    server_name $DOMAIN $WWW_DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:$WEB_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/halo
nginx -t && systemctl reload nginx

# 申请 HTTPS 证书
echo "🟡 正在使用 Certbot 为 $DOMAIN 和 $WWW_DOMAIN 申请 SSL 证书 ..."
certbot --nginx --non-interactive --agree-tos --redirect --email "$EMAIL" -d "$DOMAIN" -d "$WWW_DOMAIN"

# 测试自动续期
echo "🟢 测试证书自动续期（dry-run）..."
certbot renew --dry-run

echo "🎉 部署完成！现在你可以访问：https://$DOMAIN"
