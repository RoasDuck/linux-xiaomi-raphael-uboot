#!/bin/bash
set -e

KERNEL_DEBS_DIR="${KERNEL_DEBS_DIR:-.}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09] 🧠 安装内核"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 内核包目录: ${KERNEL_DEBS_DIR}"

cp ${KERNEL_DEBS_DIR}/*-xiaomi-raphael.deb rootdir/tmp/

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 安装 linux-image..."
chroot rootdir dpkg -i /tmp/linux-image-xiaomi-raphael.deb

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 安装 linux-headers..."
chroot rootdir dpkg -i /tmp/linux-headers-xiaomi-raphael.deb

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 安装 firmware..."
chroot rootdir dpkg -i /tmp/firmware-xiaomi-raphael.deb

rm rootdir/tmp/*-xiaomi-raphael.deb

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 创建自定义 initramfs firmware hook..."
cat > rootdir/etc/initramfs-tools/hooks/custom-qcom-firmware << 'EOF'
#!/bin/sh
PREREQ=""
prereqs() {
    echo "$PREREQ"
}
case $1 in
prereqs)
    prereqs
    exit 0
    ;;
esac

. /usr/share/initramfs-tools/hook-functions

copy_exec /lib/firmware/qcom/a630_sqe.fw
copy_exec /lib/firmware/qcom/a640_gmu.bin
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/modem.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/modemr.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/modemuw.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/ipa_fws.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/adsp.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/adsps.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/adspr.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/adspua.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/cdsp.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/cdspr.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/slpi.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/slpir.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/slpius.jsn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/venus.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/a640_zap.mbn
copy_exec /lib/firmware/qcom/sm8150/Xiaomi/raphael/wlanmdsp.mbn
EOF
chmod +x rootdir/etc/initramfs-tools/hooks/custom-qcom-firmware

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09]   └─ 更新 initramfs..."
chroot rootdir update-initramfs -c -k all

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [09] ✅ 内核安装完成"
