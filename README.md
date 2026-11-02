# 🔄 Enterprise Log Rotation & Cleanup Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux%20%2F%20WSL-orange.svg)](https://www.linux.org/)

A production-grade, automated log rotation, compression, and purging engine paired with modern **systemd timers** to prevent disk exhaustion and out-of-memory (OOM) failures in enterprise environments.

---

## 📂 Repository Structure

```text
log-rotation-tool/
├── scripts/
│   └── rotate-logs.sh          # Core rotation, compression, and purging engine
├── systemd/
│   ├── log-rotator.service     # Systemd oneshot execution unit
│   └── log-rotator.timer       # Native systemd recurring timer (Daily)
└── README.md
