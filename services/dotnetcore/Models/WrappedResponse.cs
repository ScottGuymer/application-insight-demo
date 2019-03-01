namespace dotnetcore.Models
{
  public class WrappedResponse
  {
    public string message { get; } = "Wrapped by dotnetcore";

    public string response { get; set; }
  }
}
