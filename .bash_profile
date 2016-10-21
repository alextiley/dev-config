export NODE_ENV='development'

# Auto cd into Development folder
cd ~/Development > /dev/null

# NPM Specific configuration
NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# git specific environment vars
GIT_PS1_SHOWDIRTYSTATE=true

# Ensure these paths are prepended to the $PATH var
export PATH="${HOME}/.bin:/usr/local/bin:/usr/bin:$PATH"

# Add MySQL to the PATH variable
export PATH="/usr/local/mysql/bin:$PATH"

# Change Prompt
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u@localhost: \w\[\033[1;33m\]\$(parse_git_branch)\[\033[0m\] -> \[$(tput sgr0)\]"

# Add color to terminal (from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/)
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Enable git auto completion
test -f ~/.git-completion.bash && . $_

# Add useful aliases to the shell
alias ll='ls -lah'  # Preferred 'ls' implementation
cd() { builtin cd "$@"; ll; }   # Always list directory contents upon 'cd'
alias ..='cd ../'   # Go back 1 directory level
alias finder='open -a Finder ./'    # f: Opens current directory in MacOS Finder
alias ~="cd ~"  # ~: Go Home
alias which='type -all' # which: Find executables
trash () { command mv "$@" ~/.Trash ; } # trash: Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql: Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT: Pipe content to file on MacOS Desktop
zipf () { zip -r "$1".zip "$1" ; }          # zipf: create a ZIP archive of a folder
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete" # Recursively delete .DS_Store files
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'  # show hidden files in Finder
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE' # hide hidden files in Finder
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias port='lsof -n -i4TCP:$PORT | grep LISTEN'

# cd's to frontmost window of mac os x finder
cdf () {
    currFolderPath=$( /usr/bin/osascript <<EOT
        tell application "Finder"
            try
        set currFolder to (folder of the front window as alias)
            on error
        set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath"
}

# Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# View stdout of already running process
capture () {
    sudo dtrace -p "$1" -qn '
    	syscall::write*:entry
	/pid == $target && arg0 == 1/ {
	    printf("%s", copyinstr(arg1, arg2));
	}
    '
}
