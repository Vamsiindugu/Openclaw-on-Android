# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] - 2026-03-01

### Added
- `patches/patch-paths.sh` - Patches hardcoded Linux paths in OpenClaw
- `patches/argon2-stub.js` - JS stub replacing native argon2 for code-server
- `patches/systemctl` - Stub for systemd commands on Termux
- `scripts/install-ai-tools.sh` - Interactive AI CLI tools installer
- `scripts/install-code-server.sh` - Browser-based VS Code installer
- `tests/verify-install.sh` - Installation verification tests
- `uninstall.sh` - Clean uninstaller with confirmation prompts
- `update-core.sh` - Core updater logic for `oa --update`
- `COMPARISON.md` - Detailed comparison with proot-distro approach
- Phantom Process Killer detection for Android 12+
- Node.js v24+ undici dependency fix for clawhub
- Path patching step in installer

### Changed
- Improved `install.sh` with:
  - Step count increased from 9 to 10 (added verification)
  - Optional code-server installation prompt
  - Optional AI CLI tools installation prompt
  - Path patching step
  - Phantom Process Killer warning
  - undici fix for clawhub
- Improved `oa.sh` with:
  - `--status` - Comprehensive status display
  - `--uninstall` - Clean uninstall
  - `--version` - Version with update check
  - `--help` - Usage information
  - Phantom Process Killer status in `--status`
- Completely rewrote `README.md` with full documentation

### Fixed
- Path patching now handles all hardcoded paths
- clawhub works on Node.js v24+ with undici

## [1.2.0] - 2026-02-28

### Added
- Initial public release
- `install.sh` - Main installer script
- `oa.sh` - CLI manager command
- `update.sh` - Thin update wrapper
- `scripts/check-env.sh` - Environment validation
- `scripts/install-deps.sh` - Package installation
- `scripts/setup-paths.sh` - Directory setup
- `scripts/setup-env.sh` - Environment configuration
- `scripts/build-sharp.sh` - Sharp image library build script
- `patches/bionic-compat.js` - Bionic libc compatibility
- `patches/termux-compat.h` - Build compatibility headers
- `patches/spawn.h` - posix_spawn stub for koffi module
- `patches/apply-patches.sh` - Post-install patch application
- `LICENSE` - MIT License
- `README.md` - Basic documentation
- `CONTRIBUTING.md` - Contribution guidelines

### Features
- One-command installation
- No proot-distro required
- Native Termux support
- Compatibility patches for Android/Bionic
- Automatic environment configuration
- Sharp build support
- clawhub integration

---

## Roadmap

### [1.3.0] - Planned
- [ ] Support for termux-api commands
- [ ] Automatic startup via termux-boot
- [ ] Backup/restore configuration
- [ ] Health monitoring service

### [2.0.0] - Future
- [ ] Support for other Android terminals (Monu, etc.)
- [ ] Graphical installer (optional)
- [ ] Integration with Android notification system

---

[1.2.1]: https://github.com/Vamsiindugu/Openclaw-on-Android/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/Vamsiindugu/Openclaw-on-Android/releases/tag/v1.2.0
