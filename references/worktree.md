# Git Worktree 并行开发

Git Worktree 允许在同一仓库中创建多个工作目录，每个检出不同分支。配合 Claude Code 实现并行 AI 开发。

## 常用命令

```bash
# 创建 worktree（新分支）
git worktree add ../project-feature-a -b feature-a HEAD

# 创建 worktree（已有分支）
git worktree add ../project-bugfix bugfix-branch

# 查看所有 worktree
git worktree list

# 删除 worktree
git worktree remove ../project-feature-a

# 强制删除（有未提交更改时）
git worktree remove ../project-feature-a --force

# 清理无效 worktree
git worktree prune
```

## 并行开发流程

```bash
# 1. 主目录运行 Claude 处理主要任务
cd ~/project
claude

# 2. 创建并行目录处理独立功能
git worktree add ../project-auth -b feature/auth HEAD

# 3. 新终端窗口启动另一个 Claude
cd ../project-auth
claude

# 4. 两个 Claude 实例并行工作
#    - 主目录：重构核心模块
#    - auth 目录：实现认证功能

# 5. 完成后合并
git checkout main
git merge feature/auth

# 6. 清理 worktree
git worktree remove ../project-auth
git branch -d feature/auth
```

## 使用 claude-workflow 脚本快速操作

```bash
claude-workflow start              # 启动 Ghostty + Claude + Lazygit 分屏
claude-workflow parallel <name>    # 创建并行 worktree 并启动 Claude
claude-workflow list               # 查看 worktree
claude-workflow clean <name>       # 清理
```

## 最佳实践

| 场景 | 建议 |
|------|------|
| 独立功能开发 | 每个功能一个 worktree |
| Bug 紧急修复 | 创建 hotfix worktree 不影响当前工作 |
| Code Review | 创建 worktree 检出 PR 分支 |
| 多版本维护 | 不同 worktree 对应不同版本分支 |

## 注意事项

- 同一分支**不能**在多个 worktree 中检出
- worktree 目录建议放在主仓库**同级目录**
- 删除 worktree 前确保所有更改已**提交或暂存**
