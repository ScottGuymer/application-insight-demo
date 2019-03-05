package springtracingdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import io.jaegertracing.Configuration;

@SpringBootApplication
public class SpringtracingdemoApplication {


	@Bean
	public io.opentracing.Tracer jaegerTracer() {
    	Configuration config = Configuration.fromEnv();
    	return config.getTracer();
	}


	public static void main(String[] args) {
		SpringApplication.run(SpringtracingdemoApplication.class, args);
	}
}
