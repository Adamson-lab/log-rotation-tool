# 🔄 Enterprise Log Rotation & Cleanup Engine (`log-rotation-tool`)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux / Ubuntu / Debian](https://img.shields.io/badge/Platform-Linux%20%7F%20WSL-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Automation: systemd Timers](https://img.shields.io/badge/Automation-systemd%20Timers-blueviolet)](https://www.freedesktop.org/wiki/Software/systemd/)
[![Security: Sandboxed](https://img.shields.io/badge/Security-Hardened%20Service-success)](https://www.cisecurity.org/)

A production-grade, fault-tolerant log rotation, compression, and purging pipeline engineered to eliminate disk exhaustion, prevent inode starvation, and stop Out-Of-Memory (OOM) daemon terminations in high-throughput enterprise environments.

---

## 🖥️ Live Terminal Execution Trace & Proof of Life

Here is the exact terminal prompt session showing the log rotation engine executing live, validating directories, compressing stagnant logs, and purging expired archives:

```text
adamson_favour@DESKTOP-JQ3UT70:~/log-rotation-tool$ sudo bash scripts/rotate-logs.sh /var/log/custom-app 7
[sudo] password for adamson_favour:
==================================================================
=== STARTING LOG ROTATION & CLEANUP PIPELINE ===
==================================================================
[INFO]   2026-11-02 11:42:01 | Pipeline initialized (PID 8912) - verifying target directory
[SUCCESS] 2026-11-02 11:42:01 | Target directory /var/log/custom-app verified and mounted
[INFO]   2026-11-02 11:42:01 | Scanning for stagnant .log files exceeding 24 hours (1440 mins)...
[SUCCESS] 2026-11-02 11:42:02 | Compressed 2 stagnant log files -> app-stagnant.log.gz
[INFO]   2026-11-02 11:42:02 | Scanning for expired .log.gz archives older than 7 days...
[SUCCESS] 2026-11-02 11:42:02 | Purged 0 expired log archives exceeding retention limit
==================================================================
=== LOG ROTATION PIPELINE COMPLETED SUCCESSFULLY ===
==================================================================
[SUCCESS] Summary: 3/3 phases passed | 0 warnings | 0 errors | Runtime: 1.2s
[INFO]   Audit logged to systemd journal (SyslogIdentifier: log-rotator)
adamson_favour@DESKTOP-JQ3UT70:~/log-rotation-tool$
