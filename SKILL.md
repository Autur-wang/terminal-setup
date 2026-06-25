---
name: terminal-setup
description: >
  macOS 终端开发环境搭建指南：Ghostty + tmux + Zsh + dev-workspace + claude-workflow 一体化配置。
  包含所有配置文件、自动化安装步骤、快捷键速查和 AI 编程工作流。
  使用场景：(1) 在新 Mac 上搭建完整终端环境，
  (2) 迁移终端配置到新机器，(3) 查询 Ghostty/tmux/zsh 快捷键，
  (4) 排查终端配置问题，(5) 定制或修改现有终端配置，
  (6) 启动 Claude + Lazygit 分屏工作流，(7) 创建并行 worktree 运行多个 Claude 实例，
  (8) 管理多分支并行开发任务。
  触发关键词：终端配置、terminal setup、Ghostty 配置、tmux 配置、
  zsh 配置、dev-workspace、开发环境搭建、新机器配置、终端快捷键、
  工作流、workflow、lazygit、worktree、并行开发、分屏、parallel agents。
---

# 终端开发环境搭建指南

## 技术栈概览

- **终端**: Ghostty (Niji 主题, 全屏, 半透明)
- **复用器**: tmux (Ctrl+A prefix, Vi 导航)
- **Shell**: Zsh + autosuggestions + syntax-highlighting + fzf
- **启动器**: dev-workspace (tmux 五面板布局: lazygit + yazi + codex + 2x claude)
- **工作流**: claude-workflow (Claude + Lazygit 分屏 + Git Worktree 并行开发)
- **状态栏**: Claude Code statusline (目录 + git 分支 + context% + 模型)
- **字体**: MesloLGS Nerd Font 16pt

## 安装流程

### 1. 前置依赖

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 核心工具
brew install tmux fzf lazygit yazi go@1.20 nvm

# Zsh 插件
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-completions

# 字体（MesloLGS Nerd Font）
brew install --cask font-meslo-lg-nerd-font
```

### 2. 安装 Ghostty

从 https://ghostty.org 下载 macOS 版本并安装。

### 3. 部署配置文件

将 `assets/` 下的配置文件复制到对应位置：

| 源文件 | 目标路径 |
|--------|----------|
| `assets/ghostty/config` | `~/.config/ghostty/config` |
| `assets/tmux/.tmux.conf` | `~/.tmux.conf` |
| `assets/zsh/.zshrc` | `~/.zshrc` |
| `assets/dev-workspace/dev-workspace` | `~/.local/bin/dev-workspace` |
| `assets/dev-workspace/projects` | `~/.config/dev-workspace/projects` |
| `assets/dev-workspace/reset-layout.sh` | `~/.config/dev-workspace/reset-layout.sh` |
| `assets/dev-workspace/claude-workflow.sh` | `~/.local/bin/claude-workflow` |
| `assets/claude-code/statusline-command.sh` | `~/.claude/statusline-command.sh` |

```bash
mkdir -p ~/.config/ghostty ~/.config/dev-workspace ~/.local/bin
cp assets/ghostty/config ~/.config/ghostty/config
cp assets/tmux/.tmux.conf ~/.tmux.conf
cp assets/zsh/.zshrc ~/.zshrc
cp assets/dev-workspace/dev-workspace ~/.local/bin/dev-workspace
cp assets/dev-workspace/reset-layout.sh ~/.config/dev-workspace/reset-layout.sh
cp assets/dev-workspace/projects ~/.config/dev-workspace/projects
cp assets/dev-workspace/claude-workflow.sh ~/.local/bin/claude-workflow
cp assets/claude-code/statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.local/bin/dev-workspace ~/.local/bin/claude-workflow ~/.config/dev-workspace/reset-layout.sh ~/.claude/statusline-command.sh
```

### 4. 部署后配置

- 编辑 `~/.zshrc` 填入 API 密钥（已脱敏，需手动填写）
- 编辑 `~/.config/dev-workspace/projects` 注册项目路径
- Ghostty `command` 行中的路径需匹配实际用户目录

## 快捷键速查

完整快捷键参考见 [references/keybindings.md](references/keybindings.md)。

核心快捷键：

**Ghostty**: `Cmd+D` 分屏, `Cmd+H/J/K/L` 导航, `Cmd+Shift+G` lazygit, `Cmd+Shift+C` claude

**tmux** (Prefix `Ctrl+A`): `d/D` 分屏, `h/j/k/l` 导航, `g` lazygit, `C` claude

**Zsh**: `Ctrl+R` 历史搜索, `Ctrl+T` 文件搜索, `→` 接受建议

## 配置定制指南

### 修改 Ghostty 主题
编辑 `assets/ghostty/config` 中的 `theme` 和 `background-opacity`。

### 添加新项目到 dev-workspace
编辑 `~/.config/dev-workspace/projects`，格式: `别名=$HOME/路径`。

### 调整 tmux 状态栏颜色
编辑 `assets/tmux/.tmux.conf` 中 `status-style` 和相关颜色值（当前为 Niji 蓝紫配色 `#7aa2f7`, `#bb9af7`）。

## AI 编程工作流 (claude-workflow)

`claude-workflow` 脚本提供 Claude + Lazygit 分屏和 Git Worktree 并行开发能力。

### 快速使用

```bash
claude-workflow start              # 启动 Ghostty + Claude + Lazygit 分屏
claude-workflow parallel <name>    # 创建并行 worktree 并在新窗口启动 Claude
claude-workflow list               # 查看所有 worktree
claude-workflow clean <name>       # 清理已完成的 worktree
```

### 工作流架构

```
┌───────────┬─────────────────┐
│ lazygit   │ claude (上)     │
│           │ (主工作区)       │
├─────┬─────┼─────────────────┤
│yazi │codex│ claude (下)     │
│     │     │ (并行任务)       │
└─────┴─────┴─────────────────┘
```

### Git Worktree 并行开发

详细 Worktree 使用指南见 [references/worktree.md](references/worktree.md)。

## dev-workspace 布局与 AI 工具配置

### 五面板布局（pane 编号经实测验证）

```
┌───────────┬─────────────────┐
│ 1 lazygit │ 4 AI_RT (右上)  │
├─────┬─────┼─────────────────┤
│2yazi│3    │ 5 AI_RB (右下)  │
│     │AI_LB│                 │
└─────┴─────┴─────────────────┘
```

### tmux split 命令与 pane 编号映射

tmux split 后 pane 编号按深度优先遍历重排序，实际编号如下：

| 步骤 | 命令 | 产生的 pane |
|------|------|------------|
| 1 | `new-session` | pane 1 (全屏) |
| 2 | `split-window -h -t 1.1 -p 55` | pane 1=左, pane 2=右(55%) |
| 3 | `split-window -v -t 1.2 -p 50` | pane 2=右上, pane 3=右下(新) |
| 4 | `split-window -v -t 1.1 -p 35` | pane 1=左上, pane 2=**左下**(重排!) |
| 5 | `split-window -h -t 1.2 -p 60` | pane 2=左下左(yazi), pane 3=左下右(AI_LB) |

**关键陷阱**：step 4 之后 pane 编号会重排，左下变为 pane 2（不是 pane 4）。必须用 `1.2` 而非 `1.4` 来 split 左下面板。

### 布局比例定义

| 区域 | 比例 | 说明 |
|------|------|------|
| Left:Right | 45:55 | 左列:右列 宽度 |
| Lazygit:Bottom | 65:35 | 左上:左下 高度 |
| AI_RT:AI_RB | 50:50 | 右上:右下 高度 |
| Yazi:AI_LB | 38:62 | 左下左:左下右 宽度 |

### 布局持久化与重置

布局比例由 `~/.config/dev-workspace/reset-layout.sh` 统一管理（单一真实源）。

**三层保障机制：**

| 层级 | 机制 | 说明 |
|------|------|------|
| 创建时 | `dev-workspace` 脚本 | 新建 session 后自动调用 reset-layout 固定比例 |
| 运行时 | `prefix + =` 快捷键 | 布局漂移时一键恢复 |
| 比例定义 | `reset-layout.sh` | 按当前窗口尺寸动态计算绝对值 |

### AI 工具布局选项（8 种组合）

启动时可选择 3 个 AI 槽位（左下/右上/右下）的 claude/codex 组合：

| 编号 | 左下(AI_LB) | 右上(AI_RT) | 右下(AI_RB) | 说明 |
|------|-------------|-------------|-------------|------|
| 1 | codex | claude | claude | 默认 |
| 2 | claude | claude | claude | 全 claude |
| 3 | claude | codex | codex | 全 codex 右侧 |
| 4 | codex | codex | codex | 全 codex |
| 5 | claude | claude | codex | |
| 6 | claude | codex | claude | |
| 7 | codex | claude | codex | |
| 8 | codex | codex | claude | |

### 配置文件位置

| 文件 | 用途 |
|------|------|
| `~/.local/bin/dev-workspace` | 运行时启动脚本 |
| `~/.config/dev-workspace/reset-layout.sh` | 布局重置脚本（单一真实源） |
| `~/.config/dev-workspace/projects` | 项目注册表 |
| `assets/dev-workspace/` | skill 资源备份 |
| `~/.config/ghostty/config` | Ghostty 终端配置 |
| `~/.claude/statusline-command.sh` | Claude Code 状态栏脚本 |
| `assets/claude-code/statusline-command.sh` | statusline skill 资源备份 |

### 修改后生效规则

**重要**：修改 `dev-workspace` 脚本或 tmux 布局配置后，脚本为 bash 文件无需编译，但只对新 session 生效。必须主动询问用户是否重启当前 tmux session：

```bash
tmux kill-session -t <session> && dev-workspace <project>
```

提醒用户重启会关闭当前所有面板，让用户自行决定时机。

## Claude Code Status Line 配置

Claude Code 支持自定义底部状态栏，显示实时会话信息。

### 配置效果

```
~/axon-web [fix/agent-form-add-option-ui-polish] 12% ctx | Claude Opus 4.6
```

| 字段 | 颜色 | 说明 |
|------|------|------|
| 当前目录 | 青色 | `~` 代替 home 路径 |
| git 分支 | 黄色 | `[branch-name]`，非 git 目录时隐藏 |
| context 使用率 | 绿/红 | 低于 80% 绿色，≥80% 变红警告 |
| 模型名 | 蓝色 | 当前使用的模型 |

### 部署

```bash
cp assets/claude-code/statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

在 `~/.claude/settings.json` 中添加（如已有其他配置则合并）：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-command.sh",
    "padding": 2
  }
}
```

### 可用数据字段

脚本通过 stdin 接收 JSON，主要字段：

| 字段 | 说明 |
|------|------|
| `model.display_name` | 当前模型名 |
| `context_window.used_percentage` | 上下文使用百分比 |
| `cost.total_cost_usd` | 会话总成本（USD） |
| `cost.total_duration_ms` | 会话耗时（毫秒） |
| `workspace.current_dir` | 当前工作目录 |

### 定制

- 修改 `assets/claude-code/statusline-command.sh` 调整显示内容
- 也可用 `/statusline` 命令通过自然语言重新生成
- 删除状态栏：`/statusline delete` 或移除 settings.json 中的 `statusLine` 字段

### 配置文件位置

| 文件 | 用途 |
|------|------|
| `~/.claude/statusline-command.sh` | 运行时脚本 |
| `~/.claude/settings.json` | statusLine 配置入口 |
| `assets/claude-code/statusline-command.sh` | skill 资源备份 |

## 故障排查

- **Ghostty RGB 不正常**: 检查 tmux 中 `terminal-overrides` 包含 `xterm-ghostty:RGB`
- **dev-workspace 无法启动**: 确认 `chmod +x ~/.local/bin/dev-workspace` 且 PATH 包含 `~/.local/bin`
- **claude-workflow 命令未找到**: 确认 `~/.local/bin/claude-workflow` 存在且有执行权限
- **Zsh 插件未加载**: 运行 `brew list` 确认 zsh-autosuggestions、zsh-syntax-highlighting 已安装
- **fzf 快捷键失效**: 确认 `source <(fzf --zsh)` 在 `.zshrc` 中且 fzf 版本 >= 0.48
