import opentracing
from flask_opentracing import FlaskTracer
from jaeger_client import Config
from flask import Flask
from jaeger_client.metrics.prometheus import PrometheusMetricsFactory
import opentracing
import requests
from random import randint
import time
from opentracing.propagation import Format
from opentracing_instrumentation import request_context
import os
import time
from flask import jsonify
import prometheus_client
from flask import Response
from prometheus_flask_exporter import PrometheusMetrics


app = Flask(__name__)
metrics = PrometheusMetrics(app)

# static information as metric
metrics.info('app_info', 'Application info', version='1.0.3')

# opentracing_tracer = ## some OpenTracing tracer implementation
config = Config(
    config={  # usually read from some yaml config
        'sampler': {
            'type': 'const',
            'param': 1,
        },
        'logging': True,
        'local_agent': {
            'reporting_host': os.environ.get('JAEGER_AGENT_HOST', 'localhost'),
            'reporting_port': os.environ.get('JAEGER_AGENT_PORT', 6831),
        },
    },
    service_name='python',
    validate=True,
    metrics_factory=PrometheusMetricsFactory(namespace='python')
)
jaegertracer = config.initialize_tracer()
tracer = FlaskTracer(jaegertracer, True, app)

CONTENT_TYPE_LATEST = str('text/plain; version=0.0.4; charset=utf-8')

@app.route('/metrics/')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype=CONTENT_TYPE_LATEST)


@app.route('/<service>')
def service(service):
    url = "http://" + service
    parent_span = tracer.get_span()
    http_header_carrier = {}

    opentracing.tracer.inject(
        span_context=parent_span,
        format=Format.HTTP_HEADERS,
        carrier=http_header_carrier)
    
    response = {
      "message": "Wrapped by Python",
      "response": ""
    }

    with opentracing.tracer.start_span('call'+ service + 'service', child_of=parent_span) as span:
      try:
        span.log_kv({"url": url})
        span.set_tag("http.url", url)
        span.set_tag("http.method", "GET")
        r = requests.get(url, headers=http_header_carrier)
        span.log_event("response receiving")
        span.set_tag("http.status_code", r.status_code)     
        response['response'] = r.text  
      except Exception as ex:
        span.set_tag("ERROR", True)
        response['response'] = "Unable to talk to service " + service
        span.log_event("")
    
    return jsonify(response)

@app.route('/')
def root():
    parent_span = tracer.get_span()
    sleepTimer = randint(0, 1000)
    requestTimer = randint(0, 4)

    with opentracing.tracer.start_span('sleep', child_of=parent_span) as sleepSpan:
        try:
            if sleepTimer > 900:
                raise Exception("I cant wait that long!")
            time.sleep(sleepTimer / 1000)
        except Exception as e:
            sleepSpan.set_tag("ERROR", True)
            sleepSpan.log_event("")

        with opentracing.tracer.start_span('httpbin request', child_of=sleepSpan) as requestSpan:
            url = "https://httpbin.org/delay/{:d}".format(requestTimer)
            requestSpan.log_kv({"url": url})
            requestSpan.set_tag("http.url", url)
            requestSpan.set_tag("http.method", "GET")
            r = requests.get(url)
            requestSpan.log_event("response receiving")
            requestSpan.set_tag("http.status_code", r.status_code)

    response = {
      "message": "Hello from Python!",
      "sleep": sleepTimer,
      "requestTime": requestTimer
    }

    with opentracing.tracer.start_span('parse request', child_of=parent_span) as responseSpan:
        return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)    
