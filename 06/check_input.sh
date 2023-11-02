#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Wrong number of parameters"
    exit
fi

if ! [[ $1 =~ ^[1-4]+$ ]]; then
    echo "Wrong parameter. You should put a number from 1 to 3."
    exit
fi

if ! [[ -e ../04/logs ]]; then
    echo "No logs in /04 directory"
    exit
fi