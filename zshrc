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
alias ll='ls -ltrFG'
alias la='ls -lhAFG'

alias diff='colordiff'
alias sed='gsed'

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
alias gcp='git cherry-pick'
alias gg='git grep'
alias gb='git branch'
alias gfo='git fetch origin'
alias gpm='git pull origin master'
alias gpc='git rev-parse --abbrev-ref HEAD | git pull origin'
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

alias drs='dc run --service-ports web'
alias drc='dc run web ./bin/rails c'
alias drspec='dc run web ./bin/rspec'
alias drake='dc run web ./bin/rake'
alias dmigrate='dc run web ./bin/rake db:migrate && dc run -e RAILS_ENV=test web ./bin/rake db:reset'
alias dmigrate_reset='dc run web ./bin/rake db:migrate:reset && dc run -e RAILS_ENV=test web ./bin/rake db:reset'

alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfs='terraform show'

alias is='itamae-secrets'

alias grep='grep --color'

alias docker-date-sync='docker run --rm --privileged alpine hwclock -s'

alias rn='react-native'

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
  find . -name '*-e' | xargs rm
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

function peco-select-history() {
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

export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/heroku/bin:$PATH"


export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

function git-init() {
  git init
  git commit -m"Initial commit" --allow-empty
}


# dip
eval "$(dip console)"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
