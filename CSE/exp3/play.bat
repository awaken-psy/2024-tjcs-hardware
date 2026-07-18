@echo off
REM 贪吃蛇启动脚本 - 双击或在命令行运行
REM 用法: play.bat            自动找板子串口
REM       play.bat COM3       指定 COM 口
REM       play.bat --debug    调试模式(打印帧)
cd /d "%~dp0%"
python play.py %*
echo.
pause
