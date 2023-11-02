#!/bin/bash

source ./check_input.sh "$@"
source ./delete.sh

case $1 in
    1)
        delete_by_log_file
    ;;
    2)
        delete_by_time_of_creation
    ;;
    3)
        delete_by_name_mask
    ;;
esac