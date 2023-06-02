#!/bin/bash

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

draw_box
