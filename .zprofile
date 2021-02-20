export LANG=ja_JP.UTF-8

export DOTFILES_ROOT="$HOME/.dotfiles"
export PATH="$DOTFILES_ROOT/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

if [ -d /opt/homebrew ]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
