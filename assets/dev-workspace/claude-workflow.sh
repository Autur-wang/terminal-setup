#!/bin/bash
# Claude Code + Lazygit + Worktree 工作流脚本

set -e

usage() {
    echo "Claude Code 并行工作流"
    echo ""
    echo "用法: claude-workflow <command> [options]"
    echo ""
    echo "Commands:"
    echo "  start       在 Ghostty 中启动工作流（Claude + Lazygit 分屏）"
    echo "  parallel    创建并行 worktree 并启动 Claude"
    echo "  list        列出所有 worktree"
    echo "  clean       清理完成的 worktree"
    echo ""
    echo "Examples:"
    echo "  claude-workflow start"
    echo "  claude-workflow parallel feature-login"
    echo "  claude-workflow clean feature-login"
}

start_workflow() {
    echo "🚀 启动 Claude Code 工作流..."
    echo ""
    echo "在 Ghostty 中："
    echo "  1. Cmd+D      - 垂直分屏"
    echo "  2. 左边输入    - claude"
    echo "  3. Cmd+L      - 切换到右边"
    echo "  4. 右边输入    - lazygit"
    echo ""
    echo "或使用快捷键："
    echo "  Cmd+Shift+C  - 快速启动 claude"
    echo "  Cmd+Shift+G  - 快速启动 lazygit"
    echo ""

    if command -v ghostty &> /dev/null; then
        open -a Ghostty
    else
        echo "提示: 打开 Ghostty 应用"
    fi
}

create_parallel() {
    local name=$1
    if [ -z "$name" ]; then
        echo "错误: 请指定 worktree 名称"
        echo "用法: claude-workflow parallel <name>"
        exit 1
    fi

    local worktree_path="../axon-$name"
    local branch_name="parallel/$name"

    echo "📁 创建并行 worktree: $worktree_path"
    git worktree add "$worktree_path" -b "$branch_name" HEAD

    echo ""
    echo "✅ 创建成功！"
    echo ""
    echo "启动并行 Claude:"
    echo "  cd $worktree_path && claude"
}

list_worktrees() {
    echo "📋 当前 Worktree 列表:"
    echo ""
    git worktree list
}

clean_worktree() {
    local name=$1
    if [ -z "$name" ]; then
        echo "当前 worktree:"
        git worktree list
        echo ""
        echo "用法: claude-workflow clean <name>"
        exit 1
    fi

    local worktree_path="../axon-$name"

    echo "🗑️  清理 worktree: $worktree_path"
    git worktree remove "$worktree_path" --force 2>/dev/null || true
    git branch -D "parallel/$name" 2>/dev/null || true

    echo "✅ 清理完成"
}

case "$1" in
    start)
        start_workflow
        ;;
    parallel)
        create_parallel "$2"
        ;;
    list)
        list_worktrees
        ;;
    clean)
        clean_worktree "$2"
        ;;
    *)
        usage
        ;;
esac
