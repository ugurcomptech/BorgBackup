#!/bin/bash
# Restore script
REPO="ssh://root@backup-sunucu-ip//backups/"
SSH_PASS="SSH_PAROLANIZ"
BORG_PASSPHRASE="BORG_REPO_PAROLANIZ"

ARCHIVE_NAME="$1"
TARGET_DIR="$2"

mkdir -p "$TARGET_DIR"
export BORG_PASSPHRASE="$BORG_PASSPHRASE"
export BORG_RSH="sshpass -p '$SSH_PASS' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

cd "$TARGET_DIR" || exit 2

borg extract --remote-path borg "$REPO::$ARCHIVE_NAME" --pattern '+ etc/haproxy/**' --pattern '- **'

unset BORG_PASSPHRASE
unset BORG_RSH
