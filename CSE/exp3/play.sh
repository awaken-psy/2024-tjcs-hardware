#!/bin/bash
# 贪吃蛇启动脚本 (Git Bash / WSL / Linux)
# 用法: ./play.sh            自动找板子串口
#       ./play.sh COM3       指定 COM 口
#       ./play.sh --debug    调试模式(打印帧)
[ -f ~/.bashrc ] && source ~/.bashrc 2>/dev/null
[ -f ~/.bash_profile ] && source ~/.bash_profile 2>/dev/null
cd "$(dirname "$0")" || exit 1
python play.py "$@"
