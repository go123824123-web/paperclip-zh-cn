#!/bin/bash
set -e

# =========================================
#  Paperclip 中文版一键安装脚本
#  One-click installer for Paperclip + Chinese language pack
# =========================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${1:-$HOME/paperclip}"

echo ""
echo "========================================="
echo "  Paperclip 中文版一键安装"
echo "  Paperclip + Chinese Language Pack"
echo "========================================="
echo ""
echo "安装目录: $INSTALL_DIR"
echo ""

# ---- 检查依赖 ----
echo "[检查环境]"

if ! command -v node &>/dev/null; then
    echo "❌ 未检测到 Node.js，请先安装 Node.js 20+"
    echo "   https://nodejs.org/"
    exit 1
fi

NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 20 ]; then
    echo "❌ Node.js 版本太低 ($(node -v))，需要 20+"
    exit 1
fi
echo "  ✅ Node.js $(node -v)"

if ! command -v pnpm &>/dev/null; then
    echo "  ⚠️  未检测到 pnpm，正在自动安装..."
    npm install -g pnpm
fi
echo "  ✅ pnpm $(pnpm -v)"

if ! command -v git &>/dev/null; then
    echo "❌ 未检测到 git，请先安装 git"
    exit 1
fi
echo "  ✅ git $(git --version | awk '{print $3}')"
echo ""

# ---- 下载 Paperclip ----
if [ -d "$INSTALL_DIR" ] && [ -d "$INSTALL_DIR/ui/src" ]; then
    echo "[跳过下载] Paperclip 已存在于 $INSTALL_DIR"
else
    echo "[1/4] 下载 Paperclip..."
    git clone https://github.com/paperclipai/paperclip.git "$INSTALL_DIR"
fi
echo ""

# ---- 安装依赖 ----
echo "[2/4] 安装依赖 (pnpm install)..."
cd "$INSTALL_DIR"
pnpm install
echo ""

# ---- 安装中文语言包 ----
echo "[3/4] 安装中文语言包..."

PATCH_FILE="$SCRIPT_DIR/paperclip-zh-cn.patch"

# 复制核心文件
mkdir -p "$INSTALL_DIR/ui/src/i18n"
cp "$SCRIPT_DIR/src/i18n/en.ts" "$INSTALL_DIR/ui/src/i18n/en.ts"
cp "$SCRIPT_DIR/src/i18n/zh.ts" "$INSTALL_DIR/ui/src/i18n/zh.ts"
cp "$SCRIPT_DIR/src/context/LanguageContext.tsx" "$INSTALL_DIR/ui/src/context/LanguageContext.tsx"
cp "$SCRIPT_DIR/src/pages/LanguageSettings.tsx" "$INSTALL_DIR/ui/src/pages/LanguageSettings.tsx"

# 应用补丁
cd "$INSTALL_DIR"
if git apply --check "$PATCH_FILE" 2>/dev/null; then
    git apply "$PATCH_FILE"
    echo "  ✅ 补丁应用成功"
elif git apply --3way "$PATCH_FILE" 2>/dev/null; then
    echo "  ✅ 补丁应用成功 (3way merge)"
else
    echo "  ⚠️  补丁应用失败，核心翻译文件已安装，部分组件可能仍显示英文"
fi
echo ""

# ---- 启动 ----
echo "[4/4] 启动 Paperclip..."
echo ""
echo "========================================="
echo "  ✅ 安装完成!"
echo "========================================="
echo ""
echo "Paperclip 已安装到: $INSTALL_DIR"
echo ""
echo "📌 启动命令:"
echo "   cd $INSTALL_DIR && pnpm dev"
echo ""
echo "📌 打开浏览器访问:"
echo "   http://localhost:3100"
echo ""
echo "📌 切换中文:"
echo "   左下角 ⚙️ → Language → 中文"
echo ""
echo "📌 停止服务:"
echo "   Ctrl+C"
echo ""
echo "是否现在启动? [Y/n] "
read -r answer
if [ "$answer" != "n" ] && [ "$answer" != "N" ]; then
    cd "$INSTALL_DIR"
    pnpm dev
fi
