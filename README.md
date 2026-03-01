<div align="center">

# 🤖 OpenClaw on Android

**Run OpenClaw on Android — No proot, No Linux Distro**

*The easiest way to run OpenClaw on Termux*

[![Android 7.0+](https://img.shields.io/badge/Android-7.0%2B-brightgreen?style=for-the-badge)](https://github.com/Vamsiindugu/Openclaw-on-Android)
[![Termux](https://img.shields.io/badge/Termux-Required-orange?style=for-the-badge)](https://termux.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](CONTRIBUTING.md)

[🚀 Quick Start](#-quick-start) · [📖 Full Guide](#-full-guide) · [🔧 Troubleshooting](#-troubleshooting) · [🤝 Contribute](CONTRIBUTING.md)

---

*Because Android deserves a shell.*

**Native Performance · ~50MB Storage · 3-10 Min Setup**

</div>

---

## ✨ Why OpenClaw on Android?

<table>
<tr>
<td width="50%">

### 📱 Use Your Phone
- Repurpose old phones
- No mini PC needed
- Low power consumption
- Built-in UPS (battery)

</td>
<td width="50%">

### ⚡ Native Performance
- No proot overhead
- Runs directly in Termux
- Full OpenClaw features
- 24/7 operation ready

</td>
</tr>
<tr>
<td width="50%">

### 🔒 Private & Secure
- No personal data at risk
- Use factory-reset phones
- Local-first operation
- Your data stays on device

</td>
<td width="50%">

### 🎯 Simple Setup
- One command install
- Automatic patches
- Built-in verification
- Easy updates

</td>
</tr>
</table>

---

## 📊 vs proot-distro

| Metric | proot-distro | This Project |
|--------|--------------|--------------|
| **Storage** | 1-2GB | ~50MB |
| **Setup Time** | 20-30 min | 3-10 min |
| **Performance** | Slower (proot layer) | Native speed |
| **Complexity** | Multi-step | One command |

---

## 🚀 Quick Start

### Prerequisites
- Android 7.0+ (10+ recommended)
- ~500MB free storage
- Wi-Fi or mobile data

### Installation

```bash
# 1. Update Termux
pkg update -y && pkg upgrade -y

# 2. Install curl
pkg install curl -y

# 3. Run installer
curl -sL https://raw.githubusercontent.com/Vamsiindugu/Openclaw-on-Android/main/install.sh | bash

# 4. Activate environment
source ~/.bashrc

# 5. Start OpenClaw
openclaw gateway start
```

### What the installer does:

1. ✅ Validates environment (Termux, Node.js, storage)
2. ✅ Installs 22+ dependencies (cmake, clang, git, etc.)
3. ✅ Sets up paths and environment variables
4. ✅ Applies compatibility patches
5. ✅ Installs OpenClaw + clawhub
6. ✅ Verifies installation
7. ✅ Offers optional components (code-server, AI tools)

---

## 📖 Full Guide

### Navigation

| I want to... | Go to |
|--------------|-------|
| See all features | [✨ Features](#-features) |
| Learn about patches | [🔧 Compatibility Patches](#-compatibility-patches) |
| Use the CLI | [💻 CLI Commands](#-cli-commands) |
| Fix an issue | [🔧 Troubleshooting](#-troubleshooting) |
| See file structure | [📂 File Structure](#-file-structure) |
| Contribute | [🤝 Contributing](CONTRIBUTING.md) |
| See version history | [📜 Changelog](CHANGELOG.md) |

---

### ✨ Features

<details open>
<summary><b>🎯 Core Features</b></summary>

| Feature | Description |
|---------|-------------|
| **One-Command Install** | Just curl and bash — everything handled |
| **No proot-distro** | Runs natively in Termux |
| **Automatic Patches** | Handles Termux/Android quirks |
| **Built-in Verification** | Tests installation automatically |
| **Easy Updates** | `oa --update` handles everything |
| **Clean Uninstall** | `oa --uninstall` removes everything |

</details>

<details>
<summary><b>📦 Optional Components</b></summary>

| Component | Description |
|-----------|-------------|
| **code-server** | Browser-based VS Code IDE |
| **Claude Code CLI** | Anthropic's AI coding assistant |
| **Gemini CLI** | Google's AI assistant |
| **Codex CLI** | OpenAI's coding assistant |
| **ttyd** | Web terminal |
| **dufs** | File server |

</details>

<details>
<summary><b>🛡️ Android 12+ Support</b></summary>

Detects and warns about **Phantom Process Killer** which can terminate background processes.

**Fix:**
```bash
adb shell "settings put global settings_enable_monitor_phantom_procs false"
```

</details>

---

### 🔧 Compatibility Patches

| Patch | Purpose |
|-------|---------|
| `bionic-compat.js` | Bionic libc compatibility for Node.js |
| `termux-compat.h` | Build compatibility headers |
| `spawn.h` | posix_spawn stub for koffi module |
| `argon2-stub.js` | JS stub for code-server (no native argon2) |
| `systemctl` | Stub for systemd commands |
| `patch-paths.sh` | Patches hardcoded Linux paths |

---

### 💻 CLI Commands

#### Main Commands

```bash
oa              # Show help
oa --status     # Show detailed installation status
oa --update     # Update OpenClaw and patches
oa --uninstall  # Remove OpenClaw on Android
oa --version    # Show version
```

#### OpenClaw Commands

```bash
openclaw status         # System status
openclaw onboard        # Initial setup wizard
openclaw gateway start  # Start gateway
openclaw gateway stop   # Stop gateway
openclaw update         # Update OpenClaw
```

---

### 🔧 Troubleshooting

<details>
<summary><b>❓ openclaw command not found</b></summary>

```bash
source ~/.bashrc
```

If still not found, reinstall:
```bash
npm install -g openclaw@latest
```

</details>

<details>
<summary><b>❓ npm install fails</b></summary>

```bash
pkg install nodejs-lts -y
npm cache clean --force
```

</details>

<details>
<summary><b>❓ Build errors</b></summary>

Set environment variables:
```bash
export JOBS=1
export npm_config_jobs=1
export CFLAGS="-Wno-error=implicit-function-declaration"
export CXXFLAGS="-Wno-error=implicit-function-declaration"
```

</details>

<details>
<summary><b>❓ Gateway stops randomly</b></summary>

You're affected by Phantom Process Killer (Android 12+).

**Fix:**
```bash
# Enable wireless debugging in Developer Options
# Pair and connect via ADB
adb shell "settings put global settings_enable_monitor_phantom_procs false"
```

</details>

---

### 📂 File Structure

```
Openclaw-on-Android/
├── install.sh              # Main installer
├── oa.sh                   # CLI manager
├── update.sh               # Update wrapper
├── update-core.sh          # Core updater
├── uninstall.sh            # Uninstaller
│
├── scripts/
│   ├── check-env.sh        # Environment validation
│   ├── install-deps.sh     # Package installation
│   ├── setup-paths.sh      # Directory setup
│   ├── setup-env.sh        # Environment variables
│   ├── build-sharp.sh      # Sharp build
│   ├── install-ai-tools.sh # AI CLI installer
│   └── install-code-server.sh
│
├── patches/
│   ├── bionic-compat.js    # Bionic compatibility
│   ├── termux-compat.h     # Build headers
│   ├── spawn.h             # posix_spawn stub
│   ├── argon2-stub.js      # Argon2 stub
│   ├── systemctl           # Systemd stub
│   ├── apply-patches.sh    # Post-install patches
│   └── patch-paths.sh      # Path patching
│
└── tests/
    └── verify-install.sh   # Verification tests
```

---

## 🔋 Battery Protection

Running a phone 24/7 at 100% charge can cause battery swelling. Limit the max charge:

| Device | Setting |
|--------|---------|
| Samsung | Settings > Battery > Battery Protection → Maximum 80% |
| Google Pixel | Settings > Battery > Battery Protection → ON |
| Others | Search "battery protection" or "charge limit" |

---

## 🔗 Useful Links

| Resource | URL |
|----------|-----|
| OpenClaw Docs | https://docs.openclaw.ai |
| Clawhub (Skills) | https://clawhub.com |
| Discord Community | https://discord.gg/clawd |
| GitHub | https://github.com/openclaw/openclaw |

---

## 🤝 Contributing

We welcome contributions!

| Way | How |
|-----|-----|
| 🐛 Bug Reports | [Open an issue](https://github.com/Vamsiindugu/Openclaw-on-Android/issues/new?template=bug_report.md) |
| 💡 Feature Ideas | [Request a feature](https://github.com/Vamsiindugu/Openclaw-on-Android/issues/new?template=feature_request.md) |
| 📝 Code | Fork, modify, submit PR |

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📧 Contact

**Vamsi Indugu**

[![Portfolio](https://img.shields.io/badge/Portfolio-vamsiindugu.vercel.app-blue)](https://vamsiindugu.vercel.app/)
[![GitHub](https://img.shields.io/badge/GitHub-Vamsiindugu-black)](https://github.com/Vamsiindugu/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-vamsi--indugu-blue)](https://www.linkedin.com/in/vamsi-indugu/)

---

## 📄 License

MIT License — use it, modify it, make it yours.

See [LICENSE](LICENSE) for details.

---

<div align="center">

**Made with ❤️ and [OpenClaw](https://openclaw.ai)**

---

### ⚡ Quick Links

[Report Bug](https://github.com/Vamsiindugu/Openclaw-on-Android/issues/new?template=bug_report.md) · [Request Feature](https://github.com/Vamsiindugu/Openclaw-on-Android/issues/new?template=feature_request.md) · [View Changelog](CHANGELOG.md)

---

*Run OpenClaw anywhere. Even on your phone.*

</div>
