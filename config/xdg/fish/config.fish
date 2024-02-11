set fish_greeting
set -x FZF_LEGACY_KEYBINDINGS 0

alias ls "eza --icons --group-directories-first --color=auto"
alias ll "ls --long --header --git"
alias la "ll --all"
alias lt "ls --tree"

alias grep "grep --color=auto"
alias ncdu "ncdu --color dark -rr"

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

alias rm "trash"

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
abbr --add gfix git commit --amend --no-edit

if test $TERM_PROGRAM = "WezTerm"
    abbr --add wec wezterm connect
    abbr --add wes wezterm ssh
    alias imgcat "wezterm imgcat"
end

if status is-interactive
    starship init fish | source
    zoxide init fish | source
end
