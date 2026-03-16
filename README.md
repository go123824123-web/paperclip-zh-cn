# Paperclip 中文语言包

为 [Paperclip](https://github.com/paperclipai/paperclip) AI 智能体编排平台提供完整的中文界面翻译。

## 功能

- 完整的中文界面翻译（500+ 翻译键）
- 中英文一键切换
- 覆盖所有页面和组件：
  - 仪表盘、任务、目标、项目、智能体、成本、动态
  - 所有对话框（新建任务/项目/目标/智能体）
  - 收件箱、审批、组织架构
  - 公司设置、实例设置
  - 登录/注册页面
  - 适配器配置（Claude/Codex/Gemini 等）

## 安装

### 方式一：使用安装脚本（推荐）

```bash
git clone https://github.com/your-username/paperclip-zh-cn.git
cd paperclip-zh-cn
./install.sh /path/to/paperclip
```

### 方式二：手动安装

```bash
# 1. 复制翻译文件
cp -r src/i18n/ /path/to/paperclip/ui/src/i18n/
cp src/context/LanguageContext.tsx /path/to/paperclip/ui/src/context/
cp src/pages/LanguageSettings.tsx /path/to/paperclip/ui/src/pages/

# 2. 应用组件补丁
cd /path/to/paperclip
git apply /path/to/paperclip-zh-cn/paperclip-zh-cn.patch
```

## 使用方法

1. 重启 Paperclip 开发服务器：
   ```bash
   cd /path/to/paperclip
   pnpm dev
   ```

2. 打开浏览器访问 Paperclip（默认 http://localhost:3100）

3. 切换语言：
   - 点击左下角 ⚙️ 齿轮图标
   - 在侧栏点击 **Language**
   - 选择 **中文**

4. 界面立即切换为中文，选择会自动保存

## 卸载

```bash
./uninstall.sh /path/to/paperclip
# 或者
cd /path/to/paperclip && git checkout -- ui/src/
```

## 兼容性

- Paperclip 版本：基于 2026 年 3 月的 main 分支开发
- 如果 Paperclip 更新后补丁无法应用，核心翻译文件仍可手动安装

## 项目结构

```
paperclip-zh-cn/
├── README.md                    # 本文档
├── package.json                 # 项目信息
├── install.sh                   # 安装脚本
├── uninstall.sh                 # 卸载脚本
├── paperclip-zh-cn.patch        # 组件补丁文件
└── src/
    ├── i18n/
    │   ├── en.ts                # 英文翻译（完整键值）
    │   └── zh.ts                # 中文翻译
    ├── context/
    │   └── LanguageContext.tsx   # 语言切换上下文
    └── pages/
        └── LanguageSettings.tsx  # 语言设置页面
```

## 贡献

欢迎提交 PR 来改进翻译质量或添加缺失的翻译。

## License

MIT
