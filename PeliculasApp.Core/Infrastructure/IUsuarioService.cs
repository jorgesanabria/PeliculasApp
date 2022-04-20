using PeliculasApp.Core.DTOs;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace PeliculasApp.Core.Infrastructure
{
    public interface IUsuarioService
    {
        Task<List<UsuarioDto>> ObtenerUsuarios();
        Task CrearUsuario(UsuarioDto usuario);
        Task ModificarUsuario(UsuarioDto usuario);
        Task<UsuarioDto> Logear(LoginDto loginData);
    }
}
