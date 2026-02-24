# OpenClaw Gateway with Bailian and Feishu Support
# Built from official npm package

FROM node:22-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /home/node

# Create openclaw user
RUN groupadd -r node && useradd -r -g node -m -d /home/node node

# Install OpenClaw globally from npm
RUN npm install -g openclaw@latest --registry https://registry.npmjs.org/

# Install Feishu SDK globally
RUN npm install -g @larksuiteoapi/node-sdk --registry https://registry.npmjs.org/

# Create necessary directories
RUN mkdir -p /home/node/.openclaw /home/node/.openclaw/workspace \
    && chown -R node:node /home/node/.openclaw

# Copy configuration
COPY --chown=node:node openclaw-config/openclaw.json /home/node/.openclaw/openclaw.json

# Switch to node user
USER node

# Set environment variables
ENV NODE_ENV=production
ENV OPENCLAW_GATEWAY_PORT=18789
ENV OPENCLAW_GATEWAY_BIND=0.0.0.0
ENV OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json
ENV OPENCLAW_STATE_DIR=/home/node/.openclaw
ENV OPENCLAW_HOME=/home/node/.openclaw

# Expose ports
EXPOSE 18789 18792

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget -q --spider http://localhost:18789/__openclaw__/health || exit 1

# Start OpenClaw Gateway
CMD ["openclaw", "gateway", "--allow-unconfigured"]
