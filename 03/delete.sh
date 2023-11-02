#!/bin/bash

files_from_log=$(cat ./create_files/logs.txt | awk '{print $1}' | grep "/")

function delete_by_log_file {
    echo "Deleting files from logs.txt...\n"
    for i in $files_from_log; do
        if [[ -d "$i" ]]; then
            echo "$i"
            rm -rf "$i" 2>/dev/null
        fi
    done
    echo -e "Done"
}

declare -x -f delete_by_log_file

function delete_by_time_of_creation {
    echo "Enter start time: YYYY-mm-DD HH:MM"
    read START_TIME
    echo "Enter end time: YYYY-mm-DD HH:MM"
    read END_TIME
    if [[ -z $START_TIME || -z $END_TIME ]]; then
        echo "Date and time is not correct"
    else
        echo -e "Deleting files created from "$START_TIME" to "$END_TIME"..."
        for i in $files_from_log; do
            if [[ -d $i ]]; then
                find "$i" -newermt "$START_TIME:00" ! -newermt "$END_TIME:00" -delete 2>/dev/null
            fi
        done 
    fi
    echo -e "Done"
}

declare -x -f delete_by_time_of_creation

function delete_by_name_mask {
    echo "Enter the name mask in format: foldername_$(date '+%d%m%y') or filename.ext_$(date '+%d%m%y')"
    read NAME_MASK
    if [[ -z $NAME_MASK ]]; then
        echo "Name mask is not correct"
    else
        echo "Deleting files with mask = $NAME_MASK..."
        for i in $files_from_log; do
            if [[ -d "$i" ]]; then
                find "$i" -type f -name "*$NAME_MASK" -delete 2>/dev/null
                find "$i" -type d -name "*$NAME_MASK*" -exec rm -rf {} + 2>/dev/null
            fi
        done
    fi
    echo -e "Done"
}

declare -x -f delete_by_name_mask