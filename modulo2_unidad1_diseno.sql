CREATE TABLE clientes(
id_cliente int NOT NULL IDENTITY(1,1) PRIMARY KEY,
nombre varchar(100) NOT NULL,
perfil_bio varchar(MAX) NOT NULL, 
fecha_registro datetime NOT NULL
);

CREATE TABLE productos(
id_producto int NOT NULL IDENTITY(1,1) PRIMARY KEY,
descripcion varchar(255) NOT NULL,
precio DECIMAL(10,2) NOT NULL, 
esta_activo varchar(2) NOT NULL
);
