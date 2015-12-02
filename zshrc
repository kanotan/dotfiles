export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR=vim
export TERM=screen-256color
setopt nobeep

#---------------------------------------------------------------------------
# History
#---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt hist_no_store
setopt hist_reduce_blanks
setopt extended_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_verify
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#---------------------------------------------------------------------------
# Complement
#---------------------------------------------------------------------------
autoload -U compinit
compinit
setopt auto_pushd
setopt correct
setopt correct_all
setopt hist_expand
setopt list_types
setopt auto_list
setopt auto_menu
setopt list_packed
setopt auto_param_keys
setopt auto_param_slash
setopt mark_dirs
setopt auto_cd
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt nolistbeep

#---------------------------------------------------------------------------
# Appearance
#---------------------------------------------------------------------------
autoload -U colors
colors
setopt prompt_subst
export LSCOLORS=gxfxcxdxbxegedabagacad
zstyle ':completion:*' list-colors 'di=36;49'

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

#---------------------------------------------------------------------------
# Prompt
#---------------------------------------------------------------------------
PROMPT="%{${fg[yellow]}%}%/%{${reset_color}%} "
PROMPT2="%{${fg[yellow]}%}%_%{${reset_color}%} "
SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
RPROMPT="%1(v|%F{green}%1v%f|)"
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{${fg[cyan]}%}%n@${HOST%%.*} ${PROMPT}"

#---------------------------------------------------------------------------
# Alias
#---------------------------------------------------------------------------
alias ll='ls -ltr'
alias la='ls -lhAF'

alias diff='colordiff'

alias be='bundle exec'

alias g='git'
alias gci='git commit'
alias gst='git status --short --branch'
alias glg='git log'
alias gaa='git add . -A'
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gg='git grep'
alias gb='git branch'
alias gfo='git fetch origin'
alias gpm='git pull origin master'
alias -g B='`git branch -a | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

alias gr='greplace'

alias gffs='git flow feature start'
alias gfff='git flow feature finish'

alias tn='tmux new -s'
alias ta='tmux attach -t'

# alias migrate='./bin/spring rake db:migrate; ./bin/annotate -i'
# alias migrate_reset='./bin/spring rake db:migrate:reset; ./bin/annotate -i'
alias migrate='./bin/rake db:migrate && RAILS_ENV=test ./bin/rake db:reset'
alias migrate_reset='./bin/rake db:migrate:reset && RAILS_ENV=test ./bin/rake db:reset'

alias nrs="sudo /etc/init.d/networking restart"

alias rs='./bin/rails s -b 0.0.0.0'
alias rc='./bin/rails c'

alias mc='mailcatcher --ip 0.0.0.0'
alias webserver='ruby -run -ehttpd . -p8000'

alias adb-show-activity="adb shell dumpsys activity top"
alias adb-show-stack="adb shell dumpsys activity | grep -B 1 \"Run #[0-9]*:\""

alias d='docker'
alias dm='docker-machine'
alias dc='docker-compose'

alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfs='terraform show'

#---------------------------------------------------------------------------
# Others
#---------------------------------------------------------------------------
function reload() {
  source $HOME/.zshrc
}

function chpwd() {
  ls
}

function greplace() {
  git grep -l $1 $3 | xargs sed -i -e "s/$1/$2/g"
}

function dmenv() {
  eval "$(docker-machine env $1)"
}

function kill-rails-server() {
  ps aux | grep "[r]ails s" | awk '{print "kill -9",$2}' | sh
}
function kill-rails-console() {
  ps aux | grep "[r]ails c" | awk '{print "kill -9",$2}' | sh
}
function kill-rails() {
  kill-rails-server
  kill-rails-console
}

function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-select-history
bindkey '^r' peco-select-history

if [ -d $HOME/.anyenv  ] ; then
  PATH=$HOME/.anyenv/bin:$PATH
  export PATH
  eval "$(anyenv init -)"
fi
if [ -d $HOME/.rbenv  ] ; then
  PATH=$HOME/.rbenv/bin:$PATH
  export PATH
  eval "$(rbenv init -)"
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

function vmfavrica() {
  cd ~/Vagrants/favrica > /dev/null
  ps aux | grep VBoxHeadless | grep favrica -q || vagrant up
  vagrant ssh
}
