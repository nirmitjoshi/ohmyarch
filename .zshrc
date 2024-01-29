eval "$(starship init zsh)"

# Setting Default Editor

export EDITOR=nvim
export VISUAL=nvim
export PATH=$PATH:/home/nirmit/go/bin/

# Aliases

alias vi=nvim
alias ls='ls -aFh --color=always'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias lf="ls -l | grep -v '^d'" # lists files only
alias ldir="ls -l | grep '^d'" # lists directories only
alias connect-sony="echo -e 'power on\nconnect 84:D3:52:B5:EC:6A\nexit' | bluetoothctl"
alias disconnect-sony="echo -e 'power on\ndisconnect 84:D3:52:B5:EC:6A\nexit' | bluetoothctl"

# Sourcing Plugins

source /home/nirmit/.config/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/nirmit/.config/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf search for hidden files options
export FZF_DEFAULT_COMMAND="fd --type f --type d --hidden"

# Enabling up autojump

if [ -f "/usr/share/autojump/autojump.sh" ]; then
        . /usr/share/autojump/autojump.sh
elif [ -f "/usr/share/autojump/autojump.zsh" ]; then
        . /usr/share/autojump/autojump.zsh
else
        echo "can't found the autojump script"
fi

. ~/.config/firefox/firefox-profile-setup.sh

# Setting History

HISTSIZE=10000 # Set the maximum number of history entries to keep
SAVEHIST=500 # Set the maximum number of lines saved in the history file
HISTFILE=/home/nirmit/.zsh_history # Specify the location of the history file

setopt INC_APPEND_HISTORY # Append to the history file instead of overwriting it
setopt HIST_IGNORE_DUPS # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE # Ignore space, which prevents commands starting with a space from being stored
setopt SHARE_HISTORY # Save the history after each command is executed
setopt APPEND_HISTORY # Merge the history from different sessions when they exit
