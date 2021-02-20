set fish_greeting
set -x FZF_LEGACY_KEYBINDINGS 0

set -x DOTFILES_ROOT "$HOME/.dotfiles"
set -x PATH "$DOTFILES_ROOT/bin" $PATH

if test -d /opt/homebrew
    set -x PATH "/opt/homebrew/bin" $PATH
end

set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

alias ls="exa --icons --group-directories-first --color=auto"
alias ll="ls --long --header --git"
alias la="ll --all"
alias lt="ls --tree"

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias ncdu="ncdu --color dark -rr"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

abbr --add em emacs
abbr --add lg lazygit

abbr --add ga git add
abbr --add gau git add --update
abbr --add gaa git add --all
abbr --add gc git commit
abbr --add gca git commit -a
abbr --add gcm git commit -m
abbr --add gcam git commit -am
abbr --add gs git status
abbr --add gd git diff
abbr --add gp git push

starship init fish | source
pyenv init - | source
zoxide init fish | source

# for Mac
alias rm="trash"

function brew
    set --export --local PATH $PATH
    if type --quiet pyenv; and contains (pyenv root)/shims $PATH
        set --erase PATH[(contains --index (pyenv root)/shims $PATH)]
    end
    command brew $argv
end