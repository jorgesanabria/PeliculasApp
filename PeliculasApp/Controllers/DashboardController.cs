using Microsoft.AspNetCore.Mvc;
using PeliculasApp.Core.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PeliculasApp.Controllers
{
    public class DashboardController : Controller
    {
        private readonly IUsuarioService _usuarioService;
        public DashboardController(IUsuarioService usuarioService)
        {
            _usuarioService = usuarioService;
        }
        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Panel()
        {

            return View()
        }
    }
}
