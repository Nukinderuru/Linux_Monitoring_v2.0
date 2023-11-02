#!/bin/bash

function random_number {
    local MAX_NUMBER=$1
    local NUMBER=0
    while [[ $NUMBER -gt $MAX_NUMBER ]] || [[ $NUMBER -le 0 ]];
    do
        local NUMBER=$RANDOM
    done
    echo $NUMBER
}

declare -x -f random_number

function random_path {
    local MAX_DIR_NUMBER=`find / -maxdepth 2 -type d -writable 2> /dev/null | grep -v -e bin -e sbin -e Permission -e "Отказано" | wc -l `
    local NUMBER=$(random_number $MAX_DIR_NUMBER)
    local TARGET=`find / -maxdepth 2 -type d -writable 2> /dev/null | grep -v -e bin -e sbin -e Permission -e "Отказано" | head -$NUMBER | tail +$NUMBER 2> /dev/null`
    echo "$TARGET"
}

declare -x -f random_path