local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components.jaeger;
local k = import "k.libsonnet";
local deployment = k.apps.v1beta1.deployment;
local container = k.apps.v1beta1.deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;
local service = k.core.v1.service;
local servicePort = k.core.v1.service.mixin.spec.portsType;

local labels = {app: params.name};

local agentServicePorts = [
  servicePort.new(5775, 5775).withProtocol("UDP").withName("zipkinthrift"),
  servicePort.new(6831, 6831).withProtocol("UDP").withName("jaegerthrift"),
  servicePort.new(6832, 6832).withProtocol("UDP").withName("jaegerthriftbinary"),
  servicePort.new(5778, 5778).withName("configs"),
  servicePort.new(16686, 16686).withName("frontend"),
  servicePort.new(14268, 14268).withName("jaegerthriftclients"),
  servicePort.new(9411, 9411).withName("zipkin")
];


local jaegerAgent = service
  .new(
    "jaeger-agent",
    labels,
    agentServicePorts)
  .withType("ClusterIP");

local servicePorts = [
  servicePort.new(16686, 16686).withName("frontend"),
];

local jaeger = service
  .new(
    "jaeger",
    labels,
    servicePorts)
  .withType("LoadBalancer");

local ports = [
  containerPort.new(5775).withHostPort(5775).withProtocol("UDP"),
  containerPort.new(6831).withHostPort(6831).withProtocol("UDP"),
  containerPort.new(6832).withHostPort(6832).withProtocol("UDP"),
  containerPort.new(5778).withHostPort(5778),
  containerPort.new(16686).withHostPort(16686),
  containerPort.new(14268).withHostPort(14268),
  containerPort.new(9411).withHostPort(9411)
];


local appDeployment = deployment
  .new(
    params.name,
    params.replicas,
    container
      .new(params.name, params.image)
      .withPorts(ports),
    labels);

k.core.v1.list.new([jaeger, jaegerAgent, appDeployment])