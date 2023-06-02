#!/bin/bash

# export LC_ALL=C

# trap times EXIT

# Cursor to absolute position
cup() { printf '\e[%s;%sH' "$1" "$2" ; }
# Cursor 0, 0
cup_home() { printf '\e[H' ; }
# Move cursor N lines <direction>
cup_up() { printf '\e[%sA' "$1" ; }
cup_down() { printf '\e[%sB' "$1" ; }
cup_right() { printf '\e[%sC' "$1" ; }
cup_left() { printf '\e[%sD' "$1" ; }
# Save and reset cursor position
cup_save() { printf '\e[s' ; }
cup_restore() { printf '\e[u' ; }
# Erase from cursor to end of line
cup_x_eol() { printf '\e[K'; }
# Erase from cursor to start of line
cup_x_sol() { printf '\e[1K'; }
# erase entire line
cup_x_dl() { printf '\e[2K'; }
# erase current line to bottom screen
cup_clear_to_bottom() { printf '\e[J' ; }
# erase current line to top screen
cup_clear_to_top() { printf '\e[1J'; }
# clear screen
cup_x_clear() { printf '\e[2J'; }
# clear screen and move to Home
cup_screen_home() { printf '\e[2J\e[H'; }

termsize() {
    LINES=$(tput lines)
    COLUMNS=$(tput cols)
}

get_term_size() {
    read -r LINES COLUMNS < <(stty size)
}

draw_box() {
    tput clear
    get_term_size

    horiz="$((COLUMNS - 1))"
    vert="$((LINES - 2 ))"
    itera=1
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
    # and then top line
    cup_home && cup_x_eol && printf '╭'
    perl -E "print '─' x $horiz"
    cup_right 1 && printf '╮'

    # input vertical lines on both sides
    for ((itera=1; itera<vert; itera++)); do
        tput cup "$itera" 0 && printf "│"
        tput cup "$itera" "$horiz" && printf "│"
    done

    # put left & right bottom corner
    # and then top line
    cup "$vert" 0 && cup_x_eol && printf '╰'
    perl -E "print '─' x $horiz"
    cup_right 1 && printf '╯'

    # put left & right bottom middle delim
    # and then mid-line
    cup "$((vert - 2))" 0 && cup_x_eol && printf '├'
    perl -E "print '─' x $horiz"
    cup_right 1 && printf '┤'
}

draw_box1() {
    box_chars=( ╭ ╮ ╰ ╯ │ ─ ┑ ┎ ├ ┤ )
    tput clear
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

    # draw vertical lines left then right
    while [[ "$itera" -lt "$vert" ]]; do
        tput cup "$itera" 0 && printf "%s" "${box_chars[4]}"
        tput cup "$itera" "$horiz" && printf "%s" "${box_chars[4]}"
        itera="$(( itera + 1 ))"
    done

    itera=1
    # put corner left & right bottom
    tput cup "$vert" 0 && tput el && printf "%s" "${box_char2}"
    tput cup "$vert" "$horiz"  && printf "%s" "${box_char3}"

    # draw horizontal lines top and bottom
    while [[ "$itera" -lt "$horiz" ]]; do
        tput cup 0 "$itera" && printf "%s" "${box_chars[5]}"
        tput cup "$vert" "$itera" && printf "%s" "${box_chars[5]}"
        itera="$(( itera + 1 ))"
    done

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

draw_box
# draw_box1
