#!/bin/bash 

# ^^ Bash, not sh, must be used for read options

# double brackets to test, single equals sign, empty string for just 'enter' in this case...
# if [[ ... ]] is followed by semicolon and 'then' keyword
stty -echo
while true; do
read -r -s -n 1 key  # -s: do not echo input character. -n 1: read only 1 character (separate with space)
    if [[ $key = "" ]]; then 
        echo 'You pressed enter!'
    else
        echo "You pressed '$key'"
    fi

    if [[ $key == "q" ]]; then
        stty echo
        exit 0
    fi
done
