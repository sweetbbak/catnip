#!/bin/bash

declare -a stdin=()

if [ -t 0 ]; then
    echo "Pipe not open"
else
    echo "Pipe available"
    mapfile -t stdin < <(cat -)
fi

echo "${stdin[@]}"