# 🚀 Halo 博客一键部署脚本（Docker + Nginx + HTTPS）

本项目可在 **Ubuntu 22.04** 服务器上一键部署 [Halo v2.x](https://github.com/halo-dev/halo) 博客系统，基于 Docker 容器，使用 Nginx 反代并通过 Let's Encrypt 自动签发 HTTPS 证书。

> **适用场景**：通过 Cloudflare 管理的域名（如：dafei168.win）  
> **博客系统**：Halo v2.x

---

## ✅ 功能说明

- 自动安装 Docker & Docker Compose
- 启动 Halo 博客容器
- 安装 Nginx + Certbot（HTTPS）
- 自动配置反向代理与 HTTPS 证书
- 支持 `www` 和主域名（如 `www.dafei168.win` 与 `dafei168.win`）
- 自动续期证书

---

## 📦 文件结构

```text
halo-deploy/
├── docker-compose.yml     # Halo 服务容器配置
├── setup.sh               # 主部署脚本
└── README.md              # 使用说明
```

---

## 🚀 使用步骤

### 1. 前提条件

- 服务器系统为 **Ubuntu 22.04**
- 拥有域名（如：dafei168.win），并已在 Cloudflare 添加 A 记录解析至服务器 IP
- Cloudflare 的 SSL 模式需设置为：**Full** 或 **Full (Strict)**

### 2. 克隆本项目到服务器

```bash
git clone https://github.com/yourname/halo-deploy.git
cd halo-deploy
```

### 3. （可选）修改域名与邮箱配置

默认使用的域名与邮箱在 `setup.sh` 顶部：

```bash
DOMAIN="dafei168.win"
EMAIL="351688151@qq.com"
```

如需更换，编辑这两项即可。

### 4. 启动部署脚本

```bash
chmod +x setup.sh
./setup.sh
```

脚本会自动执行以下操作：

- 安装 Docker & Compose
- 启动 Halo 容器（端口 8090）
- 安装 Nginx & Certbot
- 配置反向代理
- 自动申请 HTTPS 证书
- 测试自动续期功能

---

## 🌐 访问博客网站

部署完成后，直接访问：

```
https://dafei168.win
```

你将进入 Halo 博客的初始化页面，设置管理员账号即可开始使用。

---

## 🛠 常用运维命令

**查看日志**

```bash
docker logs -f halo
```

**停止服务**

```bash
docker-compose down
```

**重启服务**

```bash
docker-compose up -d
```

**更新 Halo 镜像（升级）**

```bash
docker pull halohub/halo:2.12
docker-compose down
docker-compose up -d
```

---

## 📌 注意事项

> - 如果无法访问 HTTPS，请检查 Cloudflare 的 SSL 设置，并确保防火墙未屏蔽端口 80/443。
> - 如要将 `www.dafei168.win` 重定向到主域名，可在 Nginx 配置中添加跳转规则。
> - 若你在中国大陆，请确保服务器能访问 Let's Encrypt CA（或使用 DNS 验证方式）。

---

## 📑 License

本项目采用 MIT License。

---

## 🙋‍♂️ 作者说明

本项目由 ChatGPT 自动生成并优化，适合个人或中小型博客搭建使用。如需扩展更多功能（如数据库持久化、CI/CD 发布、多站点支持、CDN 反向代理）欢迎自行 Fork 或留言交流。