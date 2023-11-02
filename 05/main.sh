#!/bin/bash

file="../04/logs/log1.txt ../04/logs/log2.txt ../04/logs/log3.txt ../04/logs/log4.txt ../04/logs/log5.txt"

function code_sort {
    local count=`cat $file | wc -l`
    for((i=1;i<=$count;i++))
    do
        echo `cat $file | sort -k10 | head -$i | tail +$i`
    done
}

function ip_sort {
    local files="$1"
    local count=`cat $files | awk -F "-" '{print $1}' | sort -u | wc -l`
    for((i=1;i<=$count;i++))
    do
        echo `cat $files | awk -F "-" '{print $1}' | sort -u | head -$i | tail +$i`
    done
}

function error_code_find {
    local count=`cat $file | wc -l`
    for((i=1;i<=$count;i++))
    do
        local code_log=`cat $file | awk '{print $9}' | head -$i | tail +$i`
        if [[ "$code_log" -ge 400 ]]; then
            echo `cat $file | head -$i | tail +$i`
        fi
    done
}

if [[ $# != 1 ]] || [[ ! $1 =~ ^[1-4] ]]
then 
    echo "Error: Invalid parameters."
    exit 1
fi

case $1 in
    1)  
        echo -ne "" > sort_by_code.txt
        code_sort | tee sort_by_code.txt
        ;;
    2)  
        echo -ne "" > sort_by_uniq_ip.txt
        ip_sort "$file" | tee sort_by_uniq_ip.txt
        ;;
    3)  
        echo -ne "" > error_codes.txt
        error_code_find | tee error_codes.txt
        ;;
    4)  
        echo -ne "" > sort_by_uniq_ip_error_code.txt
        touch error_codes.txt
        echo -ne "" > error_codes.txt
        error_code_find > error_codes.txt
        ip_sort error_codes.txt | tee sort_by_uniq_ip_error_code.txt
        ;;
esac