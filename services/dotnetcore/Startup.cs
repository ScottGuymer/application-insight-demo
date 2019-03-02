using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Jaeger;
using OpenTracing;
using OpenTracing.Util;
using System.Collections;
using Prometheus;

namespace dotnetcore
{
    public class Startup
    {
        public Startup(IConfiguration configuration, ILoggerFactory loggerFactory)
        {
            Configuration = configuration;
            this.loggerFactory = loggerFactory;
        }

        public IConfiguration Configuration { get; }
        private ILoggerFactory loggerFactory;

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
           
           services.AddSingleton<ITracer>(serviceProvider =>
            {
                var configuration = Jaeger.Configuration.FromEnv(loggerFactory);
                
                // This will log to a default localhost installation of Jaeger.
                var tracer = configuration.GetTracerBuilder().Build();

                // Allows code that can't use DI to also access the tracer.
                GlobalTracer.Register(tracer);

                return tracer;
            });

            services.AddMvc();
            services.AddOpenTracing();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseMetricServer();
            app.UseHttpMetrics();
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseMvc();
        }
    }
}
