# LinuxMonitoring v2.0

Real-time monitoring and research of the system status.\
This file contains the descriptions of the bash scripts located in the folders 01-09.

![Linux_Monitoring_v2.0](/images/LinuxMonitoring2.jpg)

## Contents

1. [File generator](#part-1-file-generator)  
2. [File system clogging](#part-2-file-system-clogging)  
3. [Cleaning the file system](#part-3-cleaning-the-file-system)  
4. [Log generator](#part-4-log-generator)  
5. [Monitoring](#part-5-monitoring)  
6. [GoAccess](#part-6-goaccess)  
7. [Prometheus and Grafana](#part-7-prometheus-and-grafana)  
8. [A ready-made dashboard](#part-8-a-ready-made-dashboard)  
9. [Bonus. Your own node_exporter](#part-9-bonus-your-own-node_exporter)

## Part 1. File generator

This bash script is run with 6 parameters. An example of running a script: \
`main.sh /opt/test 4 az 5 az.az 3kb`

**Parameter 1** is the absolute path. \
**Parameter 2** is the number of subfolders. \
**Parameter 3** is a list of English alphabet letters used in folder names (no more than 7 characters). \
**Parameter 4** is the number of files in each created folder. \
**Parameter 5** - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension). \
**Parameter 6** - file size (in kilobytes, but not more than 100).

When the script runs in the location specified in parameter 1, the folders and files are created in it with the appropriate names and sizes. The scrip stops running if there is 1GB of free space left on the file system (in the / partition).

A log file with data on all created folders and files (full path, creation date, file size) is created.


## Part 2. File system clogging

This bash script is run with 3 parameters. An example of running a script: \
`main.sh az az.az 3Mb`

**Parameter 1** is a list of English alphabet letters used in folder names (no more than 7 characters). \
**Parameter 2** the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension). \
**Parameter 3** - is the file size (in Megabytes, but not more than 100).

When the script is running, folders with files are created in different (any, except paths containing **bin** or **sbin**) locations of the file system.
The number of subfolders is up to 100. The number of files in each folder is a random number (different for each folder). The script stops running when there is 1GB of free space left on the file system (in the / partition).
Check the file system free space with  `df -h /`.

A log file with data on all created folders and files (full path, creation date, file size), as well as start time, end time and total running time of the script is created.


## Part 3. Cleaning the file system

This bash script is run with 1 parameter. The script is able to clear the system from the folders and files created in [Part 2](#part-2-file-system-clogging) in 3 ways:

1. By log file
2. By creation date and time
3. By name mask (i.e. characters, underlining and date).

The cleaning method is set as a parameter with a value of 1, 2 or 3 when you run the script.


## Part 4. Log generator

This bash script generates 5 **nginx** log files in *combined* format. Each log contains information for 1 day.

A random number between 100 and 1000 entries is generated per day.
For the following data is generated randomly:

1. IP (any correct one)
2. Response codes (200, 201, 400, 401, 403, 404, 500, 501, 502, 503)
3. methods (GET, POST, PUT, PATCH, DELETE)
4. Dates (within a specified log day in ascending order)
5. Agent request URL
6. Agents (Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool)


## Part 5. Monitoring

This bash script parses **nginx** logs from [Part 4](#part-4-log-generator) via **awk**.
The script is run with 1 parameter, which has a value of 1, 2, 3 or 4.

Depending on the value of the parameter, the following dats is output:

1. All entries sorted by response code
2. All unique IPs found in the entries
3. All requests with errors (response code - 4xx or 5xxx)
4. All unique IPs found among the erroneous requests


## Part 6. **GoAccess**

This script uses the GoAccess utility to get the same information as in [Part 5](#part-5-monitoring)


## Part 7. **Prometheus** and **Grafana**

The *installation_and_configuration.md* describes how to install and configure **Prometheus** and **Grafana** on a virtual machine, access their web interfaces from a local machine and manually add to the **Grafana** dashboard a display of CPU, available RAM, free space and the number of I/O operations on the hard disk.

The *report.md* describes some tests run on the virtual machine in order to see how the data in the dashboard will change.


## Part 8. A ready-made dashboard

The *report.md* describes how to download the ready-made dashboard *Node Exporter Quickstart and Dashboard* from **Grafana Labs** official website and run the same tests as in [Part 7](#part-7-prometheus-and-grafana) and a network load test using **iperf3**.


## Part 9. Bonus. Your own *node_exporter*

This bash script collects information on basic system metrics (CPU, RAM, hard disk (capacity)) and makes an html page in **Prometheus** format, which can be served by **nginx**.