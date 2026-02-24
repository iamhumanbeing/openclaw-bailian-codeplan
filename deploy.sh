#!/bin/bash

# OpenClaw Docker Deployment Script for Bailian Code Plan

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
    echo "📝 Please edit .env and add your Bailian API key:"
    echo "   BAILIAN_API_KEY=sk-your-actual-api-key-here"
    echo ""
    exit 1
fi

# Load environment variables
source .env

# Check if API key is set
if [ -z "$BAILIAN_API_KEY" ] || [ "$BAILIAN_API_KEY" = "sk-your-api-key-here" ]; then
    echo "❌ BAILIAN_API_KEY is not set in .env file!"
    echo ""
    echo "Please edit .env and add your Bailian API key:"
    echo "   BAILIAN_API_KEY=sk-your-actual-api-key-here"
    echo ""
    exit 1
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
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Pull latest image
echo "📥 Pulling latest OpenClaw image..."
docker pull openclaw-gateway:latest 2>/dev/null || echo "Using local image..."
echo ""

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p openclaw-workspace/workspace
echo ""

# Start services
echo "🚀 Starting OpenClaw services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for OpenClaw to be ready..."
sleep 5

# Check if container is running
if docker ps | grep -q openclaw-gateway; then
    echo ""
    echo "✅ OpenClaw is running!"
    echo ""
    echo "📍 Access URLs:"
    echo "   Local:   http://localhost:18790/"
    echo "   Network: http://$(hostname -I | awk '{print $1}'):18790/"
    echo ""
    echo "🛠️  Default Model: qwen3.5-plus (1M context)"
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
    echo "   docker-compose logs"
    exit 1
fi
