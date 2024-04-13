# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname $(dirname $SCRIPT_PATH))"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,path,env,exports,alias,fnm,grep,prompt,completion,fix}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Clean up

unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export

export DOTFILES_DIR

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="/opt/homebrew/opt/bash-git-prompt/share"
    source "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bg/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/bg/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bg/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/bg/Downloads/google-cloud-sdk/completion.bash.inc'; fi

source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

alias ok="nvm use && npm run prettier && npm run lint && npm run build && npm run testci"
alias k=kubectl
alias kx=kubectx
alias kn=kubens

source /Users/bg/.docker/init-bash.sh || true # Added by Docker Desktop

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
