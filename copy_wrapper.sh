#!/bin/bash

# 尝试从 Tmux 获取最新的 client_display (解决 detach/attach 后 DISPLAY 变量过时的问题)
if [ -n "$TMUX" ] && command -v tmux > /dev/null 2>&1; then
    NEW_DISPLAY=$(tmux display-message -p "#{client_display}" 2>/dev/null)
    if [ -n "$NEW_DISPLAY" ]; then
        export DISPLAY="$NEW_DISPLAY"
    fi
fi

# 读取输入 (由于需要同时分发给多种后端，先存入变量)
# 注意：若内容极大可能会占用内存，但一般剪贴板文本可接受
input=$(cat)

# --- 1. 本地 VM 环境剪贴板 (X11/Wayland) ---
if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy > /dev/null 2>&1; then
    echo -n "$input" | wl-copy
elif [ -n "$DISPLAY" ] && command -v xclip > /dev/null 2>&1; then
    # 同时写入 clipboard 和 primary 选区
    echo -n "$input" | xclip -selection clipboard -i
    echo -n "$input" | xclip -selection primary -i
elif [ -n "$DISPLAY" ] && command -v xsel > /dev/null 2>&1; then
    echo -n "$input" | xsel -b -i
fi

# --- 2. OSC 52 (同步到宿主机终端) ---
# 即使 VM Tools 失效，只要终端支持 OSC 52 (如 WezTerm, iTerm2)，也能同步到宿主机
if [ -n "$TMUX" ] && command -v base64 > /dev/null 2>&1; then
    # 获取当前连接的客户端 TTY
    target_tty=$(tmux display-message -p "#{client_tty}" 2>/dev/null)
    
    if [ -w "$target_tty" ]; then
        # 构造 OSC 52 序列
        # \033]52;c;BASE64_CONTENT\a
        payload=$(echo -n "$input" | base64 -w0)
        printf "\033]52;c;%s\a" "$payload" > "$target_tty"
    fi
fi