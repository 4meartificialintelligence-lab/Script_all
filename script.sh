#!/bin/bash

# --- กำหนดค่าตัวแปร ---
# ใส่ TOKEN ของคุณที่นี่ หรือตั้งค่าเป็น Environment Variable: export GH_TOKEN=<your_token>
TOKEN="${GH_TOKEN:-}"
REPO_URL="https://${TOKEN}@github.com/Private-Cloud-Script/private_script.git"
QUICK_INSTALL_URL="https://${TOKEN}@raw.githubusercontent.com/Private-Cloud-Script/private_script/main/server_script/quick_install.sh"

echo "------------------------------------------"
echo "  [AD_BANK] เริ่มต้นการติดตั้งระบบอัตโนมัติ..."
echo "------------------------------------------"

# ตรวจสอบว่ามี TOKEN หรือไม่
if [ -z "$TOKEN" ]; then
    echo "Error: กรุณาตั้งค่า GH_TOKEN ก่อนใช้งาน"
    echo "ตัวอย่าง: export GH_TOKEN=<your_github_token>"
    exit 1
fi

# 1. ตรวจสอบสภาพแวดล้อม (Ubuntu หรือ Termux)
if command -v pkg >/dev/null 2>&1; then
    PM="pkg"
    SUDO=""
    TEMP_DIR=$TMPDIR
    echo "สถานะ: ตรวจพบ Termux"
else
    PM="apt"
    SUDO="sudo"
    TEMP_DIR="/tmp"
    echo "สถานะ: ตรวจพบ Linux/Ubuntu"
fi

# 2. อัปเดตและติดตั้ง Packages พื้นฐาน
echo ">> กำลังอัปเดตระบบ..."
$SUDO $PM update -y && $SUDO $PM upgrade -y
$SUDO $PM install jq git curl -y

# 3. ล้างไฟล์เก่าป้องกัน Error
echo ">> กำลังล้างข้อมูลเก่า..."
$SUDO rm -rf ~/private_script $TEMP_DIR/server_script

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

# 6. รัน Quick Install (ตบท้ายตามคำสั่งเดิม)
echo ">> กำลังรัน Quick Install ขั้นสุดท้าย..."
curl -fsSL "$QUICK_INSTALL_URL" | $SUDO bash

echo "------------------------------------------"
echo "  [AD_BANK] ติดตั้งทุกอย่างเรียบร้อยแล้ว!"
echo "------------------------------------------"
