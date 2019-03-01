const opentracing = require('opentracing');

const initTracer = require('jaeger-client').initTracer;

const jaegerConfig = {
  serviceName: process.env.JAEGER_SERVICE_NAME,
  reporter: {
    agentHost: process.env.JAEGER_AGENT_HOST,
    agentPort: Number(process.env.JAEGER_AGENT_PORT),
  },
  sampler: {
    host: "jaeger-agent",
    port: 5778,
    param: 1,
    name: 'sampler',
    type: 'remote'
  }
};

const jaegerOptions = {
  logger: console
};

const jaegerTracer = initTracer(jaegerConfig, jaegerOptions);

opentracing.initGlobalTracer(jaegerTracer);

module.export = jaegerTracer