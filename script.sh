#!/usr/bin/env bash

REPO_URL="https://github.com/4meartificialintelligence-lab/Script_all.git"

if [ ! -d "Script_all" ]; then
  echo "ไม่พบโฟลเดอร์ กำลังดาวน์โหลดจาก GitHub..."
  git clone $REPO_URL
else
  echo "พบโฟลเดอร์แล้ว กำลังอัปเดต..."
  cd Script_all && git pull
fi
