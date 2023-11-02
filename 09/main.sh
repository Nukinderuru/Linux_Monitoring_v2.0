#!/bin/bash

while true; do
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
    disk_usage=$(df -h / | awk '/\//{print $(NF-1)}')

    cat <<EOF > /usr/share/nginx/html/metrics.html
# HELP cpu_usage CPU usage
# TYPE cpu_usage gauge
cpu_usage $cpu_usage
# HELP memory_usage Memory usage
# TYPE memory_usage gauge
memory_usage $memory_usage
# HELP disk_usage Disk usage
# TYPE disk_usage gauge
disk_usage $disk_usage
EOF

    sleep 3
done