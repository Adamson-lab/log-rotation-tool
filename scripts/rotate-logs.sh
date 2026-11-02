#!/usr/bin/env bash
# ==============================================================================
# Tool: Enterprise Log Rotation & Cleanup Engine
# Description: Safely compresses, rotates, and purges logs based on age/size.
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-/var/log/custom-app}"
RETENTION_DAYS="${2:-7}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [[ ! -d "$TARGET_DIR" ]]; then
    log_error "Target log directory '$TARGET_DIR' does not exist."
fi

log_info "Starting log rotation pipeline for: $TARGET_DIR (Retention: ${RETENTION_DAYS}d)"

log_info "Compressing stagnant log files..."
find "$TARGET_DIR" -type f -name "*.log" -mmin +1440 -exec gzip -f {} \;
log_success "Log compression completed."

log_info "Purging archives older than $RETENTION_DAYS days..."
find "$TARGET_DIR" -type f -name "*.log.gz" -mtime +"$RETENTION_DAYS" -exec rm -f {} \;
log_success "Expired log archives purged successfully."

log_success "Log rotation and cleanup cycle completed without errors."
