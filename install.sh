#!/bin/bash
set -e

# Paperclip 中文语言包安装脚本
# Paperclip Chinese Language Pack Installer

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PATCH_FILE="$SCRIPT_DIR/paperclip-zh-cn.patch"

# 检测 Paperclip 安装目录
if [ -n "$1" ]; then
    PAPERCLIP_DIR="$1"
elif [ -d "./ui/src" ] && [ -f "./package.json" ]; then
    PAPERCLIP_DIR="."
else
    echo "用法: ./install.sh [paperclip目录路径]"
    echo "Usage: ./install.sh [path-to-paperclip]"
    echo ""
    echo "示例 / Example:"
    echo "  ./install.sh /path/to/paperclip"
    echo "  cd /path/to/paperclip && /path/to/install.sh"
    exit 1
fi

PAPERCLIP_DIR="$(cd "$PAPERCLIP_DIR" && pwd)"

# 验证目录
if [ ! -d "$PAPERCLIP_DIR/ui/src" ]; then
    echo "错误: $PAPERCLIP_DIR 不是有效的 Paperclip 目录"
    echo "Error: $PAPERCLIP_DIR is not a valid Paperclip directory"
    exit 1
fi

echo "========================================="
echo " Paperclip 中文语言包安装器"
echo " Paperclip Chinese Language Pack"
echo "========================================="
echo ""
echo "Paperclip 目录: $PAPERCLIP_DIR"
echo ""

# 复制 i18n 核心文件
echo "[1/4] 安装翻译文件 / Installing translation files..."
mkdir -p "$PAPERCLIP_DIR/ui/src/i18n"
cp "$SCRIPT_DIR/src/i18n/en.ts" "$PAPERCLIP_DIR/ui/src/i18n/en.ts"
cp "$SCRIPT_DIR/src/i18n/zh.ts" "$PAPERCLIP_DIR/ui/src/i18n/zh.ts"

echo "[2/4] 安装语言上下文 / Installing language context..."
cp "$SCRIPT_DIR/src/context/LanguageContext.tsx" "$PAPERCLIP_DIR/ui/src/context/LanguageContext.tsx"

echo "[3/4] 安装语言设置页面 / Installing language settings page..."
cp "$SCRIPT_DIR/src/pages/LanguageSettings.tsx" "$PAPERCLIP_DIR/ui/src/pages/LanguageSettings.tsx"

echo "[4/4] 应用组件补丁 / Applying component patches..."
cd "$PAPERCLIP_DIR"

if git apply --check "$PATCH_FILE" 2>/dev/null; then
    git apply "$PATCH_FILE"
    echo ""
    echo "✅ 安装成功! Installation successful!"
else
    echo ""
    echo "⚠️  补丁无法直接应用，尝试使用 --3way 模式..."
    echo "⚠️  Patch cannot be applied directly, trying --3way mode..."
    if git apply --3way "$PATCH_FILE" 2>/dev/null; then
        echo "✅ 安装成功 (3way merge)! Installation successful!"
    else
        echo ""
        echo "❌ 自动补丁失败。可能是 Paperclip 版本不兼容。"
        echo "❌ Auto-patch failed. Paperclip version may be incompatible."
        echo ""
        echo "核心翻译文件已安装到:"
        echo "  - ui/src/i18n/en.ts"
        echo "  - ui/src/i18n/zh.ts"
        echo "  - ui/src/context/LanguageContext.tsx"
        echo "  - ui/src/pages/LanguageSettings.tsx"
        echo ""
        echo "请手动将 useLanguage hook 集成到各组件中。"
        echo "Please manually integrate the useLanguage hook into components."
        exit 1
    fi
fi

echo ""
echo "========================================="
echo " 安装完成 / Installation Complete"
echo "========================================="
echo ""
echo "使用方法 / How to use:"
echo "  1. 重启 Paperclip: pnpm dev"
echo "  2. 打开浏览器访问 Paperclip"
echo "  3. 点击左下角 ⚙️ 进入 Instance Settings"
echo "  4. 点击 Language / 语言"
echo "  5. 选择 中文"
echo ""
echo "卸载方法 / How to uninstall:"
echo "  cd $PAPERCLIP_DIR && git checkout ."
echo ""
