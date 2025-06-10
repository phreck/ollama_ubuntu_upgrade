#!/bin/bash
#
# A script to upgrade Ollama while preserving a custom systemd service file.
# It will automatically prompt for sudo if not run as root.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Check for root privileges and re-launch with sudo if necessary.
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges to manage systemd services."
  echo "Please enter your password to continue."
  # Re-execute the script with sudo, passing all original arguments.
  sudo -- "$0" "$@"
  # Exit the original, non-privileged script.
  exit $?
fi


# Colors and formatting
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'     # No Color
BOLD='\033[1m'

# Service file paths
SERVICE_FILE_PATH="/etc/systemd/system/ollama.service"
BACKUP_FILE_PATH="/tmp/ollama.service.bak"

# --- Functions ---
# Function to print styled status messages
print_status() {
  # Usage: print_status "Message" "$COLOR"
  echo -e "${BOLD}${2}${1}${NC}"
}

# --- Main Script ---
print_status "🚀 Starting Ollama upgrade process..." "$BLUE"

# Step 1: Backup current service file (if it exists)
if [ -f "$SERVICE_FILE_PATH" ]; then
  print_status "📁 Backing up current service configuration..." "$YELLOW"
  # Use -p to preserve permissions and ownership
  cp -p "$SERVICE_FILE_PATH" "$BACKUP_FILE_PATH"
  print_status "✅ Service configuration backed up to $BACKUP_FILE_PATH" "$GREEN"
else
  print_status "ℹ️ No existing service file found to back up. A new one will be created." "$BLUE"
fi

# Step 2: Stop Ollama service
print_status "🛑 Stopping Ollama service (if running)..." "$YELLOW"
# Use 'systemctl is-active --quiet' to avoid errors if the service is not running
if systemctl is-active --quiet ollama.service; then
  systemctl stop ollama.service
  print_status "✅ Ollama service stopped." "$GREEN"
else
  print_status "✅ Ollama service was not running." "$GREEN"
fi

# Step 3: Install the latest version of Ollama
print_status "📥 Downloading and installing latest Ollama version..." "$YELLOW"
curl -fsSL https://ollama.com/install.sh | sh
print_status "✅ Latest Ollama version installed." "$GREEN"

# Step 4: Restore custom service configuration (if a backup was made)
if [ -f "$BACKUP_FILE_PATH" ]; then
  print_status "🔄 Restoring your custom service configuration..." "$YELLOW"
  # The installer might start the service, so stop it first
  systemctl stop ollama.service
  # Use -p to preserve permissions and ownership
  cp -p "$BACKUP_FILE_PATH" "$SERVICE_FILE_PATH"
  print_status "✅ Custom service configuration restored." "$GREEN"
  # Clean up the backup file
  rm "$BACKUP_FILE_PATH"
fi

# Step 5: Reload systemd and start Ollama
print_status "🔄 Reloading systemd daemon..." "$YELLOW"
systemctl daemon-reload
print_status "✅ Systemd daemon reloaded." "$GREEN"

print_status "▶️ Starting Ollama service..." "$YELLOW"
systemctl start ollama.service
print_status "✅ Ollama service started." "$GREEN"

# Step 6: Verify installation
print_status "🔍 Verifying installation..." "$BLUE"
ollama --version
print_status "✅ All systems go!" "$GREEN"
print_status "🎉 Ollama upgrade completed successfully!" "$GREEN"