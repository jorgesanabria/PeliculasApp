using System;
using System.Collections.Generic;
using System.Text;

namespace PeliculasApp.Core.DTOs
{
    public class UsuarioDto
    {
        public int Codigo { get; set; }
        public string Txt { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Dni { get; set; }
        public string Password { get; set; }
        public int CodigoRol { get; set; }
        public string PaginaInicial { get; set; }
        public int SnActivo { get; set; }
    }
}
