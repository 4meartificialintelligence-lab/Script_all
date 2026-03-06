#!/usr/bin/env bash

# --- ตั้งค่าตัวแปร ---
REPO_URL="https://github.com/4meartificialintelligence-lab/Script_all.git"

echo "==========================================="
echo "   AD-BANK SYSTEM v1.0.1 (Starting...)     "
echo "==========================================="

# 1. ตรวจสอบว่ามี Git ในเครื่องไหม
if ! command -v git &> /dev/null; then
    echo "Error: กรุณาติดตั้ง git ก่อนใช้งานสคริปต์นี้"
    exit 1
fi

# 2. ตรวจสอบว่าเราอยู่ใน Repository หรือยัง 
# ถ้ายังไม่เป็น Git Repo ให้ Clone มาใหม่ ถ้าเป็นแล้วให้ Pull
if [ ! -d ".git" ]; then
    echo "[LOG] กำลังเริ่มต้นดาวน์โหลดไฟล์จาก GitHub..."
    git clone $REPO_URL .
else
    echo "[LOG] กำลังตรวจสอบการอัปเดตไฟล์ล่าสุด..."
    git pull origin main
fi

# 3. เริ่มรัน Logic หลักของพี่ตรงนี้
echo "-------------------------------------------"
echo "ระบบพร้อมใช้งาน! เริ่มรันงานหลัก..."
# ตัวอย่าง: node script_run.js หรือคำสั่งอื่นของพี่
echo "การทำงานเสร็จสิ้น!"
echo "==========================================="
