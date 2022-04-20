using Dapper;
using Microsoft.Extensions.Configuration;
using PeliculasApp.Core.DTOs;
using PeliculasApp.Core.Infrastructure;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace PeliculasApp.Services
{
    public class UsuarioService : IUsuarioService
    {
        private readonly IConfiguration _configuration;
        public UsuarioService(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public async Task CrearUsuario(UsuarioDto usuario)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("Default"));

            await connection.ExecuteAsync("Crear_Usuario",
                    new
                    {
                        txt_user = usuario.Txt,
                        txt_password = usuario.Password, 
                        txt_nombre = usuario.Nombre, 
                        txt_apellido = usuario.Apellido,
                        nro_doc = usuario.Dni,
                        cod_rol = usuario.CodigoRol,
                        sn_activo = 1
                    }, commandType: System.Data.CommandType.StoredProcedure);
        }

        public async Task<UsuarioDto> Logear(LoginDto loginData)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("Default"));

            var users = await connection.QueryAsync<UsuarioDto>(@"SELECT
	                            t.cod_usuario AS Codigo,
	                            t.txt_user AS Txt,
	                            t.cod_rol AS CodigoRol,
	                            t.txt_nombre AS Nombre,
	                            t.txt_apellido AS Apellido,
	                            t.sn_activo AS SnActivo,
	                            t.nro_doc AS Dni,
	                            r.txt_pagina AS PaginaInicial
                            FROM tUsers t INNER JOIN tRol r ON r.cod_rol = t.cod_rol WHERE t.txt_user = @txt AND t.txt_password = @pw", new { txt = loginData.Name, pw = loginData.Password });
            return users?.FirstOrDefault();
        }

        public async Task ModificarUsuario(UsuarioDto usuario)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("Default"));

            await connection.ExecuteAsync("Modificar_usuario",
                    new
                    {
                        cod_usuario = usuario.Codigo,
                        txt_user = usuario.Txt,
                        txt_password = usuario.Password,
                        txt_nombre = usuario.Nombre,
                        txt_apellido = usuario.Apellido,
                        nro_doc = usuario.Dni,
                        cod_rol = usuario.CodigoRol,
                        sn_activo = usuario.SnActivo
                    }, commandType: System.Data.CommandType.StoredProcedure);
        }

        public async Task<List<UsuarioDto>> ObtenerUsuarios()
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("Default"));

            var users = await connection.QueryAsync<UsuarioDto>(@"SELECT
	                            t.cod_usuario AS Codigo,
	                            t.txt_user AS Txt,
	                            t.cod_rol AS CodigoRol,
	                            t.txt_nombre AS Nombre,
	                            t.txt_apellido AS Apellido,
	                            t.sn_activo AS SnActivo,
	                            t.nro_doc AS Dni
                            FROM tUsers t");

            return users.ToList();
        }
    }
}
