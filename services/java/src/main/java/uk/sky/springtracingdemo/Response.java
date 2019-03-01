package uk.sky.springtracingdemo;

public class Response {

  private final String message;
  private final int sleep;
  private final int requestTime;

  public Response(int sleep, int requestTime) {
    this.message = "Hello from java";
    this.sleep = sleep;
    this.requestTime = requestTime;
  }

  public int getrequestTime() {
    return requestTime;
  }

  public int getsleep() {
    return sleep;
  }

  public String getMessage() {
    return message;
  }
}
