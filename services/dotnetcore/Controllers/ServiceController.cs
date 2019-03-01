using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNetCore.Mvc;
using OpenTracing;
using OpenTracing.Tag;
using Flurl.Http;
using dotnetcore.Models;

namespace dotnetcore.Controllers
{
  [Route("/{service}")]
  public class ServiceController : Controller
  {
    private ITracer trace;

    public ServiceController(ITracer tracer)
    {
      this.trace = tracer;
    }

    [HttpGet]
    public async Task<dynamic> Get(string service)
    {
      var response = new WrappedResponse();

      using (IScope scope = trace.BuildSpan($"Call{service}Service").StartActive(finishSpanOnDispose: true))
      {
        dynamic result;
        try
        {
          result = await $"http://{service}/".GetAsync();
          response.response = await result.Content.ReadAsStringAsync();
        }
        catch (Exception ex)
        {
          Tags.Error.Set(scope.Span, true);
          scope.Span.Log(ex.Message);          
          response.response = $"Unable to talk to service {service}";
        }

        return response;
      }
    }
  }
}
