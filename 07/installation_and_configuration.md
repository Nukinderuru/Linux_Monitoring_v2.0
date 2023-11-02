# How to Install and Configure Prometheus and Grafana on Ubuntu

To make everything work you will have to follow these steps:

1. [Download and install Prometheus](#prometheus-installation) on the monitoring system.
2. [Configure Prometheus](#prometheus-configuration) to run as a service.
3. [Install Node Exporter](#node-exporter-installation) on all clients.
4. [Configure Prometheus](#prometheus-configuration-to-monitor-client-nodes) to monitor the clients.
5. [Install and deploy the Grafana server](#grafana-installation-and-deploy).
6. [Integrate Grafana and Prometheus](#grafana-and-prometheus-integration).
7. [Create a Dashboard](#creating-a-dashboard) for the Node Exporter Statistics.

## Prometheus installation

1. Visit the Prometheus downloads and make a note of the most recent release. The most recent LTS release is clearly indicated on the site.

2. Use wget to download Prometheus to the monitoring server. The target link has the format https://github.com/prometheus/prometheus/releases/download/v[release]/prometheus-[release].linux-amd64.tar.gz. Replace the string [release] with the actual release to download. For example, the following command downloads release 2.37.6.

`wget https://github.com/prometheus/prometheus/releases/download/v2.37.6/prometheus-2.37.6.linux-amd64.tar.gz`

3. Extract the archived Prometheus files.

`tar xvfz prometheus-*.tar.gz`

4. *(Optional)* After the files have been extracted, delete the archive or move it to a different location for storage.

`rm prometheus-*.tar.gz`

5. Create two new directories for Prometheus to use. The /etc/prometheus directory stores the Prometheus configuration files. The /var/lib/prometheus directory holds application data.

`sudo mkdir /etc/prometheus /var/lib/prometheus`

6. Move into the main directory of the extracted prometheus folder. Substitute the name of the actual directory in place of prometheus-2.37.6.linux-amd64.

`cd prometheus-2.37.6.linux-amd64`

7. Move the prometheus and promtool directories to the /usr/local/bin/ directory. This makes Prometheus accessible to all users.

`sudo mv prometheus promtool /usr/local/bin/`

8. Move the prometheus.yml YAML configuration file to the /etc/prometheus directory.

`sudo mv prometheus.yml /etc/prometheus/prometheus.yml`

9. The consoles and console_libraries directories contain the resources necessary to create customized consoles. This feature is more advanced and is not covered in this guide. However, these files should also be moved to the etc/prometheus directory in case they are ever required.

**Note**
After these directories are moved over, only the LICENSE and NOTICE files remain in the original directory. Back up these documents to another location and delete the prometheus-releasenum.linux-amd64 directory.

`sudo mv consoles/ console_libraries/ /etc/prometheus/`

10. Verify that Prometheus is successfully installed using the below command:

`prometheus --version`

![prometheus_version](/src/07/images/prometheus/version.png)

## Prometheus configuration

1. Create a prometheus user. The following command creates a system user.

`sudo useradd -rs /bin/false prometheus`

2. Assign ownership of the two directories created in the previous section to the new prometheus user.

`sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus`

3. To allow Prometheus to run as a service, create a prometheus.service file using the following command:

`sudo vim /etc/systemd/system/prometheus.service`

4. Enter the following content into the file:

```
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --log.level=info

[Install]
WantedBy=multi-user.targe
```

* The Wants and After options must be set to network-online.target.
* The User and Group fields must both be set to prometheus.
* The ExecStart parameter explains where to find the prometheus executable and defines the default options.
* The config.file option defines the location of the Prometheus configuration file as /etc/prometheus/prometheus.yml.
storage.tsdb.path tells Prometheus to store application data in the /var/lib/prometheus/ directory.
* web.listen-address is set to 0.0.0.0:9090, allowing Prometheus to listen for connections on all network interfaces.
* The web.enable-lifecycle option allows users to reload the configuration file without restarting Prometheus.

5. Reload the systemctl daemon.

`sudo systemctl daemon-reload`

6. *(Optional)* Use systemctl enable to configure the prometheus service to automatically start when the system boots. If this command is not added, Prometheus must be launched manually.

`sudo systemctl enable prometheus`

7. Start the prometheus service and review the status command to ensure it is active.

**Note**
If the prometheus service fails to start properly, run the command journalctl -u prometheus -f --no-pager and review the output for errors.

`sudo systemctl start prometheus`

`sudo systemctl status prometheus`

![prometheus_service](/src/07/images/prometheus/service.png)

7. Access the Prometheus web interface and dashboard at http://local_ip_addr:9090. Replace local_ip_addr with the address of the monitoring server. Because Prometheus is using the default configuration file, it does not display much information yet.

![prometheus_dashboard_empty](/src/07/images/prometheus/Prometheus-Dashboard-Empty.png)

8. The default prometheus.yml file contains a directive to scrape the local host. Click Status and Targets to list all the targets. Prometheus should display the local Prometheus service as the only target.

![prometheus_localhost_targets](/src/07/images/prometheus/Prometheus-Localhost-Target.png)

**Note** To access the web interface of Prometheus from local machine either configure your virtual machine's network as a bridge, or forward the ports. The same goes for the Grafana web interface.

## Node Exporter installation

1. Consult the Node Exporter section of the Prometheus downloads page and determine the latest release.

2. Use wget to download this release. The format for the file is https://github.com/prometheus/node_exporter/releases/download/v[release_num]/node_exporter-[release_num].linux-amd64.tar.gz. Replace [release_num] with the number corresponding to the actual release. For example, the following example demonstrates how to download Node Exporter release 1.5.0.

`wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz`

3. Extract the application.

`tar xvfz node_exporter-*.tar.gz`

4. Move the executable to usr/local/bin so it is accessible throughout the system.

`sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin`

5. *(Optional)* Remove any remaining files.

`rm -r node_exporter-1.5.0.linux-amd64*`

6. There are two ways of running Node Exporter. It can be launched from the terminal using the command node_exporter. Or, it can be activated as a system service. Running it from the terminal is less convenient. But this might not be a problem if the tool is only intended for occasional use. To run Node Exporter manually, use the following command. The terminal outputs details regarding the statistics collection process.

`node_exporter`

7. It is more convenient to run Node Exporter as a service. To run Node Exporter this way, first, create a node_exporter user.

`sudo useradd -rs /bin/false node_exporter`

8. Create a service file for systemctl to use. The file must be named node_exporter.service and should have the following format. Most of the fields are similar to those found in prometheus.service, as described in the previous section.

`sudo vim /etc/systemd/system/node_exporter.service`

```
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

9. *(Optional)* If you intend to monitor the client on an ongoing basis, use the systemctl enable command to automatically launch Node Exporter at boot time. This continually exposes the system metrics on port 9100. If Node Exporter is only intended for occasional use, do not use the command below.

`sudo systemctl enable node_exporter`

10. Reload the systemctl daemon, start Node Exporter, and verify its status. The service should be active.

`sudo systemctl daemon-reload`

`sudo systemctl start node_exporter`

`sudo systemctl status node_exporter`

![node_exporter_service](/src/07/images/node_exporter/node_exporter_service.png)

## Prometheus configuration to Monitor Client Nodes

The client nodes are now ready for monitoring. To add clients to prometheus.yml, follow the steps below:

1. On the monitoring server running Prometheus, open prometheus.yml for editing.

`sudo vim /etc/prometheus/prometheus.yml`

2. Locate the section entitled scrape_configs, which contains a list of jobs. It currently lists a single job named prometheus. This job monitors the local Prometheus task on port 9090. Beneath the prometheus job, add a second job having the job_name of remote_collector. Include the following information.

* A scrape_interval of 10s.
* Inside static_configs in the targets attribute, add a bracketed list of the IP addresses to monitor. Separate each entry using a comma.
* Append the port number :9100 to each IP address.
* To enable monitoring of the local server, add an entry for localhost:9100 to the list.

The entry should resemble the following example. Replace remote_addr with the actual IP address of the client.

```
...
- job_name: "remote_collector"
  scrape_interval: 10s
  static_configs:
    - targets: ["remote_addr:9100"]
```

3. To immediately refresh Prometheus, restart the prometheus service.

`sudo systemctl restart prometheus`

4. Using a web browser, revisit the Prometheus web portal at port 9090 on the monitoring server. Select Status and then Targets. A second link for the remote_collector job is displayed, leading to port 9100 on the client. Click the link to review the statistics.

![prometheus_with_second_target](/src/07/images/prometheus/Prometheus-Second-Target.png)

## Grafana installation and deploy

Prometheus is now collecting statistics from the clients listed in the scrape_configs section of its configuration file. However, the information can only be viewed as a raw data dump. The statistics are difficult to read and not too useful.

Grafana provides an interface for viewing the statistics collected by Prometheus. Install Grafana on the same server running Prometheus and add Prometheus as a data source. Then install one or more panels for interpreting the data. To install and configure Grafana, follow these steps.

1. Install some required utilities using apt.

`sudo apt-get install -y apt-transport-https software-properties-common`

2. Import the Grafana GPG key.

`sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key`

3. Add the Grafana “stable releases” repository.

`echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list`

4. Update the packages in the repository, including the new Grafana package.

`sudo apt-get update`

**Note**
As we are bloody Russian dictators, it is now impossible to download Grafana from Russia. If you face this problem, use VPN for this step.

5. Install the open-source version of Grafana.

**Note**
To install the Enterprise edition of Grafana, use the command `sudo apt-get install grafana-enterprise` instead.

`sudo apt-get install grafana`

6. Reload the systemctl daemon.

`sudo systemctl daemon-reload`

7. Enable and start the Grafana server. Using systemctl enable configures the server to launch Grafana when the system boots.

`sudo systemctl enable grafana-server.service`

`sudo systemctl start grafana-server`

8. Verify the status of the Grafana server and ensure it is in the active state.

`sudo systemctl status grafana-server`

![grafana_service](/src/07/images/grafana/grafana_service.png)

## Grafana and Prometheus integration

To integrate Grafana and Prometheus, follow the steps below:

1. Using a web browser, visit port 3000 of the monitoring server. For example, enter http://local_ip_addr:3000, replacing local_ip_addr with the actual IP address. Grafana displays the login page. Use the user name admin and the default password password. Change the password to a more secure value when prompted to do so.

**Note**
If the "password" doesn't work, try entering "admin" as a password.

![grafana_login_page](/src/07/images/grafana/Grafana-Login-Page.png)

2. After a successful password change, Grafana displays the Grafana Dashboard.

![grafana_home_page](/src/07/images/grafana/grafana_home_page.png)

3. To add Prometheus as a data source, click the menu, then Connections, then select Data Sources.

![grafana_add_data_source](/src/07/images/grafana/data_source.png)

4. At the next display, click the **Add data** source button.

5. Choose **Prometheus** as the data source.

6. For a local Prometheus source, as described in this guide, set the URL to http://localhost:9090. Most of the other settings can remain at the default values.

![add_prometheus](/src/07/images/grafana/add_prometheus.png)

7. When satisfied with the settings, select the Save & test button at the bottom of the screen.

Now you are ready to create your first Dashboard!

## Creating a Dashboard

A dashboard is a group of widgets but it also provides a lot more features like folders, variables (for changing visualizations throughout widgets), time ranges, and auto refresh of widgets.

1. Click on the "Create your first dashboard" table on the right side of the homepage and create a dashboard.

![create_dashboard](/src/07/images/dashboard/create_dashboard.png)

2. Add a row called “Overview”.

A row is a logical divider within a dashboard that can be used to group panels together. A row can be created dynamically by using variables. We will use variables.

![add_row](/src/07/images/dashboard/add_a_row.png)

![row_title](/src/07/images/dashboard/row_title.png)

3. Add a variable.

Variables are a way to create dynamic Grafana dashboards. They can be used to select different instances of metrics. For example, if you are receiving metrics from multiple machines then variables can be used to create drop-downs to select one machine’s metrics. These variables are used in the data source query to support changes in metrics in the dashboard. Let’s add a variable for VM names so that we can select metrics for different VMs.

Variables can be different types, such as:

* **Data source type**: which can be used to dynamically change the data source in the panels.
* **Query type**: where values such as instance names, and server hosts can be fetched. 
* **Interval type**: This can be used to perform aggregation dynamically on the queries like CPU and memory usage, so the last 1m, 5m, and 10m can be seen by using variables without additional panels.

To add a variable go to the dashboard settings and click "Variables", than "Add variable".

![add_variable](/src/07/images/dashboard/add_variable.png)

4. Set the query type to "Label values" and the metric to node_exporter_build_info, which we can use to see different VM stats.

![variable_query](/src/07/images/dashboard/variable_query.png)

5. Add visualization.

In your new dashboard click "Add" and then "Visualization" to add a new panel.

![add_visualization](/src/07/images/dashboard/add_visualization.png)

6. Let's start with the CPU metrics. We want to see the current CPU usage and CPU usage overtime. For seeing current CPU usage we will use **Gauge** type visualization. A Gauge is like a speedometer, it will go up or down in a specific range.

In the right part of the new panel click on "Time series" in order to change it to "Gauge".

![types_of_visualization](/src/07/images/dashboard/type_of_visualization_for_cpu.png)
![gauge_type](/src/07/images/dashboard/gauge.png)

7. Below that there's the "Title" field. Let's change the name to "CPU Usage". Let's also set the "Unit" type to "Percent (0-100)".

![change_title](/src/07/images/dashboard/title.png)
![unit_percent](/src/07/images/dashboard/unit_percent.png)

8. Now let's add the query. You can either use the builder, or type the whole query manually.

![cpu_gauge_query](/src/07/images/dashboard/cpu_gauge.png)

9. Now let's add the time series graph of CPU usage.

![cpu_time_series_query](/src/07/images/dashboard/cpu_time_series.png)

10. To show the available RAM we can use "Stat" type.

![ram_stat](/src/07/images/dashboard/ram_stat.png)

11. To show the free space we can use the "Gauge" type again. Don't forget to set "Unit" to "Percent (0-100)".

![free_space](/src/07/images/dashboard/free_space.png)

12. And finally, let's add the number of I/O operations on the hard disk, using "Time series".

![IO_operations](/src/07/images/dashboard/IO_operations.png)

13. Now we can drag all our panels to the "Overview" row and enjoy watching all the statistics in the same place.

![whole_dashboard](/src/07/images/dashboard/whole_dashboard.png)