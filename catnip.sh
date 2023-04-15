#!/bin/bash

dir="${1:-/home/sweet/Pictures}"
mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e webp -e jpeg|shuf)
clear

i=0
size=40
lx=0
ly=1
#save screen
tput smcup

unhide_cursor() {
    printf '\e[?25h'
}

cleanup() {
    unhide_cursor
    tput rmcup
    clear
}

show_image() {
    [ -f "$image" ] && { 
        kitty +kitten icat --clear --scale-up --place "${size}x${size}@${lx}x${ly}" "${image}"
        printf "\e[1;35H\e[40m\e[2K%s\e[0m\e[2;0H" "$image"
    }
    tput cup 1 0
}

trap redraw WINCH
trap cleanup EXIT INT
# Hide the cursor (there is probably a much better way to do this)
printf '\e[?25l'

while true; do
    read -r -s -n 1 key < /dev/stdin > /dev/null
    # clear below x line with tput
    tput cup 1 0

    if [[ "$key" == j ]]; then
        i=$((i+1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == k ]]; then
        i=$((i-1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == l ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        lx=$((lx+5))
        show_image
    fi
    if [[ "$key" == h ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        lx=$((lx-5))
        show_image
    fi
    if [[ "$key" == n ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        size=$((size-5))
        show_image
    fi

    if [[ "$key" == m ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        size=$((size+5))
        show_image
    fi
    if [[ "$key" == f ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        feh --no-fehbg --bg-fill "$image"
    fi

    if [[ "$key" == x ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        cb copy "$image"
    fi

    # if [[ "$key" == o ]]; then
    #     image="${array[$i]}"
    #     image="${image// /\ }"
    #     krita "$image"
    # fi

    if [[ "$key" == q ]]; then
        break
    fi
done

image="${array[$i]}"
image="${image// /\ }"
printf "%s\n" "$image"
