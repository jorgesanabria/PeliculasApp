using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using PeliculasApp.Core.DTOs;
using PeliculasApp.Core.Infrastructure;
using PeliculasApp.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace PeliculasApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly IUsuarioService _usuarioService;
        public HomeController(IUsuarioService usuarioService)
        {
            _usuarioService = usuarioService;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginDto loginData)
        {
            var result = await _usuarioService.Logear(loginData);

            if (result != null)
            {
                return Redirect(result.PaginaInicial);
            }
            else
            {
                ViewBag.Mensaje = "Usuario o password incorrecto";
                return Index();
            }
        }
    }
}
