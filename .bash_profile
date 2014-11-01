# zsh ------------------------------------------------------------------------
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Turn off flow control
if [ -t 0 ]; then # term test?
    # Turn off TTY "start" and "stop" commands in all interactive shells.
    # They default to C-q and C-s, Bash uses C-s to do a forward history search.
    stty start ''
    stty stop  ''
    stty -ixon # disable XON/XOFF flow control
    stty ixoff # enable sending (to app) of start/stop characters
    stty ixany # let any character restart output, not only start character
fi

# Set color vars
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 257 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9) #5
        ORANGE=$(tput setaf 172) #3 yellow
        GREEN=$(tput setaf 190) #2
        PURPLE=$(tput setaf 141) #4 blue
        WHITE=$(tput setaf 255) #7
    else
        BLACK=$(tput setaf 0)
        RED=$(tput setaf 1)
        GREEN=$(tput setaf 2)
        YELLOW=$(tput setaf 3)
        BLUE=$(tput setaf 4)
        MAGENTA=$(tput setaf 5)
        CYAN=$(tput setaf 6)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi


# aliases ---------------------------------------------------------------------
# Modified/Stolen from:
# http://mths.be/dotfiles

# Shortcuts
alias ll="ls -lFArt"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
# alias la="ls -laF ${colorflag}"

# List only directories
# alias lsd='ls -lF ${colorflag} | grep "^d"'

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Enable aliases to be sudo¿ed
alias sudo='sudo '

# Gzip-enabled `curl`
alias gcurl='curl --compressed'

# Autoresume-enabled `curl` 
alias ccurl='curl -C -'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# View HTTP traffic
#alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
#alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Ring the terminal bell, and put a badge on Terminal.app¿s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
#alias map="xargs -n1"

# One of @janmoesen¿s ProTip¿s
# for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
#     alias "$method"="lwp-request -m '$method'"
# done

if [[ $(uname -s) == "Linux" ]]; then 
    alias pbpaste='xclip -selection clipboard -o'
    alias pbcopy='xclip -selection clipboard'
fi

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"


# exports ---------------------------------------------------------------------
# Set Term
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then 
    export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then 
    export TERM=xterm-256color
fi
[ -n "$TMUX" ] && export TERM=screen-256color

# Make vim the default editor
export EDITOR="vim"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%F %T "
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
# PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}: ${PWD/$HOME/~}\007"'
export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}\007";'"$PROMPT_COMMAND"


# Prefer US English and use UTF-8
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LC_TYPE="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don¿t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:do=01;35:bd=40;33;00:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
if [[ $(uname -s) == "Darwin" ]]; then 
    export LSCOLORS=exgxfxdacxdadahbadacec
fi

# Customize to your needs...
export PATH=$HOME/.local/bin:$HOME/.dotfiles/bin:/usr/local/bin:/usr/local/sbin:$PATH

# third-party -----------------------------------------------------------------

# git
if [[ $(uname -s) == "Darwin" ]]; then 

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

    if [ -f "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh" ]; then

        . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh 
    fi

# rvm
export PATH=$HOME/.rvm/bin:$PATH
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

elif [[ $(uname -s) == "Linux" ]]; then
    :
fi

# virtualenv
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Prompt ----------------------------------------------------------------------
if [[ -n $(type -t __git_ps1) ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="verbose"
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_STATESEPARATOR=" "
   
     PS1="\[${BLACK}\]\u \[$RESET\]at \[$BLACK\]\h \[$RESET\]in \[$BLACK\]\w\$(__git_ps1 \"\[$RESET\] on \[$GREEN\]%s\"  )\[$RESET\]\n\$ "
else
    
    parse_git_dirty () {
        [[ $(git status 2> /dev/null | tail -n1 | cut -c 1-17) != "nothing to commit" ]] && echo "*"
    }
    parse_git_branch () {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
    }

    PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"
fi

# Source files ----------------------------------------------------------------
if [ -r ~/.functions ]; then
    source ~/.functions
fi

if [ -r ~/.profile ]; then
    source ~/.profile
fi

if [ -r ~/.bashrc ]; then
    source ~/.bashrc
fi
