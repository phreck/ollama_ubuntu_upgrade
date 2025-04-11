# Ollama Upgrade Script 🚀

A bash script to safely upgrade [Ollama](https://ollama.com/) on Ubuntu/Linux systems while preserving your custom service configurations.

## 🔍 Overview

This script automates the process of upgrading Ollama while ensuring that your custom systemd service configuration is maintained. It provides colorful, emoji-enhanced output to clearly show the progress of each step.

## ✨ Features

- 🛡️ Preserves your custom Ollama service configuration
- 🎨 Colorful, informative output with emojis
- 🔄 Seamless upgrade process with minimal downtime
- ✅ Verification steps to confirm successful installation
- 🚨 Error checking for critical operations

## 📋 Prerequisites

- Ubuntu/Linux system with Ollama installed
- `systemd` for service management
- Sudo privileges

## 🚀 Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/phreck/ollama_ubuntu_upgrade.git
   cd ollama_ubuntu_upgrade
   ```

2. Make the script executable:
   ```bash
   chmod +x upgrade_ollama.sh
   ```

3. Run the script with sudo:
   ```bash
   sudo ./upgrade_ollama.sh
   ```

## 📝 What the Script Does

1. Stops the running Ollama service
2. Backs up your custom service configuration
3. Downloads and installs the latest version of Ollama
4. Restores your custom service configuration
5. Reloads systemd and restarts Ollama
6. Verifies the installation by checking available models and running processes

## ⚠️ Important Notes

- This script is intended for systems where you have customized the Ollama systemd service
- Always ensure you have a backup of your important data before performing any system upgrades
- If you encounter any issues, please create an issue in this repository

## 📜 License

MIT License - feel free to modify and distribute as needed.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

If you have any questions or suggestions, please open an issue or contact [your contact information].

---

*Last updated: April 11, 2025*