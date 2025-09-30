# Borg Backup & Restore Scripts

Bu repo, BorgBackup kullanarak sunucuların yedeklerini almak ve geri yüklemek için hazırlanmış scriptleri içerir.  
İster tek bir klasörü, ister birden fazla klasörü yedekleyebilir ve backup sunucusundan geri çekebilirsiniz.

---

## Manuel Borg Backup ve Restore

### Repo Oluşturma (Backup Sunucusunda)
```bash
borg init --encryption=repokey /backups/server1
```

### Yedek Alma (Client Sunucudan Backup Sunucusuna)
Örnek: `/etc/haproxy` klasörünü yedekleme
```bash
borg create --progress --stats \
ssh://root@backup-sunucu-ip//backups/IDS-IPS::haproxy-www-$(date +%Y-%m-%d_%H-%M) \
/etc/haproxy
```

### Yedekten Geri Yükleme
Belirli bir klasörü geri yüklemek için:
```bash
borg extract --remote-path borg \
ssh://root@backup-sunucu-ip//backups/server1::www-2025-09-30_10-35 \
--pattern '+ var/www/html/html/example.com/**' \
--pattern '- **'
```

---

## Scriptler

### 1. backup.sh
Client sunucudan backup sunucusuna gönderir.
```bash
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
```

### 2. restore.sh
Sadece `/etc/haproxy` klasörünü geri yükler.
```bash
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
```

---

## Kullanım

1. `backup.sh` ile yedek almak için:
```bash
./backup.sh
```

2. `restore.sh` ile yedeği geri almak için:
```bash
./restore.sh <archive_name> <target_directory>
```

---

## Notlar
- Scriptlerdeki değerleri kendi sunucu bilgileriniz ile değiştirin.
- `sshpass` kurulumu gereklidir.
- Borg passphrase ve SSH parolası güvenli şekilde saklanmalıdır.

