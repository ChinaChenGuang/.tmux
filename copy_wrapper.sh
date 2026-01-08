#!/bin/bash

# 自动检测环境并选择正确的剪切板工具
# 优先检测 Wayland (wl-copy)
if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy > /dev/null 2>&1; then
    wl-copy
# 其次检测 X11 (xclip)
elif [ -n "$DISPLAY" ] && command -v xclip > /dev/null 2>&1; then
    xclip -selection clipboard -i
# 再次尝试 xsel (作为备选)
elif [ -n "$DISPLAY" ] && command -v xsel > /dev/null 2>&1; then
    xsel -b -i
# 如果都失败，记录日志
else
    echo "No clipboard tool found" >> /tmp/tmux_copy_error.log
fi
