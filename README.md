# OpenClaw on Android - ![Termux](https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=android&logoColor=white) ![OpenClaw](https://img.shields.io/badge/OpenClaw-4285F4?style=for-the-badge&logo=openai&logoColor=white) ![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)

![Platform](https://img.shields.io/badge/Platform-Android_7%2B-green.svg)
![ARM64](https://img.shields.io/badge/Architecture-ARM64-blue.svg)
![One-Line Install](https://img.shields.io/badge/Install-One_Line-ff69b4.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

The **easiest way** to run OpenClaw on Android. One paste, fully configured. No root, no proot, no headaches. 🚀

---

## 📚 Table of Contents

- [📌 What is OpenClaw?](#-what-is-openclaw)
- [✨ Features](#-features)
- [⚡ Quick Start](#-quick-start)
- [📋 Requirements](#-requirements)
- [🔧 Installation Guide](#-installation-guide)
- [🛠️ Commands & Aliases](#️-commands--aliases)
- [🌐 Browser Extension](#-browser-extension)
- [🤖 Telegram Bot Setup](#-telegram-bot-setup)
- [🛒 Skills Marketplace](#-skills-marketplace)
- [❓ Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📧 Contact](#-contact)

---

## 📌 What is OpenClaw?

OpenClaw is your **personal AI assistant** that runs locally on your device. Think JARVIS, but open-source and running on your Android phone. It can:

- 🗣️ **Voice interactions** - Talk to your AI assistant
- 🌐 **Browser automation** - Control Chrome/Chromium browsers
- 💬 **Telegram bot** - Chat with your AI via Telegram
- 🧠 **Skills system** - Extend capabilities with plugins
- 🔒 **Privacy-first** - Your data stays on your device

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **🚀 One-Line Install** | Copy, paste, done. No manual configuration. |
| **📱 Native Termux** | No proot-distro needed. Runs directly on Android. |
| **⚡ Lightweight** | ~50MB storage vs 1-2GB with Ubuntu proot |
| **⏱️ Fast Setup** | 3-10 minutes vs 20-30 minutes with proot |
| **🔋 Wake Lock** | Prevents background kills |
| **🎨 Aliases** | `oa`, `jarvis`, `claw-status` shortcuts |
| **🔧 Auto-config** | npm, Node.js memory limits, bashrc |

---

## ⚡ Quick Start

**After installing Termux, run these commands:**

```bash
# Step 1: Update Termux packages
pkg update -y && pkg upgrade -y

# Step 2: Install curl (required for one-liner)
pkg install curl -y

# Step 3: Run the one-liner installer
curl -sL https://raw.githubusercontent.com/Vamsiindugu/Openclaw-on-Android/main/install.sh | bash
```

After installation:

```bash
source ~/.bashrc    # Activate aliases
openclaw status     # Check system status
openclaw init       # Run initial setup
```

---

## 📋 Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **Android** | 7.0+ | 10.0+ |
| **RAM** | 2GB | 4GB+ |
| **Storage** | 500MB | 1GB+ |
| **Architecture** | ARM64 | ARM64 |
| **Termux** | Latest | From F-Droid |

> ⚠️ **Important**: Install Termux from **F-Droid**, not Play Store. Play Store version is outdated.

---

## 🔧 Installation Guide

### Step 1: Install Termux

Download from F-Droid (recommended):
```
https://f-droid.org/packages/com.termux/
```

### Step 2: Update Termux & Install curl

```bash
pkg update -y && pkg upgrade -y
pkg install curl -y
```

### Step 3: Run Installer

```bash
curl -sL https://raw.githubusercontent.com/Vamsiindugu/Openclaw-on-Android/main/install.sh | bash
```

### Step 4: Initialize

```bash
source ~/.bashrc
openclaw init
```

### Step 5: Start Gateway (Optional)

```bash
openclaw gateway start
```

---

## 🛠️ Commands & Aliases

### Main Commands

| Command | Description |
|---------|-------------|
| `openclaw` | Main CLI |
| `openclaw init` | Initialize configuration |
| `openclaw status` | Check system status |
| `openclaw gateway start` | Start gateway server |
| `openclaw gateway stop` | Stop gateway server |
| `openclaw chat` | Start interactive chat |
| `openclaw --help` | Show all commands |

### Aliases (Auto-added to .bashrc)

| Alias | Command |
|-------|---------|
| `oa` | `openclaw` |
| `ocl` | `openclaw` |
| `jarvis` | `openclaw chat` |
| `claw-status` | `openclaw status` |
| `claw-start` | `openclaw gateway start` |
| `claw-stop` | `openclaw gateway stop` |

---

## 🌐 Browser Extension

For browser automation on Android, use **Lemur Browser** or **Kiwi Browser** (they support Chrome extensions).

### Setup Steps

1. Install **Lemur Browser** from Play Store
2. Install the OpenClaw Browser Extension:
   ```bash
   openclaw browser extension install
   openclaw browser extension path  # Shows installed path
   ```
3. In Lemur Browser, go to `chrome://extensions`
4. Enable **Developer mode** (toggle in top-right)
5. Click **Load unpacked** → Select the extension directory
6. Pin the extension for easy access
7. Click the extension icon and configure:
   - **Port**: `18792` (or `gateway_port + 3`)
   - **Gateway Token**: Your token from `~/.openclaw/openclaw.json`

### Usage

- Open the tab you want to control
- Click the extension icon (badge shows `ON` when attached)
- OpenClaw can now control that tab

---

## 🤖 Telegram Bot Setup

Turn your OpenClaw into a Telegram bot:

### Step 1: Create Bot

1. Open Telegram and search for **@BotFather**
2. Send `/newbot` and follow prompts
3. Save the **bot token** (format: `123456789:ABCDefGHIjklMNOpqrsTUVwxyz`)

### Step 2: Configure OpenClaw

Edit `~/.openclaw/openclaw.json`:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN_HERE",
      "dmPolicy": "pairing"
    }
  }
}
```

### Step 3: Start Gateway

```bash
openclaw gateway start
```

### Step 4: Pair Your Account

1. Message your bot on Telegram
2. Run the pairing command:
   ```bash
   openclaw pairing list telegram
   openclaw pairing approve telegram <PAIRING_CODE>
   ```

### Finding Your Telegram User ID

- Message **@userinfobot** on Telegram
- Or check logs: `openclaw logs --follow` and look for `from.id`

> 📖 **Full docs**: https://docs.openclaw.ai/channels/telegram

---

## 🛒 Skills Marketplace

Extend OpenClaw with skills from **ClawHub**:

| Skill | Description |
|-------|-------------|
| `skillboss` | Fullstack app builder |
| `qmd-skill` | Markdown search |
| `x-research` | X/Twitter research |
| `weather` | Weather forecasts |
| `humanizer` | AI text humanizer |

Browse more: **https://clawhub.com**

---

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| **make: -j option requires positive integer** | Fixed in v1.1.2. Manual: `export JOBS=1` before npm install |
| **cmake not found (koffi build fails)** | Install cmake: `pkg install cmake` then retry |
| **npm install fails** | Run `pkg upgrade && npm cache clean --force` |
| **Memory error** | Check `echo $NODE_OPTIONS` (should show 4096) |
| **Gateway won't start** | Check port: `lsof -i :18789` and kill process |
| **Termux killed in background** | Enable wake lock: `termux-wake-lock` |
| **Permission denied** | Run `termux-setup-storage` |
| **command not found: openclaw** | Run `hash -r` or `source ~/.bashrc` |

### Get Help

- 💬 **Discord**: https://discord.gg/clawd
- 📖 **Docs**: https://docs.openclaw.ai
- 🐛 **Issues**: https://github.com/openclaw/openclaw/issues

---

## 🤝 Contributing

Contributions welcome! 🙌

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📧 Contact

### Vamsi Indugu
- 💌 Email: [vamsiindugu@gmail.com](mailto:vamsiindugu@gmail.com)
- 🌐 Portfolio: [vamsiindugu.vercel.app](https://vamsiindugu.vercel.app/)
- 🐱 GitHub: [@Vamsiindugu](https://github.com/Vamsiindugu/)
- 💼 LinkedIn: [vamsi-indugu](https://www.linkedin.com/in/vamsi-indugu/)

---

## 🔗 Links

| Resource | URL |
|----------|-----|
| **OpenClaw Docs** | https://docs.openclaw.ai |
| **GitHub** | https://github.com/openclaw/openclaw |
| **Discord** | https://discord.gg/clawd |
| **ClawHub (Skills)** | https://clawhub.com |
| **Termux (F-Droid)** | https://f-droid.org/packages/com.termux/ |

---

© 2026 Vamsi Indugu. All rights reserved.

**Made with ❤️ for the Android community.**

---

![Star](https://img.shields.io/github/stars/Vamsiindugu/Openclaw-on-android?style=social) ![Fork](https://img.shields.io/github/forks/Vamsiindugu/Openclaw-on-android?style=social)
