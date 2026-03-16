#!/bin/bash
set -e

# Paperclip 中文语言包卸载脚本

if [ -n "$1" ]; then
    PAPERCLIP_DIR="$1"
elif [ -d "./ui/src" ] && [ -f "./package.json" ]; then
    PAPERCLIP_DIR="."
else
    echo "用法: ./uninstall.sh [paperclip目录路径]"
    exit 1
fi

PAPERCLIP_DIR="$(cd "$PAPERCLIP_DIR" && pwd)"

echo "正在卸载中文语言包 / Uninstalling Chinese language pack..."
cd "$PAPERCLIP_DIR"

# 恢复所有修改的文件
git checkout -- ui/src/ 2>/dev/null || true

# 删除新增的文件
rm -f ui/src/i18n/en.ts ui/src/i18n/zh.ts
rmdir ui/src/i18n 2>/dev/null || true
rm -f ui/src/context/LanguageContext.tsx
rm -f ui/src/pages/LanguageSettings.tsx

echo "✅ 卸载完成 / Uninstall complete"
echo "请重启 Paperclip: pnpm dev"
