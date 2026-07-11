#!/usr/bin/env bash

# 检测 mako  是否已在运行
if ! pgrep -x "mako " > /dev/null; then
    mako &
fi