#!/bin/sh
# install.sh — 在新机器上铺设终端开发环境配置（幂等，先备份再覆盖）。
#
# 用法：
#   git clone <remote> ~/.agents/skills/terminal-setup
#   sh ~/.agents/skills/terminal-setup/install.sh
#
# 本脚本只复制配置文件并建立 skill symlink；不装 Homebrew 包 / 字体 / Ghostty
# （那些重操作请按 SKILL.md「前置依赖」手动执行）。
set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
ASSETS="$SCRIPT_DIR/assets"
STAMP=$(date +%Y%m%d-%H%M%S)

[ -d "$ASSETS" ] || { echo "✗ 找不到 assets 目录：$ASSETS" >&2; exit 1; }

# deploy <src-relative-to-assets> <dest-absolute> [mode]
# 已存在且内容不同 → 先备份为 <dest>.bak-<stamp>，再覆盖。
deploy() {
  src="$ASSETS/$1"
  dest="$2"
  mode="${3:-}"
  [ -f "$src" ] || { echo "✗ 缺失源文件：$src" >&2; return 1; }
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ] && ! cmp -s "$src" "$dest"; then
    cp "$dest" "$dest.bak-$STAMP"
    echo "  ↳ 备份旧文件 → $dest.bak-$STAMP"
  fi
  cp "$src" "$dest"
  [ -n "$mode" ] && chmod "$mode" "$dest"
  echo "✓ $dest"
}

echo "=== 1) 部署配置文件 ==="
deploy ghostty/config                "$HOME/.config/ghostty/config"
# 把 ghostty config 里写死的 /Users/bytedance 改写成本机 $HOME（command= 与 custom-shader= 路径）
if grep -q '/Users/bytedance' "$HOME/.config/ghostty/config" 2>/dev/null; then
  sed "s#/Users/bytedance#$HOME#g" "$HOME/.config/ghostty/config" > "$HOME/.config/ghostty/config.tmp" \
    && mv "$HOME/.config/ghostty/config.tmp" "$HOME/.config/ghostty/config"
  echo "  ↳ 已将 ghostty config 中的 /Users/bytedance 改写为 $HOME"
fi
deploy tmux/.tmux.conf               "$HOME/.tmux.conf"
deploy zsh/.zshrc                    "$HOME/.zshrc"
deploy dev-workspace/dev-workspace   "$HOME/.local/bin/dev-workspace"            755
deploy dev-workspace/projects        "$HOME/.config/dev-workspace/projects"
deploy dev-workspace/reset-layout.sh "$HOME/.config/dev-workspace/reset-layout.sh" 755
deploy dev-workspace/claude-workflow.sh "$HOME/.local/bin/claude-workflow"       755
deploy claude-code/statusline-command.sh "$HOME/.claude/statusline-command.sh"   755

# Ghostty 自定义 shader（星空 / 流星光标 / 黑洞）
if [ -d "$ASSETS/ghostty/shaders" ]; then
  for shader in "$ASSETS"/ghostty/shaders/*.glsl; do
    [ -f "$shader" ] || continue
    deploy "ghostty/shaders/$(basename "$shader")" "$HOME/.config/ghostty/shaders/$(basename "$shader")"
  done
fi

echo ""
echo "=== 2) 建立 skill symlink（Claude / Codex 共享同一真实源）==="
for base in "$HOME/.claude/skills" "$HOME/.codex/skills"; do
  mkdir -p "$base"
  link="$base/terminal-setup"
  if [ -L "$link" ] || [ -e "$link" ]; then
    rm -rf "$link"
  fi
  ln -s "$SCRIPT_DIR" "$link"
  echo "✓ $link → $SCRIPT_DIR"
done

echo ""
echo "=== 3) 收尾（手动）==="
cat <<'EOF'
  1. 填密钥：编辑 ~/.zshrc 中被注释的 export（ANTHROPIC/DOUBAO/NEXTCODE/FEISHU），
     或更推荐——把它们放进 ~/.config/.rc.local（.zshrc 已 source 该文件）。
  2. 装依赖（见 SKILL.md「前置依赖」）：
       brew install tmux fzf lazygit yazi starship nvm \
                    zsh-autosuggestions zsh-syntax-highlighting zsh-completions
       brew install --cask ghostty font-meslo-lg-nerd-font
  3. 在 ~/.claude/settings.json 加入 statusLine 配置（见 SKILL.md）。
  4. 重开终端或 `source ~/.zshrc`，然后 `dev-workspace <项目别名>`。
EOF
echo ""
echo "✅ 配置部署完成。"
