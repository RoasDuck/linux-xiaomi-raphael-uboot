#!/bin/bash
set -e

HOSTNAME="${HOSTNAME:-xiaomi-raphael}"
NAMESERVER="${NAMESERVER:-1.1.1.1}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] 🌐 配置网络和主机名"

rm -f rootdir/etc/resolv.conf
touch rootdir/etc/resolv.conf

echo "[$(date +'%Y-%m-%d %H:%M:%S')]   └─ 主机名: ${HOSTNAME}"
echo "[$(date +'%Y-%m-%d %H:%M:%S')]   └─ DNS: ${NAMESERVER}"

echo "nameserver ${NAMESERVER}" > rootdir/etc/resolv.conf
echo "${HOSTNAME}" > rootdir/etc/hostname
echo "127.0.0.1 localhost
127.0.1.1 ${HOSTNAME}" > rootdir/etc/hosts

echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✅ 网络配置完成"