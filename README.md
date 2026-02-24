# OpenClaw Docker with Bailian Code Plan API & Feishu Support

A Dockerized deployment of OpenClaw configured to use:
- 🤖 Alibaba Cloud Bailian Code Plan API for LLM
- 💬 Feishu (Lark) messaging integration

## Features

- 🚀 OpenClaw Gateway with web UI
- 🤖 Multiple LLM models via Bailian Code Plan API:
  - qwen3.5-plus (1M context) - default
  - qwen3-coder-plus (1M context)
  - qwen3-max-2026-01-23 (262k context)
  - qwen3-coder-next (262k context)
  - glm-4.7 (202k context)
  - kimi-k2.5 (262k context)
- 💬 Feishu (Lark) bot integration
- 🔧 Browser automation support (CDP on port 18892)
- 📁 Persistent workspace and configuration

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/openclaw-bailian-feishu.git
cd openclaw-bailian-feishu
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` file with your credentials:

```bash
# Bailian API Key
BAILIAN_API_KEY=sk-your-bailian-api-key-here

# Feishu Bot Configuration
FEISHU_APP_ID=cli-your-feishu-app-id
FEISHU_APP_SECRET=your-feishu-app-secret
```

### 3. Start Services

```bash
docker-compose up -d
```

Or use the deployment script:

```bash
./deploy.sh
```

### 4. Access OpenClaw

- **Web UI**: http://localhost:18790/ (or http://<your-ip>:18790/)

## Configuration

### Bailian API Setup

1. Go to [Alibaba Cloud Bailian](https://www.aliyun.com/product/bailian)
2. Create an application and get your API key
3. Set `BAILIAN_API_KEY` in `.env`

### Feishu (Lark) Bot Setup

1. Go to [Feishu Open Platform](https://open.feishu.cn/)
2. Create a new application
3. Get **App ID** and **App Secret** from "Credentials & Basic Info"
4. Enable **Bot** capability
5. Configure event subscription (optional for WebSocket mode)
6. Add required permissions:
   - `im:chat:readonly`
   - `im:message:send`
   - `im:message.group_msg`
   - `im:message.p2p_msg`
7. Publish the app

### Default Model

The default model is set to `qwen3.5-plus` (1 million token context window).

To change the default model, edit `openclaw-config/openclaw.json`:

```json
"agents": {
  "defaults": {
    "model": {
      "primary": "bailian/qwen3-coder-plus"
    }
  }
}
```

### Available Models

| Model | Context Window | Description |
|-------|---------------|-------------|
| qwen3.5-plus | 1,000,000 | General purpose |
| qwen3-coder-plus | 1,000,000 | Code specialized |
| qwen3-max-2026-01-23 | 262,144 | High performance |
| qwen3-coder-next | 262,144 | Code specialized |
| glm-4.7 | 202,752 | Alternative model |
| kimi-k2.5 | 262,144 | Long context |

### Ports

| Port | Service |
|------|---------|
| 18790 | OpenClaw Gateway Web UI |
| 18892 | Chrome DevTools Protocol (Browser automation) |

## Feishu User Authorization

When a new user first interacts with the bot, they need to be authorized:

1. User sends a message to the bot
2. Bot replies with a pairing code
3. Owner approves the user:

```bash
docker exec openclaw-gateway openclaw pairing approve feishu <PAIRING_CODE>
```

## Directory Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Custom Dockerfile
├── README.md                   # This file
├── deploy.sh                   # Deployment script
├── .env.example                # Environment variables template
├── .gitignore                  # Git ignore rules
├── openclaw-config/            # Persistent configuration
│   └── openclaw.json          # Main configuration file
└── openclaw-workspace/        # Persistent workspace
    └── workspace/             # Your files and data
```

## GitHub Container Registry

The Docker image is automatically built and pushed to GitHub Container Registry:

```bash
docker pull ghcr.io/yourusername/openclaw-bailian-feishu:latest
```

## Building from Source

To build the image locally:

```bash
docker build -t openclaw-bailian-feishu:latest .
docker-compose up -d
```

## Troubleshooting

### Check Logs

```bash
docker-compose logs -f openclaw-gateway
```

### Restart Service

```bash
docker-compose restart openclaw-gateway
```

### Feishu Plugin Not Loading

If Feishu plugin fails to load, ensure `@larksuiteoapi/node-sdk` is installed:

```bash
docker exec -u root openclaw-gateway npm install -g @larksuiteoapi/node-sdk
docker restart openclaw-gateway
```

### Reset Configuration

```bash
# Backup first
cp openclaw-config/openclaw.json openclaw-config/openclaw.json.backup
# Remove and restart
docker-compose down
rm -rf openclaw-config/*
docker-compose up -d
```

## Security Notes

- Keep your `.env` file secure and never commit it to Git
- The default configuration enables `dangerouslyDisableDeviceAuth` for easier local development
- For production, consider:
  - Using HTTPS/Tailscale
  - Disabling `dangerouslyDisableDeviceAuth`
  - Setting up proper authentication

## License

See OpenClaw official repository for license information.

## Credits

- [OpenClaw](https://github.com/openclaw/openclaw)
- [Alibaba Cloud Bailian](https://www.aliyun.com/product/bailian)
- [Feishu Open Platform](https://open.feishu.cn/)
