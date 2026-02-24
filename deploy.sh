#!/bin/bash

# OpenClaw Docker Deployment Script with Bailian & Feishu Support

set -e

echo "🚀 OpenClaw Docker Deployment Script"
echo "===================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found!"
    echo ""
    echo "Creating .env from template..."
    cp .env.example .env
    echo ""
    echo "📝 Please edit .env and add your credentials:"
    echo "   BAILIAN_API_KEY=sk-your-bailian-api-key"
    echo "   FEISHU_APP_ID=cli-your-feishu-app-id"
    echo "   FEISHU_APP_SECRET=your-feishu-app-secret"
    echo ""
    exit 1
fi

# Load environment variables
source .env

# Check if required variables are set
if [ -z "$BAILIAN_API_KEY" ] || [ "$BAILIAN_API_KEY" = "sk-your-bailian-api-key-here" ]; then
    echo "❌ BAILIAN_API_KEY is not set in .env file!"
    echo ""
    echo "Please edit .env and add your Bailian API key."
    echo ""
    exit 1
fi

if [ -z "$FEISHU_APP_ID" ] || [ "$FEISHU_APP_ID" = "cli-your-feishu-app-id" ]; then
    echo "⚠️  FEISHU_APP_ID is not set in .env file!"
    echo "   Feishu integration will be disabled."
    echo ""
fi

echo "✅ Environment configured"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p openclaw-workspace/workspace
echo ""

# Build and start services
echo "🚀 Building and starting OpenClaw services..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d --build
else
    docker compose up -d --build
fi

echo ""
echo "⏳ Waiting for OpenClaw to be ready..."
sleep 10

# Check if container is running
if docker ps | grep -q openclaw-gateway; then
    echo ""
    echo "✅ OpenClaw is running!"
    echo ""
    echo "📍 Access URLs:"
    echo "   Local:   http://localhost:18790/"
    echo "   Network: http://$(hostname -I | awk '{print $1}'):18790/"
    echo ""
    echo "🤖 Default Model: qwen3.5-plus (1M context)"
    if [ -n "$FEISHU_APP_ID" ] && [ "$FEISHU_APP_ID" != "cli-your-feishu-app-id" ]; then
        echo "💬 Feishu Bot: Enabled"
    else
        echo "💬 Feishu Bot: Disabled (configure FEISHU_APP_ID to enable)"
    fi
    echo ""
    echo "📊 View logs:"
    echo "   docker-compose logs -f"
    echo ""
    echo "🛑 Stop services:"
    echo "   docker-compose down"
else
    echo ""
    echo "❌ OpenClaw failed to start!"
    echo ""
    echo "📋 Check logs:"
    if command -v docker-compose &> /dev/null; then
        echo "   docker-compose logs"
    else
        echo "   docker compose logs"
    fi
    exit 1
fi
