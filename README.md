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

To access the Jaeger Dashboard to be able to see the traces you can go to the following URL

http://localhost:16686/search
