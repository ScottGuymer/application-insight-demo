# gdp-application-insights

This repository is designed to showcase a new way of doing application insights for applications within GDP. It shows how we can leverage new open source technologies to provide deep and reliable insights into the applications that we build across GDP.

It showcases the following techniques
* Logging
* Tracing - OpenTracing and Jaeger
* Metrics - Prometheus

These are illustrated across a number of applications written in the different languages used across GDP.

## Getting Started

Requirements
* Docker
* Minikube
* Ksonnet 0.10.x `brew install ksonnet/tap/ks` or `brew upgrade ksonnet/tap/ks`

If it isnt already, start minikube

```
minikube start --cpus 4 --memory 4096
```

To build the apps and deploy to the cluster you should run the following. It will take a while to run the first time.

```
./build.sh
```

To see the kubernetes dashboard run

```
minikube dashboard
```

To access the Jaeger Dashboard to be able to see the traces you run the following
```
minikube service jaeger
```


You can access any of the example services hosted in the cluster by running one of the following
```
minikube service dotnetcore
minikube service java
minikube service nodejs
minikube service python
```

