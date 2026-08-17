#!/usr/bin/env bash
# openos-uname — OPENOS 增强版 uname (neofetch 风格)
#
# 输出 OPENOS ASCII art logo + 系统信息 (内核/架构/主机/内核版本等)。
#
# 用法:
#   openos-uname            # 完整: ASCII logo + 系统信息
#   openos-uname -a         # 兼容 uname -a (纯信息, 无 logo)
#   openos-uname -r / -m ... # 兼容标准 uname 选项
#
# 可选: 安装为 uname (PATH 前置) 后, 直接输入 uname 即显示 logo。

set -uo pipefail

# ---------- ASCII logo (OPENOS) ----------
readonly LOGO=$'\n\
 ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ███████╗\n\
██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔═══██╗██╔════╝\n\
██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║   ██║███████╗\n\
██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║   ██║╚════██║\n\
╚██████╔╝██║     ███████╗██║ ╚████║╚██████╔╝███████║\n\
 ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝'

# ---------- 信息收集 (全部来自 uname) ----------
SYSNAME="$(uname -s 2>/dev/null || echo Linux)"
NODENAME="$(uname -n 2>/dev/null || echo openos)"
RELEASE="$(uname -r 2>/dev/null || echo unknown)"
VERSION="$(uname -v 2>/dev/null || echo '')"
MACHINE="$(uname -m 2>/dev/null || echo unknown)"

# OPENOS 版本 (优先 /etc/openos-release)
OS_VERSION="DEV2026.1"
if [ -f /etc/openos-release ]; then
    v="$(sed -n 's/^OPENOS_VERSION=//p' /etc/openos-release 2>/dev/null)"
    [ -n "$v" ] && OS_VERSION="$v"
fi

# ---------- 标准 uname 选项兼容 ----------
std_uname() {
    local s=""
    [ -n "$SYSNAME" ]  && s+=" $SYSNAME"
    [ -n "$NODENAME" ] && s+=" $NODENAME"
    [ -n "$RELEASE" ]  && s+=" $RELEASE"
    [ -n "$VERSION" ]  && s+=" $VERSION"
    [ -n "$MACHINE" ]  && s+=" $MACHINE"
    echo "${s# }"
}

# ---------- 主逻辑 ----------
if [ "$#" -gt 0 ]; then
    # 有选项: 兼容标准 uname (逐字符解析)
    case "$1" in
        -a|--all) std_uname ;;
        -s|--kernel-name) echo "$SYSNAME" ;;
        -n|--nodename)    echo "$NODENAME" ;;
        -r|--kernel-release) echo "$RELEASE" ;;
        -v|--kernel-version) echo "$VERSION" ;;
        -m|--machine)     echo "$MACHINE" ;;
        -p|--processor)   echo "$MACHINE" ;;
        -i|--hardware-platform) echo "$MACHINE" ;;
        -o|--operating-system)  echo "OPENOS" ;;
        -h|--help)
            echo "用法: openos-uname [选项]"
            echo "无选项: 显示 OPENOS logo + 系统信息"
            echo "选项: -a -s -n -r -v -m -p -i -o (同标准 uname)"
            ;;
        *) echo "openos-uname: 未知选项 $1" >&2; exit 1 ;;
    esac
    exit 0
fi

# 无参数: 完整 logo + 信息 (neofetch 风格)
printf '%s\n' "$LOGO"
printf '%s\n' ""
printf '  %-14s %s\n' "OPENOS" "$OS_VERSION"
printf '  %-14s %s\n' "内核" "$SYSNAME $RELEASE"
printf '  %-14s %s\n' "架构" "$MACHINE"
printf '  %-14s %s\n' "主机" "$NODENAME"
[ -n "$VERSION" ] && printf '  %-14s %s\n' "版本" "$VERSION"
printf '%s\n' ""
