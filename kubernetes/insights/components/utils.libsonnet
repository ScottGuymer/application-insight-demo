{
  jaegerEnv(name = "myapp", port = "6831") ::
    [
      {
        name: "JAEGER_AGENT_HOST",
        value: "$(JAEGER_AGENT_PORT_6831_UDP_ADDR)"
      },
      {
        name: "JAEGER_AGENT_PORT",
        value: port
      },
      { 
        name: "JAEGER_SERVICE_NAME",
        value: name
      },
      {
        name: "JAEGER_SAMPLER_MANAGER_HOST_PORT",
        value: "jaeger-agent:5778"
      }
    ]
}