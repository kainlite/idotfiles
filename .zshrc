DISABLE_AUTO_TITLE=true

ZSH_THEME=gbt
# Set custom prompt
ZSH=$HOME/.oh-my-zsh
DISABLE_CORRECTION="true"
# DISABLE_UPDATE_PROMPT="true"
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1

# Configuring history
unsetopt share_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_no_store


# Initialize completion
autoload -U compinit
compinit -C
unsetopt correct

# Added slash when changing dirs
zstyle ':completion:*' special-dirs true

# Colorize terminal
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

# Some aliases
alias ls='ls -G'
alias ll='ls -lG'
alias gadd='git add --all .'
alias gc='git commit -S '
alias git='LANGUAGE=en_US.UTF-8 git'
alias glog='git log --graph --color'
alias glogs='git log --stat --color -p'
alias dotfiles_update="cd ~/.dotfiles; rake update; cd -"
alias sshcam="ssh $REMOTEHOST ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mplayer - -idle -demuxer matroska"
alias truefree="free -m | awk 'NR==3 {print \$4 \" MB\"}'"
alias dockerrmv="docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v"
alias dockerrmi="docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi"

# Somewhat important aliases
alias cat='bat -p'
alias help='tldr'

# Nicer history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.history"

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Use vim as the editor
export EDITOR=vim
# GNU Screen sets -o vi if EDITOR=vi, so we have to force it back.
set -o vi

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

# Highlight search results in ack.
export ACK_COLOR_MATCH='red'

# Aliases
function mcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ } # stolen from @topfunky

# Autostart tmux
set -g xterm-keys on
# export TERM=screen-256color
# set -g default-terminal "screen-256color"

# This config doesn't add spaces to the end of the line, but home/end doesn't work
# export TERM=tmux-256color
# export ZSH_TMUX_TERM=tmux-256color
# set -g default-terminal "tmux-256color"
ZSH_TMUX_AUTOSTART="true"

function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}

alias vim="stty stop '' -ixoff ; vim"
alias vims="stty stop '' -ixoff ; vim -S ~/.dotfiles/Session.vim"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"

# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

# Initialize VM
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

plugins=(git ruby bundler git-extras tmux vagrant rbenv kubectl safe-paste)

source $ZSH/oh-my-zsh.sh

# Add paths
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}

# Go path
export GOPATH=$HOME/Projects/go
export PATH=$PATH:$GOPATH/bin

# copy aliases
alias s="screen"
alias sr="screen -r"

# Restore the last backgrounded task with Ctrl-V
function foreground_task() {
  fg
}

# Define a widget called "run_info", mapped to our function above.
zle -N foreground_task

# Bind it to ESC-i.
bindkey "\Cv" foreground_task

# Back and forth history search for current command (fix for tmux)
bindkey "${terminfo[kcuu1]}" up-line-or-search
bindkey "${terminfo[kcud1]}" down-line-or-search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Custom functions
c() { cd ~/Projects/$1; }
_c() { _files -W ~/Projects -/; }
compdef _c c

# Allow minikube to use docker env
if pgrep -f minikube > /dev/null
then
    eval $(minikube docker-env)
fi

# Direnv
eval "$(direnv hook zsh)"

# urxvt
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

if [[ -z "${SSH_AUTH_SOCK}" ]]; then
  dbus-update-activation-environment --systemd DISPLAY
  eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
  export SSH_AUTH_SOCK
fi

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# GBT magic
# alias docker='gbt_docker'
# alias su='gbt_su'
# alias vagrant='gbt_vagrant'

# GBT Configuration
export GBT_CAR_DIR_FG='40;40;40'
export GBT_CAR_DIR_BG='146;231;116'
export GBT_CAR_BG='90;90;90'
export GBT_CAR_FG='250;189;47'
export GBT_CAR_OS_DISPLAY=0
export GBT_CAR_STATUS_DISPLAY=0
export GBT_CAR_DIR_DEPTH='9999'

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
