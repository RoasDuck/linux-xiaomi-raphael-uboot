#!/bin/bash
set -e

echo "[$(date +'%Y-%m-%d %H:%M:%S')] 🧠 配置 ZRAM Swap"

if [ ! -f rootdir/etc/default/zramswap ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')]   └─ 未找到 /etc/default/zramswap，跳过配置"
    exit 0
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')]   └─ 调整 zramswap 默认参数"
sed -i \
    -e 's/^ALGO=.*/ALGO=zstd/' \
    -e 's/^PERCENT=.*/# &/' \
    -e 's/^SIZE=.*/SIZE=10240/' \
    rootdir/etc/default/zramswap

echo "[$(date +'%Y-%m-%d %H:%M:%S')]   └─ 启用 zramswap 服务"
chroot rootdir systemctl enable zramswap

echo ""
echo "[/etc/default/zramswap]"
cat rootdir/etc/default/zramswap

echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✅ ZRAM 配置完成"
