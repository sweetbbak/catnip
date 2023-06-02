#!/bin/bash

export LC_ALL=C

trap times EXIT

termsize() {
    LINES=$(tput lines)
    COLUMNS=$(tput cols)
}

get_term_size() {
    read -r LINES COLUMNS < <(stty size)
}

draw_box() {
    horiz="$((COLUMNS - 2))"
    vert="$((LINES - 2))"
    itera=1
    box_char0="╭"
    box_char1="╮"
    box_char2="╰"
    box_char3="╯"
    box_char4="│"
    box_char5="─"
    # box_char6="┑"
    # box_char7="┎"
    box_char8="├"
    box_char9="┤"
    

    # put corner left & right top
    # tput cup 0 0 && tput el && printf "%s" "${box_chars[0]}"
    # tput cup 0 "$horiz"  && printf "%s" "${box_chars[1]}"
    tput cup 0 0 && tput el && printf "%s" "${box_char0}"
    tput cup 0 "$horiz"  && printf "%s" "${box_char1}"

    # draw vertical lines left then right
    # while [[ "$itera" -lt "$vert" ]]; do
    #     tput cup "$itera" 0 && printf "%s" "${box_chars[4]}"
    #     tput cup "$itera" "$horiz" && printf "%s" "${box_chars[4]}"
    #     itera="$(( itera + 1 ))"
    # done
    for ((itera=1; itera<vert; itera++)); do
        tput cup "$itera" 0 && printf "%s" "${box_char4}"
        tput cup "$itera" "$horiz" && printf "%s" "${box_char4}"
    done

    itera=1
    # put corner left & right bottom
    tput cup "$vert" 0 && tput el && printf "%s" "${box_char2}"
    tput cup "$vert" "$horiz"  && printf "%s" "${box_char3}"

    # draw horizontal lines top and bottom
    # while [[ "$itera" -lt "$horiz" ]]; do
    #     tput cup 0 "$itera" && printf "%s" "${box_chars[5]}"
    #     tput cup "$vert" "$itera" && printf "%s" "${box_chars[5]}"
    #     itera="$(( itera + 1 ))"
    # done
    tput cup "$((vert - 2))" 0 && tput el && printf "%s" "${box_char8}"
    tput cup "$((vert - 2))" "$((COLUMNS - 2))" && printf "%s" "${box_char9}"
    for ((itera=1; itera<horiz; itera++)); do
        tput cup 0 "$itera" && printf "%s" "${box_char5}"
        tput cup "$vert" "$itera" && printf "%s" "${box_char5}"
        tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_char5}"
    done

    # menu
    # tput cup "$((vert - 2))" 0 && tput el && printf "%s" "${box_chars[8]}"
    # tput cup "$((vert - 2))" "$((COLUMNS - 2))" && printf "%s" "${box_chars[9]}"

    # itera=1
    # while [[ "$itera" -lt "$horiz" ]]; do
    #     tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_chars[5]}"
    #     # tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_chars[5]}"
    #     itera="$(( itera + 1 ))"
    # done
    
}

draw_box1() {
    box_chars=( ╭ ╮ ╰ ╯ │ ─ ┑ ┎ ├ ┤ )
    get_term_size

    horiz="$((COLUMNS - 2))"
    vert="$((LINES - 2))"
    # itera=1
    # box_char0="╭"
    # box_char1="╮"
    # box_char2="╰"
    # box_char3="╯"
    # box_char4="│"
    # box_char5="─"
    # box_char6="┑"
    # box_char7="┎"
    # box_char8="├"
    # box_char9="┤"
    

    # put corner left & right top
    tput cup 0 0 && tput el && printf "%s" "${box_chars[0]}"
    tput cup 0 "$horiz"  && printf "%s" "${box_chars[1]}"
    # tput cup 0 0 && tput el && printf "%s" "${box_char0}"
    # tput cup 0 "$horiz"  && printf "%s" "${box_char1}"

    # draw vertical lines left then right
    while [[ "$itera" -lt "$vert" ]]; do
        tput cup "$itera" 0 && printf "%s" "${box_chars[4]}"
        tput cup "$itera" "$horiz" && printf "%s" "${box_chars[4]}"
        itera="$(( itera + 1 ))"
    done
    # for ((itera=1; itera<vert; itera++)); do
    #     tput cup "$itera" 0 && printf "%s" "${box_char4}"
    #     tput cup "$itera" "$horiz" && printf "%s" "${box_char4}"
    # done

    itera=1
    # put corner left & right bottom
    tput cup "$vert" 0 && tput el && printf "%s" "${box_chars[2]}"
    tput cup "$vert" "$horiz"  && printf "%s" "${box_chars[3]}"

    # draw horizontal lines top and bottom
    while [[ "$itera" -lt "$horiz" ]]; do
        tput cup 0 "$itera" && printf "%s" "${box_chars[5]}"
        tput cup "$vert" "$itera" && printf "%s" "${box_chars[5]}"
        itera="$(( itera + 1 ))"
    done

    # tput cup "$((vert - 2))" 0 && tput el && printf "%s" "${box_char8}"
    # tput cup "$((vert - 2))" "$((COLUMNS - 2))" && printf "%s" "${box_char9}"

    # for ((itera=1; itera<horiz; itera++)); do
    #     tput cup 0 "$itera" && printf "%s" "${box_char5}"
    #     tput cup "$vert" "$itera" && printf "%s" "${box_char5}"
    #     tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_char5}"
    # done

    # menu
    tput cup "$((vert - 2))" 0 && tput el && printf "%s" "${box_chars[8]}"
    tput cup "$((vert - 2))" "$((COLUMNS - 2))" && printf "%s" "${box_chars[9]}"

    itera=1
    while [[ "$itera" -lt "$horiz" ]]; do
        tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_chars[5]}"
        itera="$(( itera + 1 ))"
        tput cup "$((vert - 2))" "$itera" && printf "%s" "${box_chars[5]}"
    done
    
}

# draw_box
draw_box1
