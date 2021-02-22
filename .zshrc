if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
    if [[ $ITERM_PROFILE == "guake" ]]; then
        SESSION_NAME=guake
    else
        SESSION_NAME=iterm
    fi
    if tmux has-session -t $SESSION_NAME; then
        tmux attach -t $SESSION_NAME && exit
    else
        tmux new -s $SESSION_NAME && exit
    fi
fi
