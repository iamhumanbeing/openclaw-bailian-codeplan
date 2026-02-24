# OpenClaw Docker with 阿里百炼 Code Plan API

A Dockerized deployment of OpenClaw configured to use Alibaba Cloud Bailian Code Plan API.

## Features

- 🚀 OpenClaw Gateway with web UI
- 🤖 Multiple LLM models via Bailian Code Plan API:
  - qwen3.5-plus (1M context) - default
  - qwen3-coder-plus (1M context)
  - qwen3-max-2026-01-23 (262k context)
  - qwen3-coder-next (262k context)
  - glm-4.7 (202k context)
  - kimi-k2.5 (262k context)
- 🔧 Browser automation support (CDP on port 18892)
- 📁 Persistent workspace and configuration

## Quick Start

### 1. Clone and Configure

```bash
git clone <your-repo-url>
cd openclaw-docker-bailian
```

### 2. Set API Key

Edit `docker-compose.yml` and replace `YOUR_BAILIAN_API_KEY` with your actual API key:

```yaml
environment:
  - BAILIAN_API_KEY=sk-your-actual-api-key-here
```

Or create a `.env` file:

```bash
echo "BAILIAN_API_KEY=sk-your-actual-api-key-here" > .env
```

### 3. Start Services

```bash
docker-compose up -d
```

### 4. Access OpenClaw

Open your browser and navigate to:
- **Local**: http://localhost:18790/
- **Network**: http://<your-ip>:18790/

## Configuration

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

## Directory Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Custom Dockerfile (optional)
├── README.md                   # This file
├── openclaw-config/            # Persistent configuration
│   └── openclaw.json          # Main configuration file
└── openclaw-workspace/        # Persistent workspace
    └── workspace/             # Your files and data
```

## Volumes

- `./openclaw-config:/home/node/.openclaw` - Configuration persistence
- `./openclaw-workspace:/home/node/.openclaw/workspace` - Workspace persistence

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `BAILIAN_API_KEY` | Alibaba Bailian API Key | (required) |
| `OPENCLAW_GATEWAY_PORT` | Gateway port inside container | 18789 |
| `OPENCLAW_GATEWAY_BIND` | Bind address | 0.0.0.0 |
| `NODE_ENV` | Node environment | production |

## Building from Source

If you need to build the image locally:

```bash
docker build -t openclaw-gateway:latest .
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

### Reset Configuration

```bash
# Backup first
cp openclaw-config/openclaw.json openclaw-config/openclaw.json.backup
# Remove and restart
docker-compose down
rm -rf openclaw-config/*
docker-compose up -d
```

## License

See OpenClaw official repository for license information.

## Credits

- [OpenClaw](https://github.com/openclaw/openclaw)
- [Alibaba Cloud Bailian](https://www.aliyun.com/product/bailian)
