# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""

# oh-my-zsh
plugins=(git golang thefuck pyenv kubectl)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# Proper locale
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# defines the homeshick function
export HOMESHICK_DIR=/usr/local/opt/homeshick
source "/usr/local/opt/homeshick/homeshick.sh"

# General aliases
alias ll='ls -alh'
alias crf='credhub find -n'
alias crg='credhub get -n'

export LPASS_AGENT_TIMEOUT=14400

# npm i -g pure-prompt
#PURE_GIT_PULL=0
autoload -U promptinit; promptinit
# turn on git stash status
zstyle :prompt:pure:git:stash show yes
prompt pure
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f '

# Go
export GOPATH="$HOME"/workspace/go
export GOROOT="$(greadlink -nf /usr/local/opt/go/libexec)"
export PATH="$GOPATH/bin:${GOROOT}/bin:$PATH"

# Ruby
source /usr/local/opt/chruby/share/chruby/chruby.sh

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Vim
export EDITOR=nvim
alias vim=nvim
alias vimdiff="nvim -d"


# fzf settings – enables fuzzy search with "**" like `nvim **`
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use nvim if local env and vim for ssh connection
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# for gpg
export GPG_TTY=$(tty)

# use fd as default find command to traverse the file system while respecting .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

#-------------------------------------------------------------------------------
# SSH Agent
#-------------------------------------------------------------------------------
SSH_ENV=$HOME/.ssh/environment

function start_ssh_agent {
    if [ ! -x "$(command -v ssh-agent)" ]; then
        return
    fi

    if [ ! -d "$(dirname $SSH_ENV)" ]; then
        mkdir -p $(dirname $SSH_ENV)
        chmod 0700 $(dirname $SSH_ENV)
    fi

    ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    chmod 0600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    ssh-add
}

# Source SSH agent settings if it is already running, otherwise start
# up the agent proprely.
if [ -f "${SSH_ENV}" ]; then
     . ${SSH_ENV} > /dev/null
     # ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_ssh_agent
     }
else
    case $UNAME in
      MINGW*)
        ;;
      *)
        start_ssh_agent
        ;;
    esac
fi

# jump for easier dir traversal
if [ -x "$(command -v jump)" ]; then
    eval "$(jump shell)"
fi

# direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi
alias da="direnv allow"

# functions
test_terminal_colors_fonts() {
  echo -e "\e[1mbold\e[0m"
  echo -e "\e[3mitalic\e[0m"
  echo -e "\e[4munderline\e[0m"
  echo -e "\e[9mstrikethrough\e[0m"
  echo -e "\e[31mHello World\e[0m"
  echo -e "\x1B[31mHello World\e[0m"
  awk 'BEGIN{
      s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
      for (colnum = 0; colnum<77; colnum++) {
          r = 255-(colnum*255/76);
          g = (colnum*510/76);
          b = (colnum*255/76);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum+1,1);
      }
      printf "\n";
  }'
}

get_password_from_credhub() {
  local bosh_manifest_password_variable_name=$1
  echo "$(credhub find -j -n ${bosh_manifest_password_variable_name} | jq -r '.credentials[].name' | xargs credhub get -j -n | jq -r '.value')"
}

concourse_login() {
  local concourse_team_name=$1

  local note
  note="$(bw get item 0ac1852b-1165-47c1-a39e-aca500e70235 | jq -r '.notes')"

  local username
  username="$(yq -r '.concourse.username' <<<"$note")"
  local password
  password="$(yq -r '.concourse.password' <<<"$note")"
  fly -t mendix login -u "$username" -p "$password" -n "$concourse_team_name"
}

cf_login() {
  local cf_target=$1
  api="$(bw get item 0ac1852b-1165-47c1-a39e-aca500e70235 | jq -r '.notes' | yq -r ".cf.\"$cf_target\".api")"
  cf login -a "$api" --sso
}

bbl_env() {
  local bosh_env=$1
  cd "$HOME/workspace/mendix/envs/$bosh_env"
  eval "$(bbl print-env)"
}

alias ka='f(){ kubectl "$@" --all-namespaces | grep -v kube-system; unset -f f; }; f'

# FortiVPN
source "$HOME/.config/openfortivpn/openfortivpn.sh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc
source <(fly completion --shell zsh)
export PATH="/usr/local/opt/go@1.15/bin:$PATH"
