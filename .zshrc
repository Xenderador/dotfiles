# ────────────────────────────────────────────────
# ░░ Powerlevel10k Prompt Setup ░░
# ────────────────────────────────────────────────

# Instant prompt (keep near top of .zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Prompt customization
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# ────────────────────────────────────────────────
# ░░ Zsh History & Key Bindings ░░
# ────────────────────────────────────────────────

HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# History search with arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ────────────────────────────────────────────────
# ░░ Zsh Plugins ░░
# ────────────────────────────────────────────────

# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ────────────────────────────────────────────────
# ░░ Environment Variables ░░
# ────────────────────────────────────────────────

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$PATH:/Users/joseanmartinez/.spicetify"
export PATH="$HOME/.rbenv/shims:$PATH"

# ────────────────────────────────────────────────
# ░░ FZF Setup ░░
# ────────────────────────────────────────────────

# Load fzf and key bindings
eval "$(fzf --zsh)"
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# FZF Theme Colors
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Use fd (faster alternative to find)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# FZF Preview Customization
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Custom FZF preview runners
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"                         "$@" ;;
    ssh)          fzf --preview 'dig {}'                                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"               "$@" ;;
  esac
}

# ────────────────────────────────────────────────
# ░░ CLI Tool Enhancements ░░
# ────────────────────────────────────────────────

# Bat (better cat)
export BAT_THEME=tokyonight_night

# Eza (better ls)
alias ls="eza --icons=always"

# TheFuck (command correction)
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# --- Yazi Function: Launches Yazi and Returns to the Selected Directory ---
export EDITOR="nvim"
 
function y() {
	# Create a temporary file to store the new working directory
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	
	# Launch Yazi with any passed arguments, using the temp file to store the new directory path
	yazi "$@" --cwd-file="$tmp"
	
	# If the temp file contains a valid and different directory path, change to that directory
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	
	# Remove the temporary file
	rm -f -- "$tmp"
} 
