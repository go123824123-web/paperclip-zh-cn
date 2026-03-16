# Changelog

所有重要变更记录在此文件中。

## [1.0.2] - 2026-03-17

### 修复
- 更新补丁文件以兼容最新版 Paperclip main 分支
- 修复 `ProjectProperties.tsx`、`CompanySettings.tsx`、`Projects.tsx` 三个文件的补丁冲突
- 移除补丁中不必要的 `pnpm-lock.yaml` diff，减少补丁体积

### 变更
- 更新 README 中的 GitHub 仓库地址为正式地址

## [1.0.1] - 2026-03-17

### 新增
- 一键安装脚本 `setup.sh`：自动检测环境、下载 Paperclip、安装依赖、应用中文包
- 安装过程添加进度条和可视化反馈
- README 增加详细的安装步骤说明

## [1.0.0] - 2026-03-16

### 新增
- 首次发布 Paperclip 中文语言包
- 500+ 翻译键，覆盖整个界面
- 中英文一键切换，语言选择自动保存
- 覆盖范围：
  - 仪表盘、任务、目标、项目、智能体、成本、动态
  - 所有对话框（新建任务/项目/目标/智能体）
  - 收件箱、审批、组织架构
  - 公司设置、实例设置
  - 登录/注册页面
  - 适配器配置（Claude/Codex/Gemini 等）
- `install.sh` 安装脚本（适用于已有 Paperclip 的用户）
- `uninstall.sh` 卸载脚本
- 组件补丁文件（50+ 文件）
