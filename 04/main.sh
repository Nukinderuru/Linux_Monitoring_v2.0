#!/bin/bash

LOGS_DIRECTORY="./logs"

response_codes=(
    "200 - OK"
    "201 - Created"
    "400 - Bad Request"
    "401 - Unauthorized"
    "403 - Forbidden"
    "404 - Not Found"
    "500 - Internal Server Error"
    "501 - Not Implemented"
    "502 - Bad Gateway"
    "503 - Service Unavailable"
)

methods=(
    "GET"
    "POST"
    "PUT"
    "PATCH"
    "DELETE"
)

user_agents=(
    "Mozilla"
    "Google Chrome"
    "Opera"
    "Safari"
    "Internet Explorer"
    "Microsoft Edge"
    "Crawler and bot"
    "Library and net tool"
)

if [ ! -d "$LOGS_DIRECTORY" ]; then
    mkdir "$LOGS_DIRECTORY"
fi

date0="$(date +%Y)-$(date +%m)-$(date +%d) 00:00:00 $(date +%z)"

for i in {1..5}; do
    log_file="$LOGS_DIRECTORY/log$i.txt"
    entries_number=$((RANDOM % 900 + 100))
    time_shift=$(shuf -i 50-86 -n1)

    echo "Generating $entries_number log entries in $log_file"

    for j in $(seq 1 $entries_number); do
        ip=$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))
        response_code=${response_codes[RANDOM % ${#response_codes[@]}]}
        method=${methods[RANDOM % ${#methods[@]}]}
        user_agent=${user_agents[RANDOM % ${#user_agents[@]}]}
        url="http://www.example.com/$((RANDOM % 100 + 1))"
        date1="[$(date -d "$date0 + $time_shift seconds"  +'%d/%b/%Y:%H:%M:%S %z')]"
        bytes_number="$(shuf -i 1-120000 -n1)"

        # "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\""
        echo "$ip - - $date1 \"$method $url HTTP/1.0\" $response_code $bytes_number - \"$user_agent\"" >> "$log_file"
        ((time_shift+=$(shuf -i 50-86 -n1) ))
    done
    date0="$(date +%Y)-$(date +%m)-$(date +%d) 00:00:00 $(date +%z)"
    date0="$(date -d "$date0 - $((6-$i)) days" +'%Y-%m-%d')" 
done