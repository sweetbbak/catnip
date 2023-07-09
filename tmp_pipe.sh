#!/bin/bash
prompt="Please select an item:"

options=()

if [ -z "$1" ]
then
  # Get options from PIPE
  input=$(cat /dev/stdin)
  while read -r line; do
    options+=("$line")
  done <<< "$input"
else
  # Get options from command line
  for var in "$@" 
  do
    options+=("$var") 
  done
fi

# Close stdin
0<&-
# open /dev/tty as stdin
exec 0</dev/tty

PS3="$prompt "
select opt in "${options[@]}" "Quit" ; do 
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        break

    else
        echo "Invalid option. Try another one."
    fi
done    
echo $(realpath "${opt}")

