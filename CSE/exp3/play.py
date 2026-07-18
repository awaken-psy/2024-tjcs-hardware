#!/usr/bin/env python3
"""贪吃蛇启动器：自动找板子串口启动 pygame GUI。
用法:
    python play.py            自动检测板子串口
    python play.py COM3       手动指定 COM 口
    python play.py --debug    用 debug_rx.py（打印帧）替代 GUI
"""
import sys, subprocess, os
from serial.tools import list_ports

# 板子 USB-UART 常见描述关键字；排除蓝牙等
KEYS = ('usb serial', 'digilent', 'ftdi', 'ft231', 'mbed', 'prolific', 'ch340', 'cp210', 'qinheng')
EXCLUDE = ('bluetooth', '蓝牙')


def find_ports():
    out = []
    for p in list_ports.comports():
        d = (p.description or '').lower()
        if any(x in d for x in EXCLUDE):
            continue
        if any(k in d for k in KEYS):
            out.append(p.device)
    return out


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    debug = '--debug' in sys.argv
    args = [a for a in sys.argv[1:] if a != '--debug']
    script = os.path.join(here, 'pc', 'debug_rx.py' if debug else 'snake_gui.py')

    if args:
        port = args[0]
    else:
        cands = find_ports()
        if len(cands) == 1:
            port = cands[0]
            print(f"自动检测到板子串口：{port}")
        else:
            print("请选择板子串口（排除蓝牙）：")
            for p in list_ports.comports():
                mark = '  <- 可能是板子' if p.device in cands else ''
                print(f"  {p.device:<6} {p.description}{mark}")
            port = input("\n输入 COM 口回车启动 (如 COM3): ").strip()

    print(f"启动 {'调试模式' if debug else '贪吃蛇'} @ {port} ...(ESC 退出)\n")
    subprocess.call([sys.executable, script, port])


if __name__ == '__main__':
    main()
