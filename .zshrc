#zmodload zsh/zprof

typeset -U path

if _gemhome=$(ruby -e 'print Gem.user_dir' 2>/dev/null) && [[ -n $_gemhome ]]; then
    export GEM_HOME=$_gemhome GEM_PATH=$_gemhome
    path+=("$_gemhome/bin")
    unset _gemhome
fi

path+=("$HOME/.local/bin")

if [[ -z $LS_COLORS ]] && (( $+commands[dircolors] )); then
    source <(dircolors -b)
fi

autoload -U compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash true
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

mkdir -p "$HOME/.cache/zsh"
compinit -C -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

_comp_options+=(globdots) # Incluir archivos ocultos por defecto

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY             # Comparte e importa historial entre terminales al instante
setopt HIST_IGNORE_DUPS          # No guarda duplicados consecutivos
setopt HIST_IGNORE_SPACE         # Ignora comandos que inicien con espacio
setopt EXTENDED_HISTORY          # Guarda marcas de tiempo
setopt HIST_EXPIRE_DUPS_FIRST    # Elimina duplicados viejos primero si se llena
setopt HIST_FIND_NO_DUPS         # No muestra duplicados al buscar
setopt HIST_SAVE_NO_DUPS         # No guarda duplicados en el disco
setopt HIST_REDUCE_BLANKS        # Elimina espacios innecesarios
setopt HIST_VERIFY               # Muestra el comando expandido antes de ejecutarlo

HISTORY_IGNORE='(ls|la|lh|cd|pwd|exit|clear|z *|zj)'

setopt AUTO_CD                   # Cambia de directorio escribiendo solo la ruta
setopt AUTO_PUSHD                # Guarda historial de navegación de directorios
setopt PUSHD_IGNORE_DUPS         # Evita duplicados en la pila de directorios
setopt NO_BEEP                   # Silencia los pitidos de error
setopt extendedglob              # Habilita patrones de búsqueda avanzados
setopt nocaseglob                # Coincidencia de archivos sin importar mayúsculas
setopt rcexpandparam             # Expansión avanzada de arrays
setopt interactive_comments      # Permite usar '#' para comentarios en la terminal

[[ -t 0 ]] && unsetopt flow_control   # Ctrl+S no congela la terminal

# DELETE
bindkey '^[[3~' delete-char

# SUPR
bindkey '^[[3;2~' backward-delete-char




# Exploración de archivos y contenido
alias ls='eza --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first --git'
alias lh='eza -lh --icons --group-directories-first'
alias tree='eza --tree --icons --level=2'
alias ftree='fzf --preview "eza --tree --color=always {}" --preview-window=right:50%'

alias grep='grep --color=auto'

alias cat='bat --style=header,grid,numbers'
# Copiar / Ver código plano sin números de línea
alias catp='bat -p'

cpfile() {
    if (( ! $+commands[wl-copy] )); then
        print -u2 'wl-copy no disponible (requiere Wayland)'
        return 1
    fi
    bat -p -- "$1" | wl-copy
    print "'$1' copiado al portapapeles"
}

# Inspección de sistema y disco
alias top='btop'
alias df='duf'
alias du='du -h'

# Seguridad y atajos
alias cp='cp -i --reflink=auto'
alias cpr='rsync -ah --info=progress2'
alias mv='mv -iv'
alias rm='rm -I --preserve-root'
alias mkdir='mkdir -pv'
alias help='tldr'
alias ffmpeg='ffmpeg -hide_banner'

# Git rápido
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# Gestión de sesiones Zellij
alias zk='zellij kill-session'        # Borra la sesión en la que estás o la que le digas
alias zka='zellij kill-all-sessions'  # Limpieza total de sesiones

#alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
#alias dash='~/.local/bin/dashboard.lua'



# Chuletas rápidas con cheat.sh
chtsh() {
    (( $# )) || { print -u2 'uso: chtsh <tema>'; return 1 }
    curl -fsS --max-time 5 "https://cheat.sh/$*" | bat --style=plain \
        || print -u2 'Sin conexión a cheat.sh'
}

# ==============================================================================
# 8. INTEGRACIONES Y PLUGINS DE SISTEMA
# ==============================================================================
# FZF (key-bindings y completion incluidos)
source <(fzf --zsh)

# Zoxide (define z, zi, zoxide y su completado)
source <(zoxide init zsh)

# Plugins de /usr/share (Arch Linux)
[[ -f /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh
[[ -f /usr/share/zsh/plugins/zpy/zpy.plugin.zsh ]] && source /usr/share/zsh/plugins/zpy/zpy.plugin.zsh
[[ -f /usr/share/doc/find-the-command/ftc.zsh ]] && source /usr/share/doc/find-the-command/ftc.zsh askfirst

# Autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# Fast Syntax Highlighting (Debe cargarse después de autosuggestions)
[[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && \
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Starship Prompt
source <(starship init zsh)

# ==============================================================================
# 9. ZELLIJ: selector de sesiones y layouts
# ==============================================================================
zj() {
    (( $+commands[zellij] )) || { print -u2 'zellij no está instalado'; return 1 }

    local line name choice action target
    local -a rows f

    for line in ${(f)"$(zellij list-sessions --no-formatting 2>/dev/null)"}; do
        [[ -z $line ]] && continue
        name=${line%% *}
        if [[ $line == *EXITED* ]]; then
            rows+=($'attach\t'"$name"$'\tSesión: '"$name"$' (exited)')
        else
            rows+=($'attach\t'"$name"$'\tSesión: '"$name")
        fi
    done

    rows+=($'new\tdev\tLayout: dev (nvim + shell)')
    rows+=($'new\tyazi-nvim\tLayout: yazi + nvim')
    rows+=($'new\t\tSesión limpia')
    rows+=($'shell\t\tShell normal')

    choice=$(print -rl -- $rows | fzf --delimiter='\t' --with-nth='3..' \
        --header='Zellij' --prompt='> ') || return 0

    f=("${(@ps:\t:)choice}")
    action=$f[1]
    target=$f[2]

    case $action in
        attach) zellij attach "$target" ;;
        new) [[ -n $target ]] && zellij --layout "$target" || zellij ;;
    esac
}
