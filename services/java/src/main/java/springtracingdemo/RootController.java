package springtracingdemo;

import java.net.*;

import io.opentracing.Scope;
import io.opentracing.tag.Tags;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.ThreadLocalRandom;

@RestController
public class RootController {

  @Autowired
  private io.opentracing.Tracer tracer;

  @RequestMapping("/")
  public Response get() throws Exception {

    int sleepTime = ThreadLocalRandom.current().nextInt(0, 1000);
    int requestTime = ThreadLocalRandom.current().nextInt(0, 4);

    try (Scope sleepSpan = tracer.buildSpan("sleep").startActive(true)) {
      try {
        if (sleepTime > 900) {
          throw new Exception("I cant wait that long!");
        }
        Thread.sleep(sleepTime);
      } catch (Exception e) {
        Tags.ERROR.set(sleepSpan.span(), true);
        sleepSpan.span().log(e.getMessage());
      }

      try (Scope requestSpan = tracer.buildSpan("httpbinrequest").startActive(true)) {
        URL url = new URL("http://httpbin.org/delay/" + requestTime);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
      }
    }
    
    try (Scope scope = tracer.buildSpan("sendresponse").startActive(true)) {
      return new Response(sleepTime, requestTime);
    }
  }
}
