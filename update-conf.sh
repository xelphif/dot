#!/usr/bin/env bash
#
# Simple utility to review and manage dotfiles repo.

CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
CONFIG_REPO="$PWD/config"

DEST=$CONFIG_REPO
SRC=$CONFIG_HOME

LESS="less -FRrSX"
DIFF="diff --color=always -u"
CP="cp"


usage() {
    echo "Usage: ${0} [options]
          -h | --help           display this message

          -a | --add            search for new files
          -A | --all            add all modified files to repo
          -s | --status         diplay changes not present in repo"
    exit 2
}


list_files() {
    # Usage: list_files "path"
    
    # Recursively list files
    for file in "$1"/*; do 
        [ -f "$file" ] && printf "%s\n" "${file##"$DEST/"}"
        [ -d "$file" ] && list_files "$file"
    done
}


list_dirs() {
    # Usage: list_dirs "path"
    
    # Recursively list directories
    for file in "$1"/*; do 
        [ -d "$file" ] || continue 
        printf "%s\n" "${file##"$DEST/"}"
        list_dirs "$file"
    done
}


list_modified() {
    # Usage: list_modified

    for file in $(list_files "$DEST"); do 
        [ -f "$SRC/$file" ] \
            && ! cmp -s {"$SRC","$DEST"}/"$file" \
            || continue
        printf "%s\n" "$file"
    done
}

list_untracked() {
    # Usage: list_untracked

    for dir in $(list_dirs "$DEST"); do 
        [ -d "$CONFIG_HOME/$dir" ] || continue
        for file in "$SRC/$dir"/*; do 
            [ -f "$file" ] && [ ! -f "$DEST/${file##"$SRC/"}" ] || continue
            printf "%s\n" "${file##"$SRC/"}"
        done
    done
}

prompt() {
    printf "${INFO} %s: " "$1"
}

copy_modified() {
    # Usage: copy_modified

    for file in $(list_modified); do
        [ -n "$ALL" ] && $CP {"$SRC","$DEST"}/"$file" && continue

        while true; do 
            prompt "Overwrite ${file} in repo? [Y/n/(d)iff]"
            read -r reply
            case $reply in
                [Yy]|"") 
                    $CP {"$SRC","$DEST"}/"$file"
                    break
                    ;;

                [Nn]) break ;;
                [Dd]) $DIFF {"$DEST","$SRC"}/"$file" | $LESS ;;
                *) err "Invalid option" ;;
            esac
        done
    done
}

copy_untracked() {
    # Usage: copy_untracked
    
    for file in $(list_untracked); do
        while true; do 
            prompt "Add ${file} to repo? [Y/n/p]"
            read -r reply
            case $reply in 
                [Yy]|"")
                    $CP {"$SRC","$DEST"}/"$file"
                    break 
                    ;;

                [Nn]) break ;;
                [Pp]) $LESS "$SRC/$file" ;;
                *) err "Invalid option" ;;
            esac
        done
    done
}

display_status() {
    modified=$(list_modified)
    untracked=$(list_untracked)

    [ -z "${modified}${untracked}" ] && printf "Everything up to date.\n" && exit 0

    printf "Changes not present in repo:\n"
    [ -n "$modified" ]  && printf "  ${R}modified:\t%s${N}\n" $(list_modified)
    [ -n "$untracked" ] && printf "  ${U}untracked:\t%s${N}\n" $(list_untracked)
    exit 0
}



err() { 
    printf "${ERR} %s\n" "$1" >&2 
}

ok() { 
    printf "${OK} %s\n" "$1" 
}

B='\033[;1m'    # Bold
N='\033[;m'     # Normal
R='\033[1;91m'  # Red
G='\033[1;32m'  # Green
U='\033[1;90m'  # Gray

ERR="${B}${R}::${N}"
OK="${B}${G}::${N}"
INFO="${B}::${N}"

# terminate early if run as root
if [ "$(id -u)" -eq 0 ]; then
    err "Do not run as root"
    exit 1
fi

PARSED_ARGUMENTS=$(getopt -n update-conf -o Aash --long add,all,status,help -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while true; do
    case "$1" in
        -A | --all)         ALL=1       ; shift ;;
        -a | --add)         ADD=1       ; shift ;;
        -s | --status)           display_status ;;
        -h | --help)                      usage ;;
             --)            shift       ; break ;;
             *)                           usage ;;
    esac
done

copy_modified
[ -n "$ADD" ] && copy_untracked 

ok "All files are up to date"
