create database tiendaMascotas;
use tiendaMascotas;

create table cliente(
idCliente varchar(50) primary key,
nombres varchar(100) not null,
apellidos varchar(100) not null,
direccion varchar(150) not null,
telefono varchar(20) not null
);

create table mascota(
idMascota varchar(50) primary key,
nombreMascota varchar(100) not null,
tipo varchar(50) not null,
genero varchar(20) not null,
raza varchar(50) not null,
idClienteFK varchar(50)
);

alter table mascota
add constraint fk_mascota_cliente
foreign key (idClienteFK)
references cliente(idCliente);


create table producto(
codigoBarras varchar(50) primary key,
nombreProducto varchar(100) not null,
marca varchar(100) not null,
precio decimal(10,2) not null
);


create table ventaProducto(
idVentaProducto varchar(50) primary key,
idClienteFK varchar(50),
codigoBarrasFK varchar(50)
);

alter table ventaProducto
add constraint fk_ventaProducto_cliente
foreign key (idClienteFK)
references cliente(idCliente);

alter table ventaProducto
add constraint fk_ventaProducto_producto
foreign key (codigoBarrasFK)
references producto(codigoBarras);


create table vacuna(
codigoVacuna varchar(50) primary key,
nombreVacuna varchar(100) not null,
dosis varchar(100) not null,
enfermedad varchar(150) not null
);


create table aplicacionVacuna(
idAplicacion varchar(50) primary key,
idMascotaFK varchar(50),
codigoVacunaFK varchar(50)
);

alter table aplicacionVacuna
add constraint fk_aplicacionVacuna_mascota
foreign key (idMascotaFK)
references mascota(idMascota);
alter table aplicacionVacuna
add constraint fk_aplicacionVacuna_vacuna
foreign key (codigoVacunaFK)
references vacuna(codigoVacuna);

