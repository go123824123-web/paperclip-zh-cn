# Paperclip 汉化包

为 [Paperclip](https://github.com/paperclipai/paperclip) AI 智能体编排平台提供完整的中文界面翻译。

## 一键安装（推荐）

复制这一行命令，粘贴到终端，回车，搞定：

```bash
git clone https://github.com/go123824123-web/paperclip-zh-cn.git && cd paperclip-zh-cn && ./setup.sh
```

这条命令会自动完成以下所有步骤：
1. **检查环境** — 自动检测 Node.js 版本够不够、有没有 pnpm（没有就自动装）
2. **下载 Paperclip** — 自动 clone 到 `~/paperclip`
3. **安装依赖** — 自动 `pnpm install`
4. **安装中文包** — 复制翻译文件 + 自动打补丁（50+ 组件）
5. **启动服务** — 询问是否立即启动

如果你想装到指定目录：
```bash
./setup.sh ~/Desktop/my-paperclip
```

### 前提条件

- Node.js 20+（[下载地址](https://nodejs.org/)）
- git

pnpm 如果没装，脚本会自动帮你装。

## 安装后使用

1. 启动：`cd ~/paperclip && pnpm dev`
2. 浏览器打开 http://localhost:3100
3. 切换中文：左下角 ⚙️ → **Language** → **中文**

语言选择会自动保存，下次打开还是中文。

## 功能

- 500+ 翻译键，覆盖整个界面
- 中英文一键切换
- 覆盖范围：
  - 仪表盘、任务、目标、项目、智能体、成本、动态
  - 所有对话框（新建任务/项目/目标/智能体）
  - 收件箱、审批、组织架构
  - 公司设置、实例设置
  - 登录/注册页面
  - 适配器配置（Claude/Codex/Gemini 等）

## 已有 Paperclip？手动安装中文包

如果你已经装了 Paperclip，只需要三步：

```bash
# 1. 克隆语言包
git clone https://github.com/go123824123-web/paperclip-zh-cn.git

# 2. 复制翻译文件到 Paperclip 目录
cp -r paperclip-zh-cn/src/i18n/ /你的/paperclip/路径/ui/src/i18n/
cp paperclip-zh-cn/src/context/LanguageContext.tsx /你的/paperclip/路径/ui/src/context/
cp paperclip-zh-cn/src/pages/LanguageSettings.tsx /你的/paperclip/路径/ui/src/pages/

# 3. 应用组件补丁
cd /你的/paperclip/路径
git apply /path/to/paperclip-zh-cn/src/paperclip-zh-cn.patch
```

## 卸载

在 Paperclip 目录下执行：

```bash
# 还原所有被补丁修改的文件
cd ~/paperclip && git checkout -- ui/src/

# 删除新增的翻译文件
rm -f ui/src/i18n/en.ts ui/src/i18n/zh.ts
rm -f ui/src/context/LanguageContext.tsx
rm -f ui/src/pages/LanguageSettings.tsx
```

## 项目结构

```
paperclip-zh-cn/
├── README.md                       # 说明文档
├── setup.sh                        # 一键安装脚本
└── src/
    ├── paperclip-zh-cn.patch        # 组件补丁文件
    ├── CHANGELOG.md                 # 更新日志
    ├── package.json                 # 项目元信息
    ├── i18n/
    │   ├── en.ts                    # 英文翻译键
    │   └── zh.ts                    # 中文翻译
    ├── context/
    │   └── LanguageContext.tsx       # 语言切换上下文
    └── pages/
        └── LanguageSettings.tsx      # 语言设置页面
```

## 兼容性

基于 2026 年 3 月 Paperclip main 分支开发。如果上游更新导致补丁无法应用，核心翻译文件仍可手动安装。

## License

MIT
