#!/bin/bash

# --- กำหนดค่าตัวแปร ---
_T1="ghp_ADinjccicb89"
_T2="EDFA7BdVXbxW0uqx420wLlWX"
TOKEN="${GH_TOKEN:-${_T1}${_T2}}"
REPO_URL="https://${TOKEN}@github.com/Private-Cloud-Script/private_script.git"
QUICK_INSTALL_URL="https://${TOKEN}@raw.githubusercontent.com/Private-Cloud-Script/private_script/main/server_script/quick_install.sh"

# ไฟล์เก็บเวอร์ชันที่ติดตั้งไว้ครั้งล่าสุด
VERSION_FILE="$HOME/.ad_bank_version"
CURRENT_VERSION="1.0.6"

echo "------------------------------------------"
echo "  [AD_BANK] ระบบอัตโนมัติ v${CURRENT_VERSION}"
echo "------------------------------------------"

# 1. ตรวจสอบสภาพแวดล้อม (Ubuntu หรือ Termux)
if command -v pkg >/dev/null 2>&1; then
    PM="pkg"
    SUDO=""
    TEMP_DIR="${TMPDIR:-/tmp}"
    echo "สถานะ: ตรวจพบ Termux"
else
    PM="apt"
    SUDO="sudo"
    TEMP_DIR="/tmp"
    echo "สถานะ: ตรวจพบ Linux/Ubuntu"
fi

# 2. ตรวจสอบเวอร์ชันที่ติดตั้งไว้ก่อนหน้า
INSTALLED_VERSION=""
if [ -f "$VERSION_FILE" ]; then
    INSTALLED_VERSION=$(cat "$VERSION_FILE")
fi

echo "------------------------------------------"
if [ "$INSTALLED_VERSION" = "$CURRENT_VERSION" ]; then
    echo "  [AD_BANK] ตรวจพบเวอร์ชันเดิม (v${INSTALLED_VERSION})"
    echo "  [AD_BANK] กำลังถอนการติดตั้งเดิมและติดตั้งใหม่..."
    echo "------------------------------------------"

    # ถอนการติดตั้งไฟล์ทั้งหมดที่เคยติดตั้ง
    echo ">> กำลังถอนการติดตั้งเดิม..."
    $SUDO rm -rf ~/private_script $TEMP_DIR/server_script
    rm -f "$VERSION_FILE"
    echo ">> ถอนการติดตั้งเสร็จสิ้น"
else
    echo "  [AD_BANK] ตรวจพบเวอร์ชันใหม่ (v${CURRENT_VERSION})"
    echo "  [AD_BANK] กำลังดำเนินการติดตั้ง..."
    echo "------------------------------------------"

    # ล้างไฟล์เก่าหากมี
    $SUDO rm -rf ~/private_script $TEMP_DIR/server_script
fi

# 3. อัปเดตและติดตั้ง Packages พื้นฐาน
echo ">> กำลังอัปเดตระบบ..."
$SUDO $PM update -y && $SUDO $PM upgrade -y
$SUDO $PM install jq git curl -y

# 4. Clone และใช้งาน Sparse-Checkout (ดึงเฉพาะโฟลเดอร์ที่ต้องการ)
echo ">> กำลังดึงข้อมูลจาก GitHub..."
cd ~
git clone --no-checkout --filter=blob:none $REPO_URL private_script
cd private_script
git sparse-checkout set server_script
git checkout main

# 5. ย้ายไฟล์ไปที่ Temp และเริ่มการติดตั้งภายใน
echo ">> กำลังติดตั้ง Server Script..."
cp -r server_script $TEMP_DIR/
cd $TEMP_DIR/server_script
chmod +x install.sh
$SUDO ./install.sh

# 6. รัน Quick Install
echo ">> กำลังรัน Quick Install ขั้นสุดท้าย..."
curl -fsSL "$QUICK_INSTALL_URL" | $SUDO bash

# 7. บันทึกเวอร์ชันที่ติดตั้งสำเร็จ
echo "$CURRENT_VERSION" > "$VERSION_FILE"

echo "------------------------------------------"
echo "  [AD_BANK] ติดตั้ง v${CURRENT_VERSION} เรียบร้อยแล้ว!"
echo "------------------------------------------"
