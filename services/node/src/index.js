const route = require('koa-route');
const Koa = require('koa');
const app = new Koa();
const axios = require('axios');
const sleep = require('sleep-async')().Promise;

require('./tracing/tracer')

const opentracing = require('opentracing');
const Tags = opentracing.Tags;
const FORMAT_HTTP_HEADERS = opentracing.FORMAT_HTTP_HEADERS;

const tracer = opentracing.globalTracer();

app.use(async (ctx, next) => {
  const parentSpanContext = tracer.extract(FORMAT_HTTP_HEADERS, ctx.req.headers);
  const span = tracer.startSpan('http_request', {
      childOf: parentSpanContext,
      tags: {[Tags.SPAN_KIND]: Tags.SPAN_KIND_RPC_SERVER}
  });
  ctx.span = span;
  ctx.span.setTag(opentracing.Tags.HTTP_URL, ctx.request.url);
  console.log(`Starting span on ${ctx.request.url}`);
  await next();
  //span.setTag(opentracing.Tags.ERROR, true)
  //span.log({'event': 'error', 'error.object': err, 'message': err.message, 'stack': err.stack})
  ctx.span.finish();
})

// set up a standard controller
const controller = async (ctx, service) => {

  const remoteSpan = tracer.startSpan(`call${service}service`, { childOf: ctx.span });
  let response;

  try {
    const headers = {};
    const url = `http://${service}/`;

    remoteSpan.setTag(Tags.HTTP_URL, url);
    remoteSpan.setTag(Tags.HTTP_METHOD, 'GET');
    remoteSpan.setTag(Tags.SPAN_KIND, Tags.SPAN_KIND_RPC_CLIENT);

    // Send span context via request headers (parent id etc.)
    tracer.inject(remoteSpan, FORMAT_HTTP_HEADERS, headers);

    response = await axios.get(url, { headers });
  } catch (error) {
    remoteSpan.setTag(opentracing.Tags.ERROR, true);
    remoteSpan.log(error.message);

    return ctx.body = {
      message: "Wrapped by nodejs",
      response: `Error talking to service ${service}`
    }
  }

  ctx.body = {
    message: "Wrapped by nodejs",
    response: response.data
  }
  remoteSpan.finish();
}

// set up the root controller to do some work
app.use(route.get('/', async ctx => {
  const sleepTime = Math.floor(Math.random() * 1000) + 0;
  const requestTime = Math.floor(Math.random() * 4) + 0;

  // do a random sleep
  const sleepSpan = tracer.startSpan('sleep', { childOf: ctx.span });
  try {
    if (sleepTime > 900) {
      const err = new Error('I cant wait that long!');
      throw err
    }
    await sleep.sleep(sleepTime);
  } catch (error) {
    sleepSpan.setTag(opentracing.Tags.ERROR, true);
    sleepSpan.log(error.message);
  }

  // do a request to httpbin with a delay
  const requestSpan = tracer.startSpan('httpbinrequest', { childOf: sleepSpan });
  await axios.get(`https://httpbin.org/delay/${requestTime}`);
  requestSpan.finish();

  sleepSpan.finish();

  const responseSpan = tracer.startSpan('sendresponse', { childOf: ctx.span });
  ctx.body = {
    message: 'Hello from nodejs!',
    sleep: sleepTime,
    requestTime: requestTime
  };
  responseSpan.finish();
}));

// set up the routes
app.use(route.get('/:service', controller));

app.listen(3000);
