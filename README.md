# terminal-setup — 终端开发环境复刻包

一套可在新 macOS 上一键复刻的终端开发环境：

- **Ghostty**（Niji 主题 / 全屏 / 半透明）+ **MesloLGS Nerd Font 16pt**
- **tmux**（`Ctrl+A` prefix / Vi 导航）+ **dev-workspace** 五面板布局（lazygit · yazi · codex · 2× claude）
- **Zsh**（autosuggestions · syntax-highlighting · fzf · starship）
- **claude-workflow**（Claude + Lazygit 分屏 + Git Worktree 并行开发）
- **Claude Code statusline**（目录 · git 分支 · context% · 模型）

完整说明、快捷键、布局比例见 [`SKILL.md`](SKILL.md)。

## 目录结构

```
terminal-setup/
├── SKILL.md              # 完整指南（agent 入口 + 人类参考）
├── install.sh            # 幂等安装器：铺配置 + 建 symlink
├── assets/               # 所有配置文件的真实快照（密钥已脱敏为占位符）
│   ├── ghostty/config
│   ├── tmux/.tmux.conf
│   ├── zsh/.zshrc
│   ├── dev-workspace/{dev-workspace,projects,reset-layout.sh,claude-workflow.sh}
│   └── claude-code/statusline-command.sh
└── references/           # 快捷键 / worktree 详解
```

## 在新机器上复刻

```sh
# 1. 克隆到 skill 真实源位置
git clone <this-repo-remote> ~/.agents/skills/terminal-setup

# 2. 一键铺设配置 + 建立 Claude/Codex skill symlink（幂等，先备份再覆盖）
sh ~/.agents/skills/terminal-setup/install.sh

# 3. 按 install.sh 末尾提示：装 brew 依赖 / 字体 / Ghostty，填入密钥
```

`install.sh` 不会装系统依赖（brew / 字体 / Ghostty）——那些重操作保持手动，见 SKILL.md「前置依赖」。

## 密钥约定

`assets/zsh/.zshrc` 中所有凭证（`ANTHROPIC_API_KEY` / `DOUBAO_API_KEY` / `NEXTCODE_PAT` /
`FEISHU_APP_*`）已脱敏为注释占位符。复刻后请：

- 直接填入被注释的 `export`，**或**（推荐）放进 `~/.config/.rc.local`——`.zshrc` 末尾已 `source` 该文件，让密钥与版本化的 dotfile 分离。

**本仓库不应包含任何真实密钥。** 刷新快照时务必重新脱敏并扫描。

## 刷新快照（在源机器上）

活配置改动后，把它同步回本包（保持复刻包与现实对齐）：

```sh
# 复制活配置 → assets/，然后对 .zshrc 重新脱敏，最后 grep 扫描确认无真实密钥残留
```

详见与本次刷新一致的脱敏 + 扫描流程。
