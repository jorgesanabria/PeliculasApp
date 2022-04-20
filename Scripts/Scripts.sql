CREATE DATABASE TestCrud
GO

USE TestCrud
GO

CREATE TABLE tRol
(
	cod_rol INT IDENTITY PRIMARY KEY,
	txt_desc VARCHAR(500),
	sn_activo INT,
	txt_pagina VARCHAR(250)
)
GO
SET IDENTITY_INSERT tRol  ON
GO
INSERT INTO tRol (cod_rol, txt_desc, sn_activo, txt_pagina) VALUES ( 1, 'Administrador',1, 'Dashboard/Panel')
INSERT INTO tRol (cod_rol, txt_desc, sn_activo, txt_pagina) VALUES ( 2, 'Cliente', 1, 'Dashboard/Index')
GO
SET IDENTITY_INSERT tRol OFF
GO

CREATE TABLE tUsers
(
	cod_usuario INT PRIMARY KEY IDENTITY,
	txt_user VARCHAR(50),
	txt_password VARCHAR(50),
	txt_nombre VARCHAR(200),
	txt_apellido VARCHAR(200),
	nro_doc VARCHAR(50),
	cod_rol INT,
	sn_activo INT,
	CONSTRAINT fk_user_rol FOREIGN KEY (cod_rol) REFERENCES tRol(cod_rol)
)
GO
SET IDENTITY_INSERT tUsers  ON
GO
INSERT INTO tUsers (cod_usuario, txt_user, txt_password, txt_nombre, txt_apellido, nro_doc, cod_rol, sn_activo)
			VALUES ( 1, 'Admin', 'PassAdmin123', 'Administrador', 'Test', '1234321', 1,1)
INSERT INTO tUsers (cod_usuario, txt_user, txt_password, txt_nombre, txt_apellido, nro_doc, cod_rol, sn_activo)
			VALUES (2, 'userTest', 'Test1', 'Ariel', 'ApellidoConA', '12312321', 2, 1)
INSERT INTO tUsers (cod_usuario, txt_user, txt_password, txt_nombre, txt_apellido, nro_doc, cod_rol, sn_activo)
			VALUES (3, 'userTest2', 'Test2', 'Bernardo', 'ApellidoConB', '12312322', 2, 1)
INSERT INTO tUsers (cod_usuario, txt_user, txt_password, txt_nombre, txt_apellido, nro_doc, cod_rol, sn_activo)
			VALUES (4, 'userTest3', 'Test3', 'Carlos', 'ApellidoConC', '12312323', 2, 1)
GO
SET IDENTITY_INSERT tUsers  OFF
GO

CREATE TABLE tPelicula
(
	cod_pelicula INT PRIMARY KEY IDENTITY,
	txt_desc VARCHAR(500),
	cant_disponibles_alquiler INT,
	cant_disponibles_venta INT,
	precio_alquiler NUMERIC(18,2),
	precio_venta NUMERIC(18,2)
)
GO
SET IDENTITY_INSERT tPelicula  ON
GO
INSERT INTO tPelicula (cod_pelicula, txt_desc, cant_disponibles_alquiler, cant_disponibles_venta, precio_alquiler, precio_venta)
			   VALUES (1, 'Duro de matar III', 3, 0,1.5,5.0)
INSERT INTO tPelicula (cod_pelicula, txt_desc, cant_disponibles_alquiler, cant_disponibles_venta, precio_alquiler, precio_venta)
			   VALUES (2, 'Todo Poderoso', 2,1,1.5,7.0)
INSERT INTO tPelicula (cod_pelicula, txt_desc, cant_disponibles_alquiler, cant_disponibles_venta, precio_alquiler, precio_venta)
			   VALUES (3, 'Stranger than fiction', 1,1,1.5,8.0)
INSERT INTO tPelicula (cod_pelicula, txt_desc, cant_disponibles_alquiler, cant_disponibles_venta, precio_alquiler, precio_venta)
			   VALUES (4, 'OUIJA', 0,2,2.0,20.50)
GO
SET IDENTITY_INSERT tPelicula  OFF
GO
CREATE TABLE tGenero
(
	cod_genero INT PRIMARY KEY IDENTITY,
	txt_desc VARCHAR(500)
)
SET IDENTITY_INSERT tGenero  ON
GO
INSERT INTO tGenero (cod_genero, txt_desc) VALUES(1, 'Acción')
INSERT INTO tGenero (cod_genero, txt_desc) VALUES(2, 'Comedia')
INSERT INTO tGenero (cod_genero, txt_desc) VALUES(3, 'Drama')
INSERT INTO tGenero (cod_genero, txt_desc) VALUES(4, 'Terror')
GO
SET IDENTITY_INSERT tGenero  OFF
GO
CREATE TABLE tGeneroPelicula
(
	cod_pelicula INT,
	cod_genero INT,
	PRIMARY KEY(cod_pelicula, cod_genero),
	CONSTRAINT fk_genero_pelicula FOREIGN KEY(cod_pelicula) REFERENCES tpelicula(cod_pelicula),
	CONSTRAINT fk_pelicula_genero FOREIGN KEY(cod_genero) REFERENCES tGenero(cod_genero)
)
GO
SET IDENTITY_INSERT tGeneroPelicula  ON
GO
INSERT INTO tGeneroPelicula VALUES(1,1)
INSERT INTO tGeneroPelicula VALUES(2,2)
INSERT INTO tGeneroPelicula VALUES(3,2)
INSERT INTO tGeneroPelicula VALUES(3,3)
INSERT INTO tGeneroPelicula VALUES(4,4)
GO
SET IDENTITY_INSERT tGeneroPelicula  OFF
GO


CREATE TABLE tUsuario_Pelicula
(
	cod_usuario INT NOT NULL,
	cod_pelicula INT NOT NULL,
	precio_operacion NUMERIC(18,2),
	tipo_operacion BIT,
	fecha DATETIME,
	PRIMARY KEY (cod_usuario, cod_pelicula),
	CONSTRAINT fk_usuario_pelicula_pelicula FOREIGN KEY(cod_pelicula) REFERENCES tpelicula(cod_pelicula),
	CONSTRAINT fk_usuario_pelicula_usuario FOREIGN KEY(cod_usuario) REFERENCES tUsers(cod_usuario)
)
GO

ALTER TABLE tUsuario_Pelicula ADD devuelta BIT NULL
GO



CREATE PROCEDURE Crear_Usuario @txt_user VARCHAR(50), @txt_password VARCHAR(50), @txt_nombre VARCHAR(200), @txt_apellido VARCHAR(200), @nro_doc VARCHAR(50), @cod_rol INT, @sn_activo INT
AS
	IF EXISTS (SELECT 1 FROM tUsers t WHERE t.nro_doc = @nro_doc)
	BEGIN
		RAISERROR (15600,-1,-1, 'Ya hay un usuario registrado con el numero de documento proporcionado');
	END

	INSERT INTO tUsers	(txt_user, txt_password, txt_nombre, txt_apellido, nro_doc, cod_rol, sn_activo)
				 VALUES (@txt_user, @txt_password, @txt_nombre, @txt_apellido, @nro_doc, @cod_rol, @sn_activo)
GO

CREATE PROCEDURE Modificar_usuario @cod_usuario INT, @txt_user VARCHAR(50), @txt_password VARCHAR(50), @txt_nombre VARCHAR(200), @txt_apellido VARCHAR(200), @nro_doc VARCHAR(50), @cod_rol INT, @sn_activo INT
AS
	UPDATE tUsers SET
		txt_user = @txt_user,
		txt_password = @txt_password,
		txt_nombre = @txt_nombre,
		txt_apellido = @txt_apellido,
		nro_doc = @nro_doc,
		cod_rol = @cod_rol,
		sn_activo = @sn_activo
	WHERE cod_usuario = @cod_usuario
GO

CREATE PROCEDURE Crear_Pelicula @txt_desc VARCHAR(500), @cant_disponibles_alquiler INT, @cant_disponibles_venta INT, @precio_alquiler NUMERIC(18,2), @precio_venta NUMERIC(18,2)
AS
	INSERT INTO tPelicula VALUES (@txt_desc, @cant_disponibles_alquiler, @cant_disponibles_venta, @precio_alquiler, @precio_venta)
GO

CREATE PROCEDURE Modificar_Pelicula @cod_pelicula INT, @txt_desc VARCHAR(500), @cant_disponibles_alquiler INT, @cant_disponibles_venta INT, @precio_venta NUMERIC(18,2)
AS
	UPDATE tPelicula SET txt_desc = @txt_desc, cant_disponibles_alquiler = @cant_disponibles_alquiler, cant_disponibles_venta = @cant_disponibles_venta, precio_venta = @precio_venta
					 WHERE cod_pelicula = @cod_pelicula
GO

CREATE PROCEDURE Borrar_Pelicula @cod_pelicula INT
AS
	UPDATE tPelicula SET cant_disponibles_alquiler = 0, cant_disponibles_venta = 0 WHERE cod_pelicula = @cod_pelicula
GO

CREATE PROCEDURE Crear_Genero @txt_desc VARCHAR(500)
AS
	IF EXISTS (SELECT 1 FROM tGenero t WHERE t.txt_desc = @txt_desc)
	BEGIN
		RAISERROR (15600,-1,-1, 'El genero ya existe');
	END

	INSERT INTO tGenero VALUES (@txt_desc)
GO

CREATE PROCEDURE Asignar_Genero @cod_pelicula INT, @cod_genero INT
AS
	IF EXISTS (SELECT 1 FROM tGeneroPelicula t WHERE t.cod_genero = @cod_genero AND t.cod_pelicula = @cod_genero)
	BEGIN
		RAISERROR (15600,-1,-1, 'La pelicula ya tiene asignado el genero proporcionado');
	END

	INSERT INTO tGeneroPelicula (cod_genero, cod_pelicula) VALUES (@cod_genero, @cod_pelicula)
GO

CREATE PROCEDURE Alquilar_Pelicula @cod_pelicula INT, @cod_usuario INT
AS
	IF EXISTS (SELECT 1 FROM tUsuario_Pelicula t WHERE t.cod_pelicula = @cod_pelicula AND t.cod_usuario = @cod_usuario)
	BEGIN
		RAISERROR (15600,-1,-1, 'La pelicula ya está alquilada por el usuario proporcionado');
	END

	IF EXISTS (SELECT 1 FROM tPelicula t WHERE t.cant_disponibles_alquiler = 0 AND t.cod_pelicula = @cod_pelicula)
	BEGIN
		RAISERROR (15600,-1,-1, 'La pelicula no está disponible para alquilar');
	END

	INSERT INTO tUsuario_Pelicula (cod_pelicula, cod_usuario, fecha, tipo_operacion, precio_operacion)
		SELECT
			@cod_pelicula,
			@cod_usuario,
			GETDATE(),
			1,-- 1: alquiler; 0: venta
			t.precio_alquiler
		FROM
			tPelicula t WHERE t.cod_pelicula = @cod_pelicula

	UPDATE tPelicula SET cant_disponibles_alquiler = cant_disponibles_alquiler - 1 WHERE cod_pelicula = @cod_pelicula
GO


CREATE PROCEDURE Vender_Pelicula @cod_pelicula INT, @cod_usuario INT
AS
	IF EXISTS (SELECT 1 FROM tPelicula t WHERE t.cant_disponibles_venta = 0 AND t.cod_pelicula = @cod_pelicula)
	BEGIN
		RAISERROR (15600,-1,-1, 'La pelicula no está disponible para vender');
	END

	INSERT INTO tUsuario_Pelicula (cod_pelicula, cod_usuario, fecha, tipo_operacion, precio_operacion)
		SELECT
			@cod_pelicula,
			@cod_usuario,
			GETDATE(),
			0,-- 1: alquiler; 0: venta
			t.precio_venta
		FROM
			tPelicula t WHERE t.cod_pelicula = @cod_pelicula

	UPDATE tPelicula SET cant_disponibles_venta = cant_disponibles_venta - 1 WHERE cod_pelicula = @cod_pelicula
GO


CREATE PROCEDURE Obtener_Pelicula @cod_pelicula INT
AS

	SELECT 
		t.cod_pelicula AS Codigo,
		t.cant_disponibles_alquiler AS CantidadDisponibleAlquiler,
		t.cant_disponibles_venta AS CantidadDisponibleVenta,
		t.precio_alquiler AS PrecioALquiler,
		t.precio_venta AS PrecioVenta,
		t.txt_desc AS Descripcion
	FROM tPelicula t WHERE t.cod_pelicula = @cod_pelicula
GO

CREATE PROCEDURE Obtener_Peliculas_sin_devolver
AS
	SELECT
		tp.cod_pelicula AS CodigoPelicula,
		u.cod_usuario AS CodigoUsuario,
		p.cod_pelicula AS CodigoPelicula,
		u.nro_doc AS NumeroDocumentoUsuario,
		u.txt_nombre AS NombreUsuario,
		p.txt_desc AS DescripcionPelicula
	FROM tUsuario_Pelicula tp
	INNER JOIN tUsers u ON tp.cod_usuario = u.cod_usuario
	INNER JOIN tPelicula p ON tp.cod_pelicula = p.cod_pelicula
	WHERE tp.devuelta IS NULL AND tp.tipo_operacion = 1
GO

CREATE PROCEDURE Devolver_pelicula @cod_pelicula INT, @cod_usuario INT
AS
	UPDATE tUsuario_Pelicula SET devuelta = 1 WHERE cod_pelicula = @cod_pelicula AND cod_usuario = @cod_usuario
GO

CREATE PROCEDURE Obtener_alquiler_usuario @cod_usuario INT
AS
	SELECT
		tp.cod_pelicula AS CodigoPelicula,
		tp.cod_usuario AS CodigoUsuario,
		tp.precio_operacion AS CuantoPago,
		tp.fecha AS Fecha,
		u.txt_nombre AS NombreUsuario,
		u.nro_doc AS NumeroDocumentoUsuario,
		p.txt_desc AS DescripcionPelicula
	FROM tUsuario_Pelicula tp
	INNER JOIN tUsers u ON tp.cod_usuario = tp.cod_usuario
	INNER JOIN tPelicula p ON p.cod_pelicula = tp.cod_pelicula
	WHERE tp.cod_usuario = @cod_usuario AND tp.tipo_operacion = 1
GO

CREATE PROCEDURE Obtener_reporte_alquileres
AS
	
	SELECT 
		r.CodigoPelicula,
		p.txt_desc AS Descripcion,
		r.CantidadVecesAlquilada,
		r.Recaudacion
	FROM tPelicula p
	INNER JOIN
	(SELECT
		tp.cod_pelicula AS CodigoPelicula,
		SUM (tp.precio_operacion) AS Recaudacion,
		COUNT(1) AS CantidadVecesAlquilada
	FROM tUsuario_Pelicula tp
	GROUP BY tp.cod_pelicula
	) r ON r.CodigoPelicula = p.cod_pelicula
GO