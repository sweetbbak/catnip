#!/bin/bash
set -x

declare -a array=()
declare -a extensions
declare findcmd
find_images() {
    # unset array
    # unset dir
    # declare dir
    dir="${1}"
    case "$findcmd" in 
        fd)  
        mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e jpeg)
        ;;
        find) 
        mapfile -d '' array < <(find "$dir" -print0 -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp \))
        ;;
        bash) 
        mapfile -d '' array < <(find "$dir" -print0 -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.gif -o -iname \*.webp \))
        ;;
    esac
    # redraw
}

dependency_check() {
    for x in "$@"; do
        if ! command -v "$x" > /dev/null; then
            return 1
        else
            return 0
        fi
    done
}

if [ -t 0 ]; then
# if [ $# -le 0 ]; then
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help) print_help && exit 0 ;;
        -v|--version) show_version && exit 0 ;;
        -f|--find) shift && findcmd="${1}" ;;
        -e|--ext) shift && extensions+=("${1}");;
        -s|--stdin)  ;;
        -w|--wall)  shift && wallpaper="${1}" ;;
        -p|--preview) shift && img_protocol="${1}";;
        *)  [ -d "$1" ] && dir="$1" ;;
    esac
    shift
done

    if [ -z "$findcmd" ]; then
        if dependency_check fd; then 
            findcmd="fd"
        elif dependency_check find; then
            findcmd="find"
        else
            findcmd="bash"
        fi
    
    fi
    dir="${dir:-$HOME/Pictures}"

    # if stdin isnt open find images
    # mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e jpeg)
    find_images "$dir"
else
    # else pipe is open
    # array="$(\cat -)"
    # mapfile -t array < <(while IFS=$'\n' read -r file ; do printf "%s" "$file"; done < "$inp")
    mapfile -t array < <(cat -)
    # while IFS=$'\n' read -r file ; do
    #     printf "%s" "$file" array+=("$file")
    # done << "$inp"

    # for x in "${array[@]}"; do echo "$x"; done
    # exec 0<&-
fi

echo "$findcmd"
# echo "${extensions[@]}"
# echo "$wallpaper"
# echo "$img_protocol"
echo "$dir"
printf "%s\n" "${array[@]}"
