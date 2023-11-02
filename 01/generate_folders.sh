#!/bin/bash
source ./check_input.sh

DATE=$(date +%D | awk -F / '{print $2$1$3}')
SCRIPT_PATH=`pwd`

function generate_base {
    LETTERS=$1
    LENGTH=`expr length $LETTERS`
    for (( i=1; i<="$LENGTH"; i++ ))
    do
        arr[$i]=`expr substr $LETTERS $i 1`
        NAME+="${arr[$i]}"
    done
    echo "$NAME"
}

function add_symbol {
    NAME=$1
    LETTERS=$2
    CHAR=$3
    LENGTH=`expr length $LETTERS`
    for (( i=1; i<="$LENGTH"; i++ ))
    do
        arr[$i]=`expr substr $LETTERS $i 1`
    done
    INDEX_SYM=`expr index $NAME ${arr[$CHAR]}`
    NAME=$(expr substr $NAME 1 $INDEX_SYM)${arr[$CHAR]}$(echo ${NAME:$INDEX_SYM})
    echo "$NAME"
}

function create_folders {
    FOLDER_NUMBER=$1
    FOLDER_LETTERS=$2
    FILE_NUMBER=$3
    FILE_LETTERS=$4
    FILE_EXTENSION=$5
    FILE_SIZE=$6
    for (( i=0; i<$FOLDER_NUMBER; i++))
        do
            if ! check_space ; then
                echo "Not enough space"
                exit
            else
                FOLDER_BASE=$(generate_base $FOLDER_LETTERS)
                FOLDER_NAME=$FOLDER_BASE"_"$DATE
                FOLDER_SYM=0
                while [ -e "$FOLDER_NAME" ] || [[ `expr length $FOLDER_BASE` -lt 4 ]];
                do
                    if [[ $FOLDER_SYM -ge `expr length $FOLDER_LETTERS` ]] ||  [[ `expr length $FOLDER_LETTERS` -eq 1 ]]; then
                        FOLDER_SYM=1
                    else
                        FOLDER_SYM=$(($FOLDER_SYM+1))
                    fi
                    FOLDER_BASE=$(add_symbol $FOLDER_BASE $FOLDER_LETTERS $FOLDER_SYM)
                    FOLDER_NAME=$FOLDER_BASE"_"$DATE
                done
                mkdir $FOLDER_NAME
                echo $(pwd)"/$FOLDER_NAME/" `date +%Y-%m-%d-%H-%M` >> $SCRIPT_PATH/logs.txt

                for (( y=0; y<FILE_NUMBER; y++ ))
                do
                    FILE_BASE=$(generate_base $FILE_LETTERS)
                    echo "$FILE_BASE"
                    FILE_NAME=$FOLDER_NAME"/$FILE_BASE.$FILE_EXTENSION"
                    echo "$FILE_NAME"
                    FILE_SYM=0
                    while [ -e "$FILE_NAME" ] || [[ `expr length $FILE_BASE` -lt 4 ]];
                    do
                        if [[ $FILE_SYM -ge `expr length $FILE_LETTERS` ]] ||  [[ `expr length $FILE_LETTERS` -eq 1 ]]; then
                            FILE_SYM=1
                        else
                            FILE_SYM=$(($FILE_SYM+1))
                        fi
                        FILE_BASE=$(add_symbol $FILE_BASE $FILE_LETTERS $FILE_SYM)
                        FILE_NAME=$FOLDER_NAME"/$FILE_BASE.$FILE_EXTENSION"
                    done
                    head -c $FILE_SIZE </dev/urandom > $FILE_NAME
                    echo $(pwd)"/$FILE_NAME" `date +%Y-%m-%d-%H-%M` `ls -lh $FILE_NAME | awk '{print $5}'` >> $SCRIPT_PATH/logs.txt
                done
            fi
        done
}

declare -x -f create_folder
