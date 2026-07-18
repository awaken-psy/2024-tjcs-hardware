#!/usr/bin/env python3
"""贪吃蛇协议调试脚本：串口收 41 字节帧，解析并打印状态 + 位图 ASCII。
用法: python debug_rx.py [COM口]   (默认 COM3)

帧格式(与 FPGA 端 openmips.c 一致):
  [0,1] 0xAA 0x55 头
  [2]   state (3=READY 0=RUNNING 1=OVER 2=WIN)
  [3,4] score 小端
  [5]   food  (fx<<4 | fy)
  [6]   head  (hx<<4 | hy)
  [7]   length
  [8..39] 16x16 位图(蛇身=1), 行优先, 每字节高位在前
  [40]  checksum = bytes[2..39] 的 XOR
"""
import serial, sys

FR_LEN = 41
HEAD = bytes([0xAA, 0x55])
STATE_NAME = {0: "RUNNING", 1: "GAMEOVER", 2: "WIN", 3: "READY"}


def parse(frame):
    state = frame[2]
    score = frame[3] | (frame[4] << 8)
    fx, fy = frame[5] >> 4, frame[5] & 0xF
    hx, hy = frame[6] >> 4, frame[6] & 0xF
    length = frame[7]
    bitmap = frame[8:40]
    chk = 0
    for b in frame[2:40]:
        chk ^= b
    ok = (chk == frame[40])
    return state, score, fx, fy, hx, hy, length, bitmap, ok


def bitmap_ascii(bitmap, hx, hy, fx, fy):
    out = []
    for y in range(16):
        row = ""
        for x in range(16):
            idx = y * 16 + x
            bit = (bitmap[idx >> 3] >> (7 - (idx & 7))) & 1
            if x == fx and y == fy:
                row += "**"
            elif x == hx and y == hy:
                row += "@@"
            elif bit:
                row += "[]"
            else:
                row += ". "
        out.append(row)
    return "\n".join(out)


def main():
    port = sys.argv[1] if len(sys.argv) > 1 else "COM3"
    ser = serial.Serial(port, 4800, timeout=0.1)
    print(f"listening on {port} @4800 8N1 ...  (Ctrl+C 退出)")
    buf = bytearray()
    try:
        while True:
            data = ser.read(64)
            if not data:
                continue
            buf.extend(data)
            while True:
                i = buf.find(HEAD)
                if i < 0:
                    if len(buf) >= 2:
                        del buf[:-1]
                    break
                if len(buf) - i >= FR_LEN:
                    frame = bytes(buf[i:i + FR_LEN])
                    del buf[:i + FR_LEN]
                    res = parse(frame)
                    if not res[8]:
                        continue  # 校验失败，跳过
                    state, score, fx, fy, hx, hy, length, bitmap, _ = res
                    print(f"[{STATE_NAME.get(state, '?')}] score={score} "
                          f"food=({fx},{fy}) head=({hx},{hy}) len={length}")
                    print(bitmap_ascii(bitmap, hx, hy, fx, fy))
                    print("-" * 50)
                else:
                    del buf[:i]
                    break
    except KeyboardInterrupt:
        print("\nbye")


if __name__ == "__main__":
    main()
