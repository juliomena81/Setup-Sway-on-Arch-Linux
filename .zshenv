export EDITOR=nvim
export VISUAL=nvim
export PAGER=bat

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/gcr/ssh"

export _ZO_EXCLUDE_DIRS="$HOME/Documentos/*:/run/media/*:/mnt/*"
export _ZO_ECHO=1
export _ZO_RESOLVE_SYMLINKS=1

export FZF_DEFAULT_OPTS="--color=bg+:#2f363d,bg:-1,spinner:#e1e4e8,hl:#f97583 --color=fg:#d1d5da,header:#f97583,info:#79b8ff,pointer:#2188ff --color=marker:#34d058,fg+:#fafbfc,prompt:#79b8ff,hl+:#f97583"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
