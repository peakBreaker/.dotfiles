# vim: set foldmethod=marker:
## OH MY ZSH CONFIG ------------------------------------------------- {{{
# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode)
source $ZSH/oh-my-zsh.sh
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
    alias ch="echo -e '--- Configured for GCLOUD SDK ---\n\tc:gcloud\n\tcconf:config\n\tcconfls:ls config\n\tch:help'"
    echo "OK!"

    # If init is provided, set up a new project
    if [ "$1" = 'init' ]; then
      echo "Initializing new gcloud project!"

    fi
}

alias n="npx" # npm run module shortcut
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
alias bw="wal -i ~/.config/wall.png" # Rerun pywal
alias pi="bash ~/.larbs/wizard/wizard.sh"
alias so="source"
alias sc="sc-im"

alias w="watson"
alias ws="watson status"
alias wl="watson log"


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

# TeX
alias Txa="cp ~/Documents/LaTeX/article.tex"
alias Txs="cp ~/Documents/LaTeX/beamer.tex"
alias Txh="cp ~/Documents/LaTeX/handout.tex"
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
export TERMINAL=urxvt
export BROWSER=firefox
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
source ~/.scripts/wrk
