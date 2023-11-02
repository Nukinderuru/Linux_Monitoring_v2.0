#!/bin/bash
source ./generate_folders.sh
source ./check_input.sh "$@"

cd $1
SIZE=`echo $6 | egrep -o ^[0-9+$]*`
create_folders "$2" "$3" "$4" "${5%.[^.]*}" "${5##*.}" "$SIZE"
