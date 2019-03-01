namespace dotnetcore.Models
{
  public class Response
  {
    public string message { get; } = "Hello from dotnetcore";

    public int sleep { get; set; }

    public int requestTime { get; set; }
  }
}
