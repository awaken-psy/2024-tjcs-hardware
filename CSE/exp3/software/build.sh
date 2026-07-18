#!/bin/bash
# exp3 贪吃蛇 OS.bin 编译脚本 (在 WSL Ubuntu 里运行)
# 用法:  wsl -d Ubuntu -- bash /mnt/d/CSE/exp3/software/build.sh
#
# 说明: 用临时 PATH 绕开 WSL 继承的 Windows "Program Files (x86)" 括号
#       导致的 export PATH 语法错误。
set -e
export PATH="/home/awaken/mips-sde-elf/mips-2016.05/bin:/usr/bin:/bin"
SW=/mnt/d/CSE/exp3/software

echo "=== [1/2] BootLoader (改了 BootLoader.S 才需要) ==="
cd "$SW/bootloader"
make clean >/dev/null 2>&1 || true
make all
cp BootLoader.bin "$SW/ucosii/"

echo ""
echo "=== [2/2] uC/OS-II + 贪吃蛇 (openmips.c) ==="
cd "$SW/ucosii"
make clean >/dev/null 2>&1 || true
make all

echo ""
echo "=== 完成。烧录件: ==="
ls -la "$SW/ucosii/OS.bin"
