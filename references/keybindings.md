# 快捷键速查表

## Ghostty 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Cmd+D` | 右分屏 |
| `Cmd+Shift+D` | 下分屏 |
| `Cmd+H/J/K/L` | 导航分屏（左/下/上/右） |
| `Cmd+Ctrl+H/J/K/L` | 调整分屏大小 |
| `Cmd+W` | 关闭当前面板 |
| `Cmd+T` | 新标签 |
| `Cmd+N` | 新窗口 |
| `Cmd+1-4` | 切换标签 |
| `Cmd+Shift+G` | 启动 lazygit |
| `Cmd+Shift+C` | 启动 claude |
| `Cmd+Shift+S` | 新建 tmux session |
| `Cmd+Shift+A` | 列出并 attach session |
| `Cmd+Shift+R` | 快速 attach 上一个 session |
| `Cmd+Shift+W` | 启动 dev-workspace |

## tmux 快捷键（Prefix: Ctrl+A）

### Session 管理
| 快捷键 | 功能 |
|--------|------|
| `Shift+S` | 新建 session |
| `Shift+K` | 删除 session |
| `s` | 选择 session |
| `f` | 查找 session |
| `R` | 重命名 session |

### 窗口 & 分屏
| 快捷键 | 功能 |
|--------|------|
| `c` | 新窗口 |
| `r` | 重命名窗口 |
| `d` | 右分屏 |
| `D` | 下分屏 |
| `x` | 关闭 pane |
| `h/j/k/l` | Vi 导航 pane |
| `H/J/K/L` | 调整 pane 大小 |

### 快捷操作
| 快捷键 | 功能 |
|--------|------|
| `g` | 新窗口运行 lazygit |
| `C` | 新窗口运行 claude |
| `v` | 进入复制模式 |
| `=` | 重置 dev-workspace 布局比例 |

## Zsh 快捷键
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+R` | fzf 搜索历史 |
| `Ctrl+T` | fzf 搜索文件 |
| `Alt+C` | fzf 跳转目录 |
| `→` | 接受自动建议 |
| `Ctrl+→` | 接受建议一个单词 |

## dev-workspace 布局

```
┌───────────┬─────────────────┐
│ 1 lazygit │ 4 AI_RT (右上)  │  Left:Right = 45:55
│  (65%)    │  (50%)          │  Lazygit:Bottom = 65:35
├───┬───────┼─────────────────┤
│2  │3      │ 5 AI_RB (右下)  │  AI_RT:AI_RB = 50:50
│yaz│ AI_LB │  (50%)          │  Yazi:AI_LB = 38:62
└───┴───────┴─────────────────┘
```

布局漂移后按 `prefix + =` 一键恢复。

AI 工具组合选项（8 种，左下/右上/右下各选 claude 或 codex）：
1. codex / claude / claude（默认）
2. claude / claude / claude
3. claude / codex / codex
4. codex / codex / codex
5. claude / claude / codex
6. claude / codex / claude
7. codex / claude / codex
8. codex / codex / claude

## Lazygit 快捷键

| 快捷键 | 功能 |
|--------|------|
| `j/k` | 上下移动 |
| `Space` | 暂存/取消暂存 |
| `c` | 提交 |
| `d` | 查看 diff |
| `p` | 推送 |
| `P` | 拉取 |
| `b` | 分支操作 |
| `?` | 帮助 |

## claude-workflow 命令

| 命令 | 功能 |
|------|------|
| `claude-workflow start` | 启动 Ghostty + Claude + Lazygit 分屏 |
| `claude-workflow parallel <name>` | 创建并行 worktree 并启动 Claude |
| `claude-workflow list` | 查看所有 worktree |
| `claude-workflow clean <name>` | 清理已完成的 worktree |
