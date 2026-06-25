#!/bin/bash
# Reset dev-workspace 5-pane layout to standard proportions
# Usage: reset-layout.sh [session-name]
#
# ┌───────────┬─────────────────┐
# │ 1 lazygit │ 4 AI_RT (右上)  │
# ├───┬───────┼─────────────────┤
# │2  │3      │ 5 AI_RB (右下)  │
# │yaz│ AI_LB │                 │
# └───┴───────┴─────────────────┘
#
# Proportions:
#   Left:Right       = 45:55
#   Lazygit:Bottom   = 65:35
#   AI_RT:AI_RB      = 50:50
#   Yazi:AI_LB       = 53:47

S="${1:-$(tmux display-message -p '#S')}"

# Guard against infinite recursion: after-resize-pane hook calls this script,
# which calls resize-pane, which triggers the hook again → fork bomb.
LOCK="/tmp/reset-layout-${S}.lock"
if [[ -f "$LOCK" ]]; then
  exit 0
fi
touch "$LOCK"
trap 'rm -f "$LOCK"' EXIT

# Verify 5 panes exist
PANE_COUNT=$(tmux list-panes -t "$S:1" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$PANE_COUNT" -ne 5 ]]; then
  exit 0
fi

W=$(tmux display-message -t "$S:1" -p '#{window_width}')
H=$(tmux display-message -t "$S:1" -p '#{window_height}')

# 1. Left column width: 45%
tmux resize-pane -t "$S:1.1" -x $((W * 45 / 100))

# 2. Lazygit height: 65%
tmux resize-pane -t "$S:1.1" -y $((H * 65 / 100))

# 3. AI_RT height: 50%
tmux resize-pane -t "$S:1.4" -y $((H / 2))

# 4. Yazi width: 53% of left column
LEFT_W=$((W * 45 / 100))
tmux resize-pane -t "$S:1.2" -x $((LEFT_W * 53 / 100))
