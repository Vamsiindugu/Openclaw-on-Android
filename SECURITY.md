# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.2.x   | :white_check_mark: |
| < 1.2   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in OpenClaw on Android, please report it by:

1. **Do NOT open a public issue** - Security vulnerabilities should be reported privately
2. Email: security@openclaw.ai or DM on Discord: https://discord.gg/clawd
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Response Time

- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 48 hours
- **Fix Timeline**: Depends on severity (critical issues prioritized)

## Security Best Practices

When using OpenClaw on Android:

1. **Keep Termux updated** - Run `pkg update && pkg upgrade` regularly
2. **Use strong passwords** - If exposing OpenClaw gateway externally
3. **Disable Phantom Process Killer** - On Android 12+ for stable operation
4. **Review skills before installing** - Only install trusted skills from clawhub.com
5. **Regular backups** - Backup your `~/.openclaw` directory

## Known Security Considerations

### Phantom Process Killer (Android 12+)
Android 12+ may kill background processes without warning. This is a system-level behavior, not a security vulnerability, but can affect OpenClaw reliability.

**Mitigation**: 
```bash
adb shell "settings put global settings_enable_monitor_phantom_procs false"
```

### Network Exposure
If you expose OpenClaw gateway to the network:
- Use authentication (set a gateway token)
- Consider using Cloudflare Tunnel for secure external access
- Don't expose to untrusted networks

---

Thank you for helping keep OpenClaw on Android secure!
