#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root. Please use sudo." >&2
  exit 1
fi

# Ollama Upgrade Script
# This script upgrades Ollama while preserving your custom service configuration

# Colors and formatting
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to print status messages
print_status() {
  echo -e "${BOLD}${2}${NC} ${1}"
}

print_status "🚀 Starting Ollama upgrade process..." "${BLUE}"

# Step 1: Stop Ollama service
print_status "🛑 Stopping Ollama service..." "${YELLOW}"
sudo systemctl stop ollama.service
print_status "✅ Ollama service stopped" "${GREEN}"

# Step 2: Backup current service file
print_status "📁 Backing up current service configuration..." "${YELLOW}"
cp /etc/systemd/system/ollama.service /tmp/ollama.service
if [ $? -eq 0 ]; then
  print_status "✅ Service configuration backed up to /tmp/ollama.service" "${GREEN}"
else
  print_status "❌ Failed to backup service configuration. Exiting." "${RED}"
  exit 1
fi

# Step 3: Install latest version of Ollama
print_status "📥 Downloading and installing latest Ollama version..." "${YELLOW}"
curl -fsSL https://ollama.com/install.sh | sh
print_status "✅ Latest Ollama version installed" "${GREEN}"

# Step 4: Stop the newly installed Ollama service (it might have been started by the installer)
print_status "🛑 Stopping newly installed Ollama service..." "${YELLOW}"
sudo systemctl stop ollama.service
print_status "✅ Service stopped" "${GREEN}"

# Step 5: Restore custom service configuration
print_status "🔄 Restoring your custom service configuration..." "${YELLOW}"
cp /tmp/ollama.service /etc/systemd/system/ollama.service
print_status "✅ Custom service configuration restored" "${GREEN}"

# Step 6: Reload systemd and start Ollama
print_status "🔄 Reloading systemd daemon..." "${YELLOW}"
systemctl daemon-reload
print_status "✅ Systemd daemon reloaded" "${GREEN}"

print_status "▶️ Starting Ollama service..." "${YELLOW}"
systemctl start ollama.service
print_status "✅ Ollama service started" "${GREEN}"

# Step 7: Verify installation
print_status "🔍 Verifying installation..." "${BLUE}"
print_status "📋 Available models:" "${BLUE}"
ollama list

print_status "🏃 Running processes:" "${BLUE}"
ollama ps

print_status "🎉 Ollama upgrade completed successfully!" "${GREEN}"