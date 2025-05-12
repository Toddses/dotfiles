# For homebrew executables
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH=${PATH}:$(brew --prefix)/Cellar/android-sdk/platform-tools:$(brew --prefix)/Cellar/android-sdk/tools
export ANDROID_NDK=$(brew --prefix)/Cellar/android-ndk/r12
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${JAVA_HOME}/bin:$PATH
export PATH="~/Library/Python/3.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
then
	alias colourify="$GRC -es --colour=auto"
	alias configure='colourify ./configure'
	alias diff='colourify diff'
	alias make='colourify make'
	alias gcc='colourify gcc'
	alias g++='colourify g++'
	alias as='colourify as'
	alias gas='colourify gas'
	alias ld='colourify ld'
	alias netstat='colourify netstat'
	alias ping='colourify ping'
	alias traceroute='colourify /usr/sbin/traceroute'
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

#
# Completion
#

# Add tab completion for many Bash commands
if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# homebrew completion
#source `brew --repository`/Library/Contributions/brew_bash_completion.sh

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

#
# Initialize
#

# init z   https://github.com/rupa/z
#. ~/bin/z/z.sh

# setup NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Source Tmuxinator
source ~/.tmuxinator/tmuxinator.bash

#
# SSH Agent
#

# force ssh passphrase to start terminal
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
	echo "Initialising new SSH agent..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	/usr/bin/ssh-add -K ~/.ssh/id_ed25519;
}

# Terminus ENV
export GITHUB_TOKEN=0eada5a5cc26c25e56df34afb694c8bf04543e07
export CIRCLE_TOKEN=0771b4dfd99071554d3adb5b7fe4b3c166b2a222

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

# Include Drush bash customizations.
if [ -f "/Users/tmiller/.drush/drush.bashrc" ] ; then
  source /Users/tmiller/.drush/drush.bashrc
fi

# Include Drush prompt customizations.
if [ -f "/Users/tmiller/.drush/drush.prompt.sh" ] ; then
  source /Users/tmiller/.drush/drush.prompt.sh
fi
