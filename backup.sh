#!/bin/bash
# Backup script
REPO="ssh://root@backup-sunucu-ip//backups/"
SSH_PASS="SSH_PAROLANIZ"
BORG_PASSPHRASE="BORG_REPO_PAROLANIZ"
SOURCE_DIRS="/var/www /etc/haproxy"
ARCHIVE_NAME="web1-$(date +%Y-%m-%d_%H-%M)"

export BORG_PASSPHRASE="$BORG_PASSPHRASE"
export BORG_RSH="sshpass -p '$SSH_PASS' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

borg create --progress --stats "$REPO::$ARCHIVE_NAME" $SOURCE_DIRS
unset BORG_PASSPHRASE
unset BORG_RSH
