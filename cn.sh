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
# tput smcup

setup_terminal() {
    # Setup the terminal for the TUI.
    # '\e[?1049h': Use alternative screen buffer.
    # '\e[?7l':    Disable line wrapping.
    # '\e[?25l':   Hide the cursor.
    # '\e[2J':     Clear the screen.
    # '\e[1;Nr':   Limit scrolling to scrolling area.
    #              Also sets cursor to (0,0).
    # printf '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$max_items"
    printf '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$LINES"

    # Hide echoing of user input
    stty -echo

    # save IFS and set IFS to null to read enter etc...
    old_IFS="$IFS"
    IFS=''
}

reset_terminal() {
    # Reset the terminal to a useable state (undo all changes).
    # '\e[?7h':   Re-enable line wrapping.
    # '\e[?25h':  Unhide the cursor.
    # '\e[2J':    Clear the terminal.
    # '\e[;r':    Set the scroll region to its default value.
    #             Also sets cursor to (0,0).
    # '\e[?1049l: Restore main screen buffer.
    printf '\e[?7h\e[?25h\e[2J\e[;r\e[?1049l'

    # Show user input.
    stty echo
    IFS="$old_IFS"
}

clear_screen() {
    # Only clear the scrolling window (dir item list).
    # '\e[%sH':    Move cursor to bottom of scroll area.
    # '\e[9999C':  Move cursor to right edge of the terminal.
    # '\e[1J':     Clear screen to top left corner (from cursor up).
    # '\e[2J':     Clear screen fully (if using tmux) (fixes clear issues).
    # '\e[1;%sr':  Clearing the screen resets the scroll region(?). Re-set it.
    #              Also sets cursor to (0,0).
    printf '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
           "$((LINES-2))" "${TMUX:+\e[2J}" "$max_items"
}

get_term_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r LINES COLUMNS < <(stty size)

    # Max list items that fit in the scroll area.
    ((max_items=LINES-3))
}

get_mime_type() {
    # Get a file's mime_type.
    mime_type=$(file "-${file_flags:-biL}" "$1" 2>/dev/null)
}

# Strip non-ascii characters from the string as they're
# used as a key to color the dir items and variable
# names in bash must be '[a-zA-z0-9_]'.
# ls_cols=("${ls_cols[@]//[^a-zA-Z0-9=\\;]/_}")

status_line() {
    # Status_line to print when files are marked for operation.
    local mark_ui="[${#marked_files[@]}] selected (${file_program[*]}) [p] ->"

    # Escape the directory string.
    # Remove all non-printable characters.
    PWD_escaped=${PWD//[^[:print:]]/^[}

    # '\e7':       Save cursor position.
    #              This is more widely supported than '\e[s'.
    # '\e[%sH':    Move cursor to bottom of the terminal.
    # '\e[30;41m': Set foreground and background colors.
    # '%*s':       Insert enough spaces to fill the screen width.
    #              This sets the background color to the whole line
    #              and fixes issues in 'screen' where '\e[K' doesn't work.
    # '\r':        Move cursor back to column 0 (was at EOL due to above).
    # '\e[m':      Reset text formatting.
    # '\e[H\e[K':  Clear line below status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.
    printf '\e7\e[%sH\e[3%s;4%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
           "$((LINES-1))" \
           "${FFF_COL5:-0}" \
           "${FFF_COL2:-1}" \
           "$COLUMNS" "" \
           "($((scroll+1))/$((list_total+1)))" \
           "${marked_files[*]:+${mark_ui}}" \
           "${1:-${PWD_escaped:-/}}" \
           "$LINES"
}


read_dir() {
    # read argumented dir into an array
    local dir="${1:-/home/sweet/Pictures}"
    mapfile -d '' array < <(fd . "$dir" -0 -tf -e png -e jpg -e gif -e svg -e jpeg)
}

unhide_cursor() {
    # tput cnorm
    printf '\e[?25h'
    # show user input
    stty echo
}

hide_curs() {
    tput civis
    stty -echo
}

cleanup() {
    unhide_cursor
    tput rmcup
    tput cnorm
    clear
    reset_terminal
    exit 0
}

print_menu() {
    # printf '\e7\e[%sH\e[3%s;4%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
    # image="$1"
    printf '\e7\e[%sH\e[30;41m%*s\r\e[m\e[%sH\e[K\e8' \
           "$((LINES-1))" \
           "$COLUMNS" "" \
           "$LINES"
           # "${FFF_COL5:-0}" \
           # "${FFF_COL2:-1}" \
           # "($((scroll+1))/$((list_total+1)))" \
           # "${marked_files[*]:+${mark_ui}}" \
           # "${1:-${PWD_escaped:-/}}" \
    cmd_cols="$((COLUMNS / 2))"
    cmd_lines_max="$((LINES - 2))"
    min_lines="$((1))"
    sep='│'
    iter="$min_lines"
    reindex="$((0))"

    while [[ "$iter" -lt "$cmd_lines_max" ]]; do
        reindex="$((i + reindex))"
        tput cup "$iter" "$cmd_cols" && tput el  && printf "%s %s" "$sep" "${array[$reindex]}"
        iter="$(( iter + 1 ))"
        reindex="$((reindex + 1))"
    done

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
        print_menu "$image"
        tput cup 1 0
    fi
}

copy_img() {
    local img="$1"
    local clip="${2:-cb}"
    imgdir="${imgdir:-$HOME/Pictures}"
    case "$clip" in
        xclip) xclip -selection clipboard -target image/png -i "${img}";;
        wl-copy) wl-copy "${img}";;
        xsel) xsel "${img}";;
        unix) sh -c "cp ${img} ${imgdir}";;
        cb) cb copy "${img}" ;;
    esac
}

trap redraw WINCH
trap cleanup EXIT INT
# Hide the cursor (there is probably a much better way to do this)
printf '\e[?25l'
# hide echo of user input
stty echo
reset_terminal
setup_terminal

show_image
show_menu=true
while true; do

# menu
    # if [ "$show_menu" = true ]; then
    #     print_menu "$image"
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
    '') printf "%s\n" "${image}" > /dev/stdout && exit 0;;
    q) exit 0 ;;
esac
done
