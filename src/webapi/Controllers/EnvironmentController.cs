using Microsoft.AspNetCore.Mvc;
using System;
using System.Reflection;


namespace webapi.Controllers
{
    [Route("[controller]")]
    public class EnvironmentController : Controller
    {
        [HttpGet]
        public IActionResult Get()
        {
            var envInfo = new Models.Environment(
                Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyFileVersionAttribute>().Version,
                Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyInformationalVersionAttribute>().InformationalVersion,
                Environment.MachineName,
                DateTime.Now.ToUniversalTime());

            return base.Ok(envInfo);
        }
    }
}
