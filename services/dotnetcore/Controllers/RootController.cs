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
  [Route("")]
  public class RootController : Controller
  {
    private ITracer trace;

    public RootController(ITracer tracer)
    {
      this.trace = tracer;
    }
    // GET api/values
    [HttpGet]
    public async Task<Response> GetAsync()
    {
      Random r = new Random();
      var sleepTime = r.Next(0, 1000);
      var requestTime = r.Next(0, 4);

      using (IScope scope = trace.BuildSpan("sleep").StartActive(finishSpanOnDispose: true))
      {
        try
        {
          if (sleepTime > 900)
          {
            throw new ApplicationException("I cant wait that long!");
          }
          Thread.Sleep(sleepTime);
        }
        catch (Exception ex)
        {
          Tags.Error.Set(scope.Span, true);
          scope.Span.Log(ex.Message);
        }

        using (IScope scope2 = trace.BuildSpan("httpbinrequest").StartActive(finishSpanOnDispose: true))
        {
          await $"https://httpbin.org/delay/{requestTime}".GetAsync();
        }
      }

      using (IScope scope = trace.BuildSpan("sendresponse").StartActive(finishSpanOnDispose: true))
      {
        return new Response { sleep = sleepTime, requestTime = requestTime };
      }
    }
  }
}
