# Application Insights

This repository is designed to showcase a new way of doing application insights for distributed applications. It shows how we can leverage new open source technologies to provide deep and reliable insights into the applications that we build.

It showcases the following techniques

* Logging
* Tracing - OpenTracing and Jaeger
* Metrics - Prometheus

These are illustrated across a number of applications written in the different languages.

## Getting Started

Requirements

* Docker
* Docker Compose

To start the sample you need to use docker compose to build the containers and run them. By running

``` bash
docker-compose up
```

Once everything is running you can see the apps runnign by going to the following URLs

http://localhost:8001 - dotnetcore
http://localhost:8002 - java
http://localhost:8003 - python
http://localhost:8004 - node

To make cross service calls you simply append the route of the service you want to call. For eample if you wanted to use python to call node you would use

http://localhost:8003/node

## Dashbaords

To access the different dashboards you can use the following URLs

http://localhost:16686/ - Jaeger
http://localhost:9090/ - Prometheus
http://localhost:5601/ - Kibana
http://localhost:3000/ - Grafana

## Troubleshooting

Getting elasticsearch to run

* Make sure you have upped your docker VM to at least 4gb memory
* You also need to ensure that the virtual memory setting is correct on the host (not in the container)

From windows you need to 

``` bash
docker run --privileged -it -v /var/run/docker.sock:/var/run/docker.sock jongallant/ubuntu-docker-client 
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host alpine /bin/sh
chroot /host
sysctl -w vm.max_map_count=262144
```

More details can be found here
https://elk-docker.readthedocs.io/#prerequisites
https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count

And details of connecting to the linux host from windows can be found here
https://blog.jongallant.com/2017/11/ssh-into-docker-vm-windows/