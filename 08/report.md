# Ready-made dashboard

1. First, we need to download a certain dashboard. For that, let's go [here](https://grafana.com/grafana/dashboards/13978-node-exporter-quickstart-and-dashboard/) and сcopy ID to clipboard.

![copy_id_to_import_dashboard](/src/08/images/copy_id_of_dashboard.png)

2. Now let's go to Grafana dashboards and import a new dashboard.

![import_dashboard](/src/08/images/import_dashboard.png)

In the new dashboard paste the ID and press "Load".

![import_dashboard_on_grafana](/src/08/images/type_id_for_import.png)

3. Voila, we have a ready-made dashboard!

![ready_dashboard](/src/08/images/dashboard.png)

4. It's time to carry out the tests. First, let's run the bash script from Part 2.

![dashboard_after_script](/src/08/images/dashboard_after_script.png)

5. The next one is the stress test:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s`

![dashboard_after_stress_test](/src/08/images/dashboard_after_stress.png)

6. And finally, let's run a network load test using iperf3. First of all, we need to start a second virtual machine in the same network. Then run the test itself. We'll need to start listening on one of the machines, using the following command:

`iperf3 -s`

On the second machine we use the following command to start the test:

`iperf3 -c ip-address -f K`

Let's see what we have on the dashboard now:

![dashboard_after_iperf3](/src/08/images/dashboard_after_iperf3.png)