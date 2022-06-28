set fish_greeting
set -x FZF_LEGACY_KEYBINDINGS 0

alias ls "exa --icons --group-directories-first --color=auto"
alias ll "ls --long --header --git"
alias la "ll --all"
alias lt "ls --tree"

alias grep "grep --color=auto"
alias fgrep "grep -f --color=auto"
alias egrep "grep -e --color=auto"
alias ncdu "ncdu --color dark -rr"

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

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
end

if status is-interactive
    starship init fish | source
    pyenv init - | source
    zoxide init fish | source
end

# for Mac
alias rm="trash"

function brew
    set --export --local PATH $PATH
    if type -q pyenv
        while contains (pyenv root)/shims $PATH
            set --erase PATH[(contains --index (pyenv root)/shims $PATH)]
        end
    end
    if type -q cargo-install-update-config
        set CARGO_PATH (dirname (which cargo-install-update-config))
        while contains $CARGO_PATH $PATH
            set --erase PATH[(contains --index $CARGO_PATH $PATH)]
        end
    end
    command brew $argv
end