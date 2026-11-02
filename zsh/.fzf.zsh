# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tshow/ghq/github.com/junegunn/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tshow/ghq/github.com/junegunn/fzf/bin"
fi

source <(fzf --zsh)
