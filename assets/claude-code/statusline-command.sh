#!/usr/bin/env bash
# Claude Code statusline script
# Shows: current directory, git branch, context usage %, model name

input=$(cat)

# Extract fields from JSON input
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd="${cwd/#$home/\~}"

# Git branch (skip optional locks, suppress errors)
git_branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# Build output with ANSI colors (dimmed-friendly palette)
# Colors: cyan for path, yellow for branch, green/red for context, blue for model
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

parts=""

# Directory
if [ -n "$short_cwd" ]; then
  parts="${parts}$(printf "${CYAN}%s${RESET}" "$short_cwd")"
fi

# Git branch
if [ -n "$git_branch" ]; then
  parts="${parts} $(printf "${YELLOW}[%s]${RESET}" "$git_branch")"
fi

# Context usage
if [ -n "$used_pct" ]; then
  # Round to integer
  pct_int=$(printf "%.0f" "$used_pct")
  if [ "$pct_int" -ge 80 ]; then
    ctx_color="$RED"
  else
    ctx_color="$GREEN"
  fi
  parts="${parts} $(printf "${ctx_color}%s%%%s ctx${RESET}" "$pct_int")"
fi

# Model name
if [ -n "$model" ]; then
  parts="${parts} $(printf "${BLUE}| %s${RESET}" "$model")"
fi

printf "%b\n" "$parts"
