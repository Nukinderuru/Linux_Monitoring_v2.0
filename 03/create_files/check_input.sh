#!/bin/bash

function is_correct_name {
    [[ $(expr length $1) -gt 0 ]] && [[ $(expr length $1) -le 7 ]] && [[ $1 =~ ^[a-z]+$ ]]
}

function is_correct_extension {
    [[ $(expr length $1) -gt 0 ]] && [[ $(expr length $1) -le 3 ]] && [[ $1 =~ ^[a-z]+$ ]]
}

function is_correct_size {
    SIZE=`echo $1 | egrep -o ^[0-9+$]*`
    [[ $SIZE -gt 0 ]] && [[ $SIZE -le 100 ]]
}

function check_space {
    SIZE_WITH_FILE=$(("$1"+1024))
    [ $(df -B 1M / | tail -n 1 | awk '{printf $4}') -gt $SIZE_WITH_FILE ]
}

declare -x -f check_space

if [[ $# != 3 ]]; then
    echo "Wrong number of parameters"
    exit
else
    if ! is_correct_name $1 ; then
        echo "Folder name '$1' should contain no more than 7 English alphabet letters"
        exit
    fi
    if ! is_correct_name ${2%.[^.]*} ; then
        echo "File name '${2%.[^.]*}' should contain from 1 to 7 English alphabet letters"
        exit
    fi
    if ! is_correct_extension ${2##*.} ; then
        echo "Extension '${2##*.}' should contain from 1 to 3 English alphabet letters"
        exit
    fi
    if ! is_correct_size $3 ; then
        echo "File size '$3' should be a number less or equal 100"
        exit
    fi
fi