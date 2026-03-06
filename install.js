#!/usr/bin/env node
const { execSync, spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

const scriptPath = path.join(__dirname, 'script.sh');
const isTermux = fs.existsSync('/data/data/com.termux');

// กำหนด bin path ตามสภาพแวดล้อม
let binDir;
if (isTermux) {
  binDir = '/data/data/com.termux/files/usr/bin';
} else {
  binDir = '/usr/local/bin';
}

const linkPath = path.join(binDir, 'run-on');

// ทำให้ script.sh รันได้
try {
  execSync(`chmod +x "${scriptPath}"`);
  console.log('[AD_BANK] chmod +x script.sh สำเร็จ');
} catch (e) {
  console.error('[AD_BANK] chmod error:', e.message);
}

// สร้าง symlink ให้ run-on ใช้งานได้จากทุกที่
try {
  if (fs.existsSync(linkPath)) {
    fs.unlinkSync(linkPath);
  }
  fs.symlinkSync(scriptPath, linkPath);
  console.log(`[AD_BANK] สร้าง symlink run-on -> ${scriptPath} สำเร็จ`);
} catch (e) {
  console.error('[AD_BANK] symlink error (อาจต้องการสิทธิ์ sudo):', e.message);
  // ลองใช้ sudo ถ้าไม่ใช่ Termux
  if (!isTermux) {
    try {
      execSync(`sudo ln -sf "${scriptPath}" "${linkPath}"`);
      console.log('[AD_BANK] สร้าง symlink ด้วย sudo สำเร็จ');
    } catch (e2) {
      console.error('[AD_BANK] sudo symlink error:', e2.message);
    }
  }
}

// รัน script.sh หลักทันที
console.log('[AD_BANK] กำลังรัน script.sh...');
const result = spawnSync('bash', [scriptPath], { stdio: 'inherit', shell: false });
if (result.status !== 0) {
  console.error('[AD_BANK] script.sh ออกด้วย error code:', result.status);
  process.exit(result.status || 1);
}
