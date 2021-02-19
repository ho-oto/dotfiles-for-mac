export LANG=ja_JP.UTF-8

if [ "$TERM_PROGRAM" = "vscode" ]; then
    SESSION_NAME=code

    if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
        option=""
        if tmux has-session -t ${SESSION_NAME}; then
            option="attach -t ${SESSION_NAME}"
        else
            option="new -s ${SESSION_NAME}"
        fi
        tmux $option && exit
    fi
fi

if [ "$TERM_PROGRAM" = "iTerm.app" ] && [[ $ITERM_PROFILE != "guake" ]]; then
    SESSION_NAME=iterm

    if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
        option=""
        if tmux has-session -t ${SESSION_NAME}; then
            option="attach -t ${SESSION_NAME}"
        else
            option="new -s ${SESSION_NAME}"
        fi
        tmux $option && exit
    fi
fi

if [ "$TERM_PROGRAM" = "iTerm.app" ] && [[ $ITERM_PROFILE = "guake" ]]; then
    SESSION_NAME=guake

    if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
        option=""
        if tmux has-session -t ${SESSION_NAME}; then
            option="attach -t ${SESSION_NAME}"
        else
            option="new -s ${SESSION_NAME}"
        fi
        tmux $option && exit
    fi
fi

if [ "$TERM_PROGRAM" = "vscode" ] || [ "$TERM_PROGRAM" = "alacritty" ]; then
    exec fish
fi
