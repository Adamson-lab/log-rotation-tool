# 🔄 Enterprise Log Rotation & Cleanup Engine (`log-rotation-tool`)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux / Ubuntu / Debian](https://img.shields.io/badge/Platform-Linux%20%7F%20WSL-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Automation: systemd Timers](https://img.shields.io/badge/Automation-systemd%20Timers-blueviolet)](https://www.freedesktop.org/wiki/Software/systemd/)
[![Security: Sandboxed](https://img.shields.io/badge/Security-Hardened%20Service-success)](https://www.cisecurity.org/)

A production-grade, fault-tolerant log rotation, compression, and purging pipeline engineered to eliminate disk exhaustion, prevent inode starvation, and stop Out-Of-Memory (OOM) daemon terminations in high-throughput enterprise environments.

---

## 🎯 Executive Summary & Threat Model

In modern cloud infrastructure, unmonitored application logging is a silent catalyst for catastrophic system failure. Unbounded log growth leads to three critical failure modes:
1. **Root Partition Exhaustion (`ENOSPC`)**: Fills `/var/log` or root blocks, causing system daemons (`sshd`, `systemd-journald`) to crash, rejecting incoming administrative sessions.
2. **Inode Starvation**: Rapid creation and deletion of thousands of micro-logs exhaust filesystem inodes long before raw disk capacity is reached.
3. **Unbounded Memory Retention**: Applications holding open file descriptors (FDs) to actively writing logs consume excessive memory buffers if files are abruptly deleted rather than safely truncated or rotated.

This toolkit solves these threats through **atomic file handling**, **stagnation-based gzip compression**, **configurable retention policies**, and **native systemd timer orchestration** backed by strict security sandboxing.

---

## 🏗️ Architecture & Execution Flow

The automation framework relies on a decoupled, non-interactive shell runner orchestrated by modern systemd oneshot services and persistent calendar timers.

```mermaid
sequenceDiagram
    autonumber
    participant Timer as systemd Timer (Daily)
    participant Service as systemd Service (Sandboxed)
    participant Script as rotate-logs.sh
    participant Target as Target Log Directory (/var/log/custom-app)
    
    Timer->>Service: Trigger scheduled execution (with jitter)
    Service->>Script: Execute /usr/local/bin/rotate-logs.sh
    Script->>Target: Validate target directory existence & permissions
    Target-->>Script: Validation Passed
    Script->>Target: Compress stagnant .log files older than 1440m (gzip -f)
    Target-->>Script: Compression complete (.log.gz archives created)
    Script->>Target: Purge compressed archives exceeding retention window (>7 days)
    Target-->>Script: Expired archives removed
    Script-->>Service: Exit 0 (Success)
    Service->>Journald: Log telemetry audit trail
