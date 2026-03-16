# Paperclip 中文语言包

为 [Paperclip](https://github.com/paperclipai/paperclip) AI 智能体编排平台提供完整的中文界面翻译。

## 一键安装（推荐）

复制这一行命令，粘贴到终端，回车，搞定：

```bash
git clone https://github.com/your-username/paperclip-zh-cn.git && cd paperclip-zh-cn && ./setup.sh
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

## 其他安装方式

### 已有 Paperclip 的情况

如果你已经装了 Paperclip，只需要加中文：

```bash
git clone https://github.com/your-username/paperclip-zh-cn.git
cd paperclip-zh-cn
./install.sh /你的/paperclip/路径
```

### 手动安装

```bash
# 复制翻译文件
cp -r src/i18n/ /path/to/paperclip/ui/src/i18n/
cp src/context/LanguageContext.tsx /path/to/paperclip/ui/src/context/
cp src/pages/LanguageSettings.tsx /path/to/paperclip/ui/src/pages/

# 应用补丁
cd /path/to/paperclip
git apply /path/to/paperclip-zh-cn/paperclip-zh-cn.patch
```

## 卸载

```bash
cd ~/paperclip && git checkout -- ui/src/
```

## 项目结构

```
paperclip-zh-cn/
├── setup.sh                     # 一键安装脚本（推荐）
├── install.sh                   # 安装到已有 Paperclip
├── uninstall.sh                 # 卸载脚本
├── paperclip-zh-cn.patch        # 组件补丁文件
└── src/
    ├── i18n/
    │   ├── en.ts                # 英文翻译键
    │   └── zh.ts                # 中文翻译
    ├── context/
    │   └── LanguageContext.tsx   # 语言切换上下文
    └── pages/
        └── LanguageSettings.tsx  # 语言设置页面
```

## 兼容性

基于 2026 年 3 月 Paperclip main 分支开发。如果上游更新导致补丁无法应用，核心翻译文件仍可手动安装。

## License

MIT
