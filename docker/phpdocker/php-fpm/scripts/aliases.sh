#! /bin/bash

# Colors used for status updates
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

# Commonly Used Aliases
alias ..="cd .."
alias c="clear"
alias cla="clear && ls -l"
alias cll="clear && ls -la"
alias cls="clear && ls"
alias code="cd /var/www"
alias ea="vi ~/aliases"
alias home="cd ~"
alias ra="reload"
alias reload="source ~/.aliases && echo \"$COL_GREEN ==> Aliases Reloaded... $COL_RESET \n \""




# git aliases
alias gaa="git add ."
alias gd="git --no-pager diff"
alias git-revert="git reset --hard && git clean -df"
alias gs="git status"
alias whoops="git reset --hard && git clean -df"


# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$@"
}

function md() {
    mkdir -p "$@" && cd "$@"
}

# Create a new directory and enter it
function updateproject() {
    cd "$@" && git pull &&  rm -rf ./var/cache/* && chmod -R 777 ./var/ && php bin/console doctrine:schema:update --force && chmod -R 777 ./var/
}

# Create a new directory and enter it
function es_populate() {
    php bin/console fos:elastica:populate
    
}
