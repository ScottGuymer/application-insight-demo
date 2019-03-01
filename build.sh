#!/usr/bin/env sh

# remove any current deployment in minikube
$(cd kubernetes/insights && ks delete minikube)

# set the docker environment to minikube
eval $(minikube docker-env --shell bash)

# build the containers in the minikube docker environment
docker build --tag="dotnetcore" services/dotnetcore
docker build --tag="node" services/node
docker build --tag="python" services/python
docker build --tag="java" services/java

# build the tests
docker build --tag="k6test" tests

# deploy the app to minikube
$(cd kubernetes/insights && ks apply minikube)

minikube service jaeger
