local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components.java;
local k = import "k.libsonnet";
local utils = import "utils.libsonnet";

local deployment = k.apps.v1beta1.deployment;
local container = k.apps.v1beta1.deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;
local service = k.core.v1.service;
local servicePort = k.core.v1.service.mixin.spec.portsType;

local targetPort = params.containerPort;
local labels = {app: params.name};

local env = utils.jaegerEnv(params.name);

local appService = service
  .new(
    params.name,
    labels,
    servicePort.new(params.servicePort, targetPort))
  .withType(params.type);

local appDeployment = deployment
  .new(
    params.name,
    params.replicas,
    container
      .new(params.name, params.image)
      .withImagePullPolicy("Never")
      .withEnv(env)
      .withPorts(containerPort.new(targetPort)),
    labels);

k.core.v1.list.new([appService, appDeployment])