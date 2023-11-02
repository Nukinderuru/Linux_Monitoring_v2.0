#!/bin/bash

function is_correct_digit {
    [[ $1 =~ ^[0-9]+$ ]] && [[ $1 -gt 0 ]]
}

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
    [ $(df -B 1M / | tail -n 1 | awk '{printf $4}') -gt 1000 ]
}

declare -x -f check_space

if [[ $# != 6 ]]; then
    echo "Wrong number of parameters"
    exit
else
    if ! [ -d $1 ]; then
        echo "Absolute path '$1' must be an existing directory"
        exit
    fi
    if ! is_correct_digit $2 ; then
        echo "Folder amount '$2' must be a number greater than 0"
        exit
    fi
    if ! is_correct_name $3 ; then
        echo "Folder name '$3' should contain no more than 7 English alphabet letters"
        exit
    fi
    if ! is_correct_digit $4 ; then
        echo "Files amount '$4' should be a number greater than 0"
        exit
    fi
    if ! is_correct_name ${5%.[^.]*} ; then
        echo "File name '${5%.[^.]*}' should contain from 1 to 7 English alphabet letters"
        exit
    fi
    if ! is_correct_extension ${5##*.} ; then
        echo "Extension '${5##*.}' should contain from 1 to 3 English alphabet letters"
        exit
    fi
    if ! is_correct_size $6 ; then
        echo "File size '$6' should be a number less or equal 100"
        exit
    fi
fi