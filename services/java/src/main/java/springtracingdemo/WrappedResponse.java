package springtracingdemo;

public class WrappedResponse {

  private final String message;
  private String response;

  public WrappedResponse() {
    this.message = "Wrapped by java";
  }

  public String getMessage() {
    return message;
  }

  public String getResponse() {
    return response;
  }

  public void setResponse(String response) {
    this.response = response;
  }
}
