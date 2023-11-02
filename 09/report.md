# Your own node_exporter

1. To do this task we will first have to install and start nginx (if you don't have it on your VM):

`sudo apt install nginx-full`

` sudo systemctl enable nginx`

` sudo systemctl start nginx`

2. Then we write a bash script that will write the metrics to a Prometheus-style html file.

3. After that we need to add the location of our new html page to the nginx.conf. It should be something like:

```
http {
   server {
       listen 80;
       location / {
           root /usr/share/nginx/html;
       }
    }
}
```

Don't forget to reload the nginx:

`sudo systemctl reload nginx.service`

4. Finally, we need to add these lines to the prometheus.yml:

```
  - job_name: "my_node"
    static_configs:
      - targets: ["localhost:80"]
```

5. Now we can run the tests from Part 7:

![initial_dashboard](/src/09/images/dashboard.png)

![dashboard_after_stress](/src/09/images/dashboard_after_stress.png)

![dashboard_after_stress](/src/09/images/dashboard_after_script.png)