#!/bin/sh
export PATH=$PATH:~/.local/bin:/usr/local/bin
[ "$TMUX" == "" ] || exit 0
tmux has-session -t _default || tmux new-session -s _default -d
PS3="Please choose your session: "
options=("NEW SESSION" "Zsh" $(tmux list-sessions -F "#S"))
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
case $opt in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            title_manual $SESSION_NAME
            tmux new -s "$SESSION_NAME"
            break
            ;;
        "Zsh")
            zsh --login
            break;;
        *)
            title_manual $opt
            tmux attach-session -t $opt
            break
            ;;
    esac
done
