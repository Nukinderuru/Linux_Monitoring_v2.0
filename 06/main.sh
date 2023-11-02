#!/bin/bash
source ./check_input.sh "$@"

rm -f report.html

if [[ $1 -eq 1 ]]; then
  additional="--sort-panel=STATUS_CODES,BY_DATA,ASC"
fi

if [[ $1 -eq 2 ]]; then
  additional="--sort-panel=VISITORS,BY_VISITORS,ASC"
fi

if [[ $1 -eq 3 ]]; then
  additional="--ignore-status=200 --ignore-status=201 --sort-panel=REQUESTS,BY_DATA,ASC"
fi

if [[ $1 -eq 4 ]]; then
  additional="--ignore-status=200 --ignore-status=201 --sort-panel=VISITORS,BY_VISITORS,ASC"
fi

sudo goaccess -p /etc/goaccess /home/nukinderu/Programming/Practice/21/General/Linux/DO4_LinuxMonitoring_v2.0-1/src/04/logs/log*.txt "$additional" --date-format=%d/%b/%Y --log-format='%h %^ %^ [%d:%t %^] \"%r\" %s %b %^ %u' --time-format=%T -o /home/nukinderu/Programming/Practice/21/General/Linux/DO4_LinuxMonitoring_v2.0-1/src/06/report4.html