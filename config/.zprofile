export LANG=ja_JP.UTF-8

export DOTFILES_ROOT="$HOME/.dotfiles"
export PATH="$DOTFILES_ROOT/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

[ -d /opt/homebrew ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
