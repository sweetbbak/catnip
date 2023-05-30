#!/bin/bash
# set -x

# GRADIENT + White on Background
# for the ansi option: \e[0;38;2;r;g;bm or \e[0;48;2;r;g;bm :
# lightblu='\e[0;48;2;063;127;255m'
# blu2='\e[0;48;2;063;063;255m'
# blu3='\e[0;48;2;063;000;255m'
# purple='\e[0;48;2;063;000;191m'
NC='\e[0m'

# Gradient + Foreground'
fg_blu_1='\e[0;38;2;127;191;255m'
fg_blu_2='\e[0;38;2;127;127;255m'
fg_blu_3='\e[0;38;2;127;063;255m'
# fg_blu_4='\e[0;38;2;127;000;255m'

# array from light blue to purple to light purple
blu_gradient=(
    '\e[0;38;2;127;191;255m'
    '\e[0;38;2;127;127;255m'
    '\e[0;38;2;127;063;255m'
    '\e[0;38;2;127;000;255m'
    '\e[0;38;2;127;000;255m'
    '\e[0;38;2;127;063;255m'
    '\e[0;38;2;127;127;255m'
    '\e[0;38;2;127;191;255m'
)

cleanup() { 
    tput rmcup && clear && stty echo
    printf '\e[?25h'
}

# tput smcup && clear && stty -echo
# printf '\e[?25l'

# trap cleanup EXIT INT SIGINT CTRL_C

gradient() {
    str="${*}"
    # str="${1}"
    # echo "$@" | fold -w5
    # string=aaaaa ; ${string:0:5} var:index:length - starts at 0 indexing
    array_index=0
    color_index=0
    str_len="${#str}"
    length="$((str_len / 6))"
    while [[ ! $color_index -ge $str_len ]]; do
        # echo "${str:${color_index}:${length}}"
        # echo "${str:$color_index:$length}"
        printf '%b' "${blu_gradient[$array_index]}${str:$color_index:$length}"
        # echo -e "${blu_gradient[$array_index]}${str:$color_index:$length}"
        color_index="$((color_index + length))"
        array_index="$((array_index + 1))"
    done
    printf "%s\n" ""
}


garbled_load_text() {
    LC_ALL=C 
    clear
    read -r LINES COLUMNS < <(stty size)
    X=$((LINES/2))
    Y=$((COLUMNS/2))
    
    for ((p=0;p<50;p++)); do
        tput cup "$X" "$Y"
        tput el
        string=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 15 ; echo)
        # printf "%s%s%s" "${fg_blu_1}${string:5}${NC}" "${fg_blu_2}${string:6:10}${NC}" "${fg_blu_3}${string:11:15}${NC}"
        # echo -e "${fg_blu_1}${string:0:5}${NC}""${fg_blu_2}${string:5:10}${NC}""${fg_blu_3}${string:10:15}${NC}"
        gradient "$string"
        sleep .03
    done
    tput el
}

# garbled_load_text
# gradient 1234567891/abcdefghijklmnopqrstuvwxyz/0123456789

gradient "$@"