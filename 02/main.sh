#!/bin/bash

start_time=`date +%s%N`
echo "Script start time" - `date +%F" "%H:%M" "%S`s | tee logs.txt

source ./generate_folders.sh
source ./generate_path.sh
source ./check_input.sh "$@"

SIZE=`echo $3 | egrep -o ^[0-9+$]*`
if ! check_space "$SIZE" ; then
    echo "Not enough space"
else
    while check_space "$SIZE";
    do
        TARGET_DIR=$(random_path)
        cd $TARGET_DIR
        DIR_RANDOM_NUMBER=$(random_number 100)
        FILE_RANDOM_NUMBER=$(random_number 100)
        for (( i=0; i<$DIR_RANDOM_NUMBER; i++ ))
        do
            create_folders "$DIR_RANDOM_NUMBER" "$1" "$FILE_RANDOM_NUMBER" "${2%.[^.]*}" "${2##*.}" "$SIZE" "$TARGET_DIR"
        done
        cd $SCRIPT_PATH
    done
fi

end_time=`date +%s%N`
echo "Script end time" - `date +%F" "%H:%M" "%S`s
echo "Script end time" - `date +%F" "%H:%M" "%S`s >> $SCRIPT_PATH/logs.txt
running_time=$(($end_time-$start_time))
seconds=$(($running_time/1000000000))
if [[ $seconds -lt 60 ]]; then
    minutes=0
else
    minutes=$(($seconds/60))
    seconds=$(($seconds%60))
fi
echo "Total running time of the script -" "$minutes" "minutes" "$seconds" "seconds"
echo "Total running time of the script -" "$minutes" "minutes" "$seconds" "seconds" >> $SCRIPT_PATH/logs.txt