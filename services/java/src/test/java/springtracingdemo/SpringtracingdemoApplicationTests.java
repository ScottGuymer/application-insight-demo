package springtracingdemo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class SpringtracingdemoApplicationTests {

  static {
    System.setProperty("JAEGER_SERVICE_NAME", "testing");
  }

	@Test
	public void contextLoads() {
	}

}
