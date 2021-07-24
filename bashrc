export BASH_SILENCE_DEPRECATION_WARNING=1
set -o vi

# Colors
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Prompt
export PS1="\[$BLUE\]\W\[$RESET\] > "

GBRANCH=''
UNMODIFIED_PS1="$PS1"

git_prompt_update() {
    local git_check
    git_check=$(git rev-parse --show-toplevel 2>&1)
    if [[ ! "$git_check" =~ fatal ]]
    then
        GBRANCH="$(git branch -a | grep '\*' | cut -d' ' -f2)"
        if [[ ! "$PS1" == *\(*\)* ]]
        then
            export PS1="(\[$RED\]$GBRANCH\[$RESET\]) $UNMODIFIED_PS1"
        fi
    else
        GBRANCH=''
        export PS1="$UNMODIFIED_PS1"
    fi
}

export PROMPT_COMMAND=git_prompt_update


# Colored man pages! (shout-out to rwxrob)
export LESS_TERMCAP_mb="[35m"
export LESS_TERMCAP_md="[33m"
export LESS_TERMCAP_me=""
export LESS_TERMCAP_mb=""
export LESS_TERMCAP_mb="[34m"
export LESS_TERMCAP_mb=""
export LESS_TERMCAP_mb="[4m"

# Aliases
alias ssh='ssh -oServerAliveInterval=30'
alias gba='git branch -a'
alias gc='git commit -am'
alias gbd='git branch -D'
alias gst='git status'
alias ls='ls -G'
alias c=clear

# Functions
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
    local STYLE="38;5"
    for COLOR in {0..255}
    do
        TAG="\e[$STYLE;${COLOR}m"
        echo -ne "$TAG${COLOR}$NONE "
    done
    echo
}

isodate() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}
