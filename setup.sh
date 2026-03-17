#!/bin/bash
set -e

# =========================================
#  Paperclip 中文版一键安装脚本
#  One-click installer for Paperclip + Chinese language pack
# =========================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${1:-$HOME/paperclip}"

# ---- 颜色和样式 ----
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

# 进度条函数
progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local width=30
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    printf "\r  ${CYAN}[${bar}]${RESET} ${BOLD}%3d%%${RESET}  %s" "$percent" "$label"
}

# 步骤标题
step() {
    local current=$1
    local total=$2
    local label=$3
    echo ""
    echo -e "  ${BOLD}${CYAN}[$current/$total]${RESET} ${BOLD}$label${RESET}"
    echo -e "  ${DIM}$(printf '%.0s─' {1..40})${RESET}"
}

# 状态标记
ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $1"; }
fail() { echo -e "  ${RED}✘${RESET} $1"; }

# ---- 头部 ----
clear 2>/dev/null || true
echo ""
echo -e "  ${BOLD}╔═══════════════════════════════════════╗${RESET}"
echo -e "  ${BOLD}║   Paperclip 中文版 · 一键安装程序     ║${RESET}"
echo -e "  ${BOLD}╚═══════════════════════════════════════╝${RESET}"
echo ""
echo -e "  安装目录: ${CYAN}$INSTALL_DIR${RESET}"
echo ""

# ---- 第 0 步: 检查环境 ----
step 0 4 "检查系统环境"

if ! command -v node &>/dev/null; then
    fail "未检测到 Node.js，请先安装 Node.js 20+"
    echo "     下载: https://nodejs.org/"
    exit 1
fi
NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 20 ]; then
    fail "Node.js 版本太低 ($(node -v))，需要 20+"
    exit 1
fi
ok "Node.js $(node -v)"

if ! command -v pnpm &>/dev/null; then
    warn "未检测到 pnpm，正在自动安装..."
    npm install -g pnpm >/dev/null 2>&1
fi
ok "pnpm $(pnpm -v)"

if ! command -v git &>/dev/null; then
    fail "未检测到 git，请先安装 git"
    exit 1
fi
ok "git $(git --version | awk '{print $3}')"

# ---- 第 1 步: 下载 Paperclip ----
step 1 4 "下载 Paperclip"

if [ -d "$INSTALL_DIR" ] && [ -d "$INSTALL_DIR/ui/src" ]; then
    ok "Paperclip 已存在，跳过下载"
else
    echo ""
    git clone --progress https://github.com/paperclipai/paperclip.git "$INSTALL_DIR" 2>&1 | while IFS= read -r line; do
        if [[ "$line" =~ ([0-9]+)% ]]; then
            pct="${BASH_REMATCH[1]}"
            progress_bar "$pct" 100 "克隆仓库..."
        fi
    done
    echo ""
    ok "下载完成"
fi

# ---- 第 2 步: 安装依赖 ----
step 2 4 "安装项目依赖"

cd "$INSTALL_DIR"
echo ""
pnpm install 2>&1 | while IFS= read -r line; do
    if [[ "$line" =~ Progress:.*resolved[[:space:]]([0-9]+) ]]; then
        resolved="${BASH_REMATCH[1]}"
        # 预估总共约 1100 个包
        if [ "$resolved" -gt 1100 ]; then resolved=1100; fi
        progress_bar "$resolved" 1100 "已解析 $resolved 个依赖包..."
    elif [[ "$line" =~ "Done in" ]]; then
        progress_bar 1100 1100 "依赖安装完成"
    fi
done
echo ""
ok "依赖安装完成"

# ---- 第 3 步: 安装汉化包 ----
step 3 4 "安装汉化包"

PATCH_FILE="$SCRIPT_DIR/src/paperclip-zh-cn.patch"
TOTAL_STEPS=5
CURRENT=0

CURRENT=$((CURRENT + 1))
progress_bar $CURRENT $TOTAL_STEPS "复制翻译文件..."
mkdir -p "$INSTALL_DIR/ui/src/i18n"
cp "$SCRIPT_DIR/src/i18n/en.ts" "$INSTALL_DIR/ui/src/i18n/en.ts"
cp "$SCRIPT_DIR/src/i18n/zh.ts" "$INSTALL_DIR/ui/src/i18n/zh.ts"

CURRENT=$((CURRENT + 1))
progress_bar $CURRENT $TOTAL_STEPS "安装语言上下文..."
cp "$SCRIPT_DIR/src/context/LanguageContext.tsx" "$INSTALL_DIR/ui/src/context/LanguageContext.tsx"

CURRENT=$((CURRENT + 1))
progress_bar $CURRENT $TOTAL_STEPS "安装设置页面..."
cp "$SCRIPT_DIR/src/pages/LanguageSettings.tsx" "$INSTALL_DIR/ui/src/pages/LanguageSettings.tsx"

CURRENT=$((CURRENT + 1))
progress_bar $CURRENT $TOTAL_STEPS "应用组件补丁 (50+ 文件)..."
cd "$INSTALL_DIR"
PATCH_OK=false
if git apply --check "$PATCH_FILE" 2>/dev/null; then
    git apply "$PATCH_FILE"
    PATCH_OK=true
elif git apply --3way "$PATCH_FILE" 2>/dev/null; then
    PATCH_OK=true
fi

CURRENT=$((CURRENT + 1))
progress_bar $CURRENT $TOTAL_STEPS "完成"
echo ""

if [ "$PATCH_OK" = true ]; then
    ok "汉化包安装成功 (50+ 组件已翻译)"
else
    warn "补丁部分应用失败，核心翻译文件已安装"
fi

# ---- 第 4 步: 完成 ----
step 4 4 "安装完成"

echo ""
echo -e "  ${BOLD}${GREEN}╔═══════════════════════════════════════╗${RESET}"
echo -e "  ${BOLD}${GREEN}║        ✅ 安装成功!                   ║${RESET}"
echo -e "  ${BOLD}${GREEN}╚═══════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${BOLD}启动命令:${RESET}"
echo -e "    ${CYAN}cd $INSTALL_DIR && pnpm dev${RESET}"
echo ""
echo -e "  ${BOLD}浏览器访问:${RESET}"
echo -e "    ${CYAN}http://localhost:3100${RESET}"
echo ""
echo -e "  ${BOLD}切换中文:${RESET}"
echo -e "    左下角 ⚙️ → Language → 中文"
echo ""
echo -e "  ${BOLD}停止服务:${RESET}"
echo -e "    Ctrl+C"
echo ""
echo -e "  ${DIM}卸载: cd $INSTALL_DIR && git checkout -- ui/src/${RESET}"
echo ""

echo -ne "  ${BOLD}是否现在启动 Paperclip? ${RESET}${DIM}[Y/n]${RESET} "
read -r answer
if [ "$answer" != "n" ] && [ "$answer" != "N" ]; then
    echo ""
    echo -e "  ${CYAN}正在启动...${RESET}"
    echo ""
    cd "$INSTALL_DIR"
    pnpm dev
fi
