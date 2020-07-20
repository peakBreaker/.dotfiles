# vim: set foldmethod=marker:
## OH MY ZSH CONFIG ------------------------------------------------- {{{

# Basic configs, add plugins
ZSH_THEME=avit
plugins=(git vi-mode)
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Adding powerlevel9k
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv dir newline vcs)
#POWERLEVEL9K_MODE='awesome-fontconfig'
#POWERLEVEL9K_COLOR_SCHEME='light'
#source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

## }}}
## VARIOUS ---------------------------------------------------------- {{{
# User configuration
#
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
#
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
#
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
#
# Swap escape and caps lock keys - super useful for vim
setxkbmap -option caps:swapescape
## }}}
## ALIASES ---------------------------------------------------------- {{{

envg() {
    # Configures system to google cloud
    echo -n "Setting up gcloud aliases.. "
    alias c="gcloud"
    alias cconf="gcloud config"
    alias cconfls="gcloud config list"
    alias chelp="echo -e '--- Configured for GCLOUD SDK ---\n\tc:gcloud\n\tcconf:config\n\tcconfls:ls config\n\tch:help'"
    echo "OK!"

    # If init is provided, set up a new project
    if [ "$1" = 'init' ]; then
      echo "Initializing new gcloud project!"

    fi
}

# Essentials
alias p="sudo pacman"
alias SS="sudo systemctl"
alias v="vim"
alias sv="sudo vim"
alias r="ranger"
alias sr="sudo ranger"
alias ka="killall"
alias g="git"
alias trem="transmission-remote"
alias mkd="mkdir -pv"
alias ref="shortcuts && source ~/.bashrc" # Refresh shortcuts manually and reload bashrc
alias bwl="wal -i ~/.config/wall.jpg -l --saturate 0.65" # Rerun pywal
alias bwd="wal -i ~/.config/wall.jpg --saturate 0.65" # Rerun pywal
alias pi="bash ~/.larbs/wizard/wizard.sh"
alias so="source"
alias sc="sc-im"
alias pingg="ping 8.8.8.8" # ping google dns
alias n="npx" # npm run module shortcut

# Docker
alias dck="docker"
alias dckls='echo "---- CONTAINERS ---- \n" && docker ps -a && echo "\n---- IMAGES ----\n" && docker images -a'
alias dcklsc="docker ps -a"
alias dcklsi="docker images -a"
alias dck-print-env="env | grep DOCKER_"
alias dck-stop-all="docker container stop $(docker container ls -a -q)"
alias dck-containers-clean="docker container rm $(docker ps -a -q)"
alias dck-images-clean="docker image rm $(docker images -a -q)"
alias dck-all-clean='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'

# Terraform
alias t="terraform"

# Nice terminal programs
alias wa="watson"
alias ws="watson status"
alias wl="watson log -c"
alias nb="newsboat"

# Adding color
alias ls='ls -hN --color=auto --group-directories-first'
alias grep="grep --color=auto" # Color grep - highlight desired sequence.
alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlighting.

# Internet
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="youtube-dl -x --audio-format mp3 --add-metadata -xic" # Download only audio
alias YT="youtube-viewer"
alias ethspeed="speedometer -r enp0s25"
alias wifispeed="speedometer -r wlp3s0"
alias starwars="telnet towel.blinkenlights.nl"

## }}}
## SSH IN ENVIRONMENT ----------------------------------------------- {{{
# Add code to handle the ssh key password in env variable
# Running this provides that we have password on our ssh key
## Highly recommended for security reasons
SSH_ENV="$HOME/.ssh/environment"
start_agent ()
{
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}
# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
## }}}
## PATH SETTING AND ENV VARS ---------------------------------------- {{{
## Add to path
export PATH=$PATH:$HOME/.local/bin/
# SSH Path
export SSH_KEY_PATH="~/.ssh/rsa_id"
# Set vim as default editor 
export VISUAL=vim
export EDITOR="$VISUAL"
# Set some important env vars
export TERMINAL="st"
#export BROWSER=brave
export GOPATH=$(echo $(go env | awk '$1 ~ /^GOPATH/ {print}' | sed -e 's/[^"]*[^"]//' -e 's/"//g'))
export DOTFILES_INSTALLED='true'
## }}}
## PYWAL ------------------------------------------------------------ {{{
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# (cat ~/.cache/wal/sequences &)
# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences
# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh
## }}}
## KEYBINDINGS FOR TERMINAL ----------------------------------------- {{{
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
## }}}
## GRAVEYARD/OTHER -------------------------------------------------- {{{
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
## }}}
source ~/.shortcuts
source ~/.kubectl_aliases
source ~/.scripts/wrk

PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin/
