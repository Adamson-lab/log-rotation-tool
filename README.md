#!/usr/bin/env bash
# ==============================================================================
# Tool: Enterprise Log Rotation & Cleanup Engine
# Description: Safely compresses, rotates, and purges logs based on age/size.
# Author: Favour Adamson (Adamson-lab)
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-/var/log/custom-app}"
RETENTION_DAYS="${2:-7}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${YELLOW}[INFO]${NC}$(date '+%Y-%m-%d %H:%M:%S') | $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC}$(date '+%Y-%m-%d %H:%M:%S') | $1"; }
log_error() { echo -e "${RED}[ERROR]${NC}$(date '+%Y-%m-%d %H:%M:%S') | $1"; exit 1; }

# Pre-flight check: Verify target directory existence
if [[ ! -d "$TARGET_DIR" ]]; then
    log_error "Target log directory '$TARGET_DIR' does not exist or is unmounted."
fi

log_info "Starting log rotation pipeline for target: $TARGET_DIR (Retention Window:${RETENTION_DAYS} days)"

# Compress stagnant uncompressed logs older than 24 hours (1440 minutes)
log_info "Scanning for stagnant .log files exceeding 24 hours..."
COMPRESSED_COUNT=$(find "$TARGET_DIR" -type f -name "*.log" -mmin +1440 | wc -l)
if [[ "$COMPRESSED_COUNT" -gt 0 ]]; then
    find "$TARGET_DIR" -type f -name "*.log" -mmin +1440 -exec gzip -f {} \;
    log_success "Successfully compressed $COMPRESSED_COUNT stagnant log files."
else
    log_info "No stagnant uncompressed logs found requiring compression."
fi

# Purge compressed archives exceeding the retention threshold
log_info "Scanning for expired .log.gz archives older than $RETENTION_DAYS days..."
PURGE_COUNT=$(find "$TARGET_DIR" -type f -name "*.log.gz" -mtime +"$RETENTION_DAYS" | wc -l)
if [[ "$PURGE_COUNT" -gt 0 ]]; then
    find "$TARGET_DIR" -type f -name "*.log.gz" -mtime +"$RETENTION_DAYS" -exec rm -f {} \;
    log_success "Successfully purged $PURGE_COUNT expired log archives."
else
    log_info "No expired log archives found exceeding retention limit."
fi

log_success "Log rotation and cleanup cycle completed successfully without errors."
