#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Wrong number of parameters"
    exit
fi

if ! [[ $1 =~ ^[1-3]+$ ]]; then
    echo "Wrong parameter. You should put a number from 1 to 3."
    exit
fi

if ! [[ -e ./create_files/logs.txt ]]; then
    echo "No log file"
    exit
fi