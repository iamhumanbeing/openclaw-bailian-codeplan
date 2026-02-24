# OpenClaw Gateway with Bailian Code Plan API Configuration
# This Dockerfile extends the official OpenClaw image with custom configuration

FROM openclaw-gateway:latest

# Copy custom configuration
COPY openclaw-config/openclaw.json /home/node/.openclaw/openclaw.json

# Set proper permissions
USER root
RUN chown -R node:node /home/node/.openclaw
USER node

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget -q --spider http://localhost:18789/__openclaw__/health || exit 1

# Expose ports
EXPOSE 18789 18792

# Start gateway
CMD ["node", "/home/node/.openclaw-package/dist/index.js", "gateway", "--allow-unconfigured"]
