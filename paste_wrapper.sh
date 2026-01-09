#!/bin/bash

# 自动检测环境并输出剪切板内容
# 优先检测 Wayland (wl-paste)
if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-paste > /dev/null 2>&1; then
    wl-paste --no-newline
# 其次检测 X11 (xclip)
elif [ -n "$DISPLAY" ] && command -v xclip > /dev/null 2>&1; then
    xclip -selection clipboard -o
# 再次尝试 xsel (作为备选)
elif [ -n "$DISPLAY" ] && command -v xsel > /dev/null 2>&1; then
    xsel -b -o
fi
