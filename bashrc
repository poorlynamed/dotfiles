# make macos shut up about zsh
[[ "$OSTYPE" =~ darwin* ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# emacs mode is for people who don't know about ctrl+[ as escape
# (also cmd history search with slash)
set -o vi

# prompt
export PS1="\[$BLUE\]\W\[$RESET\] > "

# set reactive prompt (tracks git branch)
__ps1() {
  local dr='\[\e[31m\]'
  local lr='\[\e[1;31m\]'
  local dg='\[\e[32m\]'
  local lg='\[\e[1;32m\]'
  local dy='\[\e[33m\]'
  local ly='\[\e[1;33m\]'
  local db='\[\e[34m\]'
  local lb='\[\e[1;34m\]'
  local dp='\[\e[35m\]'
  local lp='\[\e[1;35m\]'
  local dt='\[\e[36m\]'
  local lt='\[\e[1;36m\]'
  local dw='\[\e[37m\]'
  local lw='\[\e[1;37m\]'
  local x='\[\e[0m\]'

  PS1=$lg'\u'$dr'@'$lp'\h'$x':'$lb'\W'$x'\$ '

  if [[ ! "$(git rev-parse --show-toplevel 2>&1)" =~ fatal ]]
  then
    if [[ ! "$PS1" == *\(*\)* ]]
    then
      export PS1="($lr$(git branch -a | grep '\*' | cut -d' ' -f2)$x) $PS1"
    fi
  fi
}

PROMPT_COMMAND='__ps1'

# colored man pages! (shout-out to rwxrob)
export LESS_TERMCAP_mb="[35m"
export LESS_TERMCAP_md="[33m"
export LESS_TERMCAP_me=""
export LESS_TERMCAP_mb=""
export LESS_TERMCAP_mb="[34m"
export LESS_TERMCAP_mb=""
export LESS_TERMCAP_mb="[4m"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# convenience aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ssh='ssh -oServerAliveInterval=30'
alias gba='git branch -a'
alias gcam='git commit -am'
alias gco='git checkout'
alias gbd='git branch -D'
alias gst='git status'
alias ls='ls -G'
alias c=clear

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ];then eval "$(dircolors -b ~/.dircolors)";else eval "$(dircolors -b)";fi
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# convenience functions
mac() {
  # Prints out whatever MAC address format you can think of as
  # normal lower-case colon-separated.
  printf "%s" "$1" | sed 's/[:\.]//g; s/](.*\)/\L\1/; s/../&:/g; s/:$//'
}

ipcheck() {
  # Pings an IP with a short timeout / prettyprints status
  while read -r ip
  do
    ping -c1 -W1 "$ip" >/dev/null \
      && printf "%s %s\n" "$ip" "${GREEN}UP$RESET" \
      || printf "%s %s\n" "$ip" "${RED}DOWN$RESET"
  done < "$1"
}

shellcolors() {
  printf "NORMAL:\n\x1b[38;5;0mblack "
  printf "\x1b[38;5;1mred "
  printf "\x1b[38;5;2mgreen "
  printf "\x1b[38;5;3myellow "
  printf "\x1b[38;5;4mblue "
  printf "\x1b[38;5;5mmagenta "
  printf "\x1b[38;5;6mcyan "
  printf "\x1b[38;5;7mwhite\n\n"

  printf "BRIGHT:\n\x1b[38;5;8mblack "
  printf "\x1b[38;5;9mred "
  printf "\x1b[38;5;10mgreen "
  printf "\x1b[38;5;11myellow "
  printf "\x1b[38;5;12mblue "
  printf "\x1b[38;5;13mmagenta "
  printf "\x1b[38;5;14mcyan "
  printf "\x1b[38;5;15mwhite\n\n256 COLOR:\n"

  for i in {16..255}; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( (i-15) % 12 == 0 ));then echo;fi
  done
}

isodate() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# (shout-out to rwxrob)
path() {
  echo -e "${PATH//:/\\n}"
}

# (shout-out to rwxrob)
pathappend() {
  for ARG in "$@"
  do
    test -d "$ARG" || continue
    PATH=${PATH//:$ARG:/:}
    PATH=${PATH/\#$ARG:/}
    PATH=${PATH/%:$ARG/}
    export PATH="${PATH:+"$PATH:"}$ARG"
  done
}

# (shout-out to rwxrob)
pathprepend() {
  for ARG in "$@"
  do
    test -d "$ARG" || continue
    PATH=${PATH//:$ARG:/:}
    PATH=${PATH/\#$ARG:/}
    PATH=${PATH/%:$ARG/}
    export PATH="$ARG${PATH:+":$PATH"}"
  done
}

# Typical bash settings
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=30000
HISTFILESIZE=50000

# Let's not kid ourselves via nano
export EDITOR=vim
export VISUAL=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# I like fancy glob expansions
shopt -s extglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if test -x /usr/bin/lesspipe; then
  export LESSOPEN="| /usr/bin/lesspipe %s";
  export LESSCLOSE="/usr/bin/lesspipe %s %s";
fi

#pathappend /opt/homebrew/bin
pathappend /usr/local/go/bin
