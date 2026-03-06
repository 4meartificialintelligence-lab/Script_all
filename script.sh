#!/usr/bin/env bash

echo "--- Checking for updates from GitHub ---"
# สั่งให้ Git ไปดึงไฟล์ล่าสุดลงมา
git pull origin main

echo "--- Starting System ---"
# ตามด้วยคำสั่งรันงานของพี่
bash start_logic.sh 
