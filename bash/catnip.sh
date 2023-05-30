#!/bin/bash

dir="${1:-/home/sweet/Pictures}"
mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e jpeg)
clear

# size and counters
i=0
x=0
size=40
lx=0
ly=1

# array var's
array_count="${#array[@]}"
count="(${x}/${array_count})"

bg="\e[1;3;38;5;50;48;5;212m"
clr="\e[0m"

# booleans
show_menu=false

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

print_menu() {
    gum style --border=rounded --border-foreground=212 --foreground=212 \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        "j/J - down k/K - up h - left l - right f/F - feh m/n - size + - Nyaa nyaa"
    tput cup 1 0

}

show_image() {
    # tput cup 0 0
    # tput cup $LINES 0;
        # tput el
        # tput cud1

    tput cup 0 0
    tput el
    # printf "\e[1;35H\e[40m\e[2K%s\e[0m\e[2;0H" "${count} ${image}"
    printf "\e[40m\e[2K%s\e[0m\e[2;0H" "${count} ${image}"
    tput cup 1 0
    
    [ -f "$image" ] && { 
        kitty +kitten icat --clear --scale-up --place "${size}x${size}@${lx}x${ly}" "${image}"
        # printf "\e[1;35H\e[40m\e[2K%s %s\e[0m\e[2;0H" "$count" "$image"
        # tput cup $LINES 0;
        # gum style --align=center --width=$COLUMNS \
        #     --background=212 --foreground=50 \
        #     --bold --italic "${count} ${image}"
        # printf "%s%s%s" "${bg}" "$image" "$clr"
    }
    # menx=$(($COLUMNS / 2))
    # meny=$(($LINES / 2))
    # tput cup "$menx" "$meny"
    if [ "$show_menu" = true ]; then
        tput cup $((COLUMNS / 2)) 0
        print_menu
        tput cup 1 0
    fi
}

trap redraw WINCH
trap cleanup EXIT INT
# Hide the cursor (there is probably a much better way to do this)
printf '\e[?25l'

keyhandler() {
    case "$1" in
    j) ;;
    k);;

    esac
}

show_image
while true; do
    read -r -s -n 1 key < /dev/stdin > /dev/null
    # clear below x line with tput
    # tput cup 1 0
    # x="$i"
    array_count="${#array[@]}"
    count="(${x}/${array_count})"
    # check if count is less than 0 ie negative signed
    # and subtract from total to get the correct index
    if [[ "$i" -lt 0 ]]; then
        x=$(( i + array_count ))
    fi

    if [[ "$i" -ge 0 ]]; then
        x=$(( i ))
    fi

    # capture and handle keys
    if [[ "$key" == k ]]; then
        i=$((i+1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == j ]]; then
        i=$((i-1))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == K ]]; then
        i=$((i+5))
        image="${array[$i]}"
        image="${image// /\ }"
        show_image
    fi

    if [[ "$key" == J ]]; then
        i=$((i-5))
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

    if [[ "$key" == F ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        feh --bg-fill "$image"
    fi

    if [[ "$key" == x ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        cb copy "$image"
    fi

    if [[ "$key" == o ]]; then
        image="${array[$i]}"
        image="${image// /\ }"
        nsxiv "$image"
    fi

    if [[ "$key" == c ]]; then
        clear
        show_image
    fi

    if [[ "$key" == i ]]; then
        show_menu=true
    fi

    if [[ "$key" == q ]]; then
        break
    fi
done

image="${array[$i]}"
image="${image// /\ }"
printf "%s\n" "$image"
