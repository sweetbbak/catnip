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

# booleans
show_menu=false

#save screen
tput smcup

unhide_cursor() {
    # tput cnorm
    printf '\e[?25h'
}

hide_curs() {
    tput civis
}

cleanup() {
    unhide_cursor
    tput rmcup
    tput cnorm
    clear
    exit 0
}

print_menu() {
    # tput 20
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align left --width 50 --margin "20 30" --padding "2 4" \
        '(j/J) to go to next' '(k/K) to go to previous' '(x) copy' \
        '(o) open in nsxiv' '(f) set as bg' '(h/l) left/right' '(n/m) resize' '(q) to quit'

    # tput cup 1 0

}

clean_image() {
    image="${array[$i]}"
    image="${image// /\ }"
}

show_image() {
    tput cup 0 0
    tput el
    printf "\e[40m\e[2K%s\e[0m\e[2;0H" "${count} ${image}"
    tput cup 1 0
    
    [ -f "$image" ] && { 
        kitty +kitten icat --clear --scale-up --place "${size}x${size}@${lx}x${ly}" "${image}"
    }
    if [ "$show_menu" = true ]; then
        # tput cup 10 0
        print_menu
        tput cup 1 0
    fi
}

trap redraw WINCH
trap cleanup EXIT INT
# Hide the cursor (there is probably a much better way to do this)
printf '\e[?25l'

show_image
show_menu=true
while true; do

# menu
    # if [ "$show_menu" = true ]; then
    #     print_menu
    # fi

    read -r -s -n 1 key < /dev/stdin > /dev/null

    array_count="${#array[@]}"
    count="(${x}/${array_count})"

    if [[ "$i" -lt 0 ]]; then
        x=$(( i + array_count ))
    fi

    if [[ "$i" -ge 0 ]]; then
        x=$(( i ))
    fi

case "$key" in
j) i=$((i-1)) ; clean_image ; show_image ;;
k) i=$((i+1)) ; clean_image ; show_image ;;
J) i=$((i-5)) ; clean_image ; show_image ;;
K) i=$((i+5)) ; clean_image ; show_image  ;;
h) lx=$((lx-5)) ; clean_image ; show_image ;;
l) lx=$((lx+5)) ; clean_image ; show_image ;;
m) size=$((size+5)) ; clean_image ; show_image ;;
n) size=$((size-5)) ; clean_image ; show_image ;;
f) clean_image ; feh --no-fehbg --bg-fill "$image" ;;
F) clean_image ; feh --bg-fill "$image" ;;
o) clean_image ; nsxiv "$image" ;;
c) tput clear && show_image ;;
x) clean_image && cb copy "$image" ;;
q) exit 0 ;;
esac
done
