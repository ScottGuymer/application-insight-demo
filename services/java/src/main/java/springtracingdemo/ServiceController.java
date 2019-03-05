package springtracingdemo;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.*;
import java.util.concurrent.atomic.AtomicLong;

import io.opentracing.Scope;
import io.opentracing.Span;
import io.opentracing.propagation.Format;
import io.opentracing.propagation.TextMapInjectAdapter;
import io.opentracing.tag.Tags;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@RestController
public class ServiceController {

  private static final String template = "Hello, %s!";
  private final AtomicLong counter = new AtomicLong();

  @Autowired
  private io.opentracing.Tracer tracer;

  private @Autowired HttpServletRequest request;

  @RequestMapping("/{service}")
  public WrappedResponse get(@PathVariable("service") String service) {

    WrappedResponse response = new WrappedResponse();

    try (Scope scope = tracer.buildSpan("call" + service + "service").startActive(true)) {      
      try {
        response.setResponse(sendGet(String.format("http://%s/", service)));
      } catch (Exception e) {
        Tags.ERROR.set(scope.span(), true);
        scope.span().log(e.getMessage());          
        response.setResponse("Unable to talk to service " + service);
      }
    }

    return response;
  }

  private String sendGet(String url) throws Exception {

    URL obj = new URL(url);
    
    Span span = tracer.activeSpan();
    
    Map<String, String> map = new HashMap<String, String>();
    
		tracer.inject(span.context(), Format.Builtin.HTTP_HEADERS, new TextMapInjectAdapter(map));

    HttpURLConnection con = (HttpURLConnection) obj.openConnection();

    map.forEach((key,value) -> con.setRequestProperty(key, value));
    
		con.setRequestMethod("GET");

		int responseCode = con.getResponseCode();

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
    in.close();
    
    return response.toString();
  }
}
