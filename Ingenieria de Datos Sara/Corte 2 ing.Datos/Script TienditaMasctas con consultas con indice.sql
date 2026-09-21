-- =========================================================
-- BASE DE DATOS TIENDA DE MASCOTAS
-- =========================================================

-- Crear base de datos
create database if not exists tiendaMascotas;
use tiendaMascotas;


-- =========================================================
-- 1. CREACIÓN DE TABLAS
-- =========================================================

-- Tabla CLIENTE
create table cliente(
    idCliente varchar(50) primary key,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    direccion varchar(150) not null,
    telefono varchar(20) not null
);


-- Tabla MASCOTA
create table mascota(
    idMascota varchar(50) primary key,
    nombreMascota varchar(100) not null,
    tipo varchar(50) not null,
    genero varchar(20) not null,
    raza varchar(50) not null,
    idClienteFK varchar(50)
);


-- Relación MASCOTA - CLIENTE
alter table mascota
add constraint fk_mascota_cliente
foreign key (idClienteFK)
references cliente(idCliente);


-- Tabla PRODUCTO
create table producto(
    codigoBarras varchar(50) primary key,
    nombreProducto varchar(100) not null,
    marca varchar(100) not null,
    precio decimal(10,2) not null
);


-- Tabla VENTA PRODUCTO
-- AUTO_INCREMENT agregado para practicar DML
create table ventaProducto(
    idVentaProducto int auto_increment primary key,
    idClienteFK varchar(50),
    codigoBarrasFK varchar(50)
);


-- Relación VENTA PRODUCTO - CLIENTE
alter table ventaProducto
add constraint fk_ventaProducto_cliente
foreign key (idClienteFK)
references cliente(idCliente);


-- Relación VENTA PRODUCTO - PRODUCTO
alter table ventaProducto
add constraint fk_ventaProducto_producto
foreign key (codigoBarrasFK)
references producto(codigoBarras);


-- Tabla VACUNA
create table vacuna(
    codigoVacuna varchar(50) primary key,
    nombreVacuna varchar(100) not null,
    dosis varchar(100) not null,
    enfermedad varchar(150) not null
);


-- Tabla APLICACIÓN VACUNA
create table aplicacionVacuna(
    idAplicacion varchar(50) primary key,
    idMascotaFK varchar(50),
    codigoVacunaFK varchar(50)
);


-- Relación APLICACION VACUNA - MASCOTA
alter table aplicacionVacuna
add constraint fk_aplicacionVacuna_mascota
foreign key (idMascotaFK)
references mascota(idMascota);


-- Relación APLICACION VACUNA - VACUNA
alter table aplicacionVacuna
add constraint fk_aplicacionVacuna_vacuna
foreign key (codigoVacunaFK)
references vacuna(codigoVacuna);


-- =========================================================
-- 2. CONSULTAS GENERALES
-- =========================================================

select * from cliente;

select * from mascota;

select * from producto;

select * from ventaProducto;

select * from vacuna;

select * from aplicacionVacuna;


-- =========================================================
-- 3. INSERTAR CLIENTES
-- =========================================================

insert into cliente
(idCliente, nombres, apellidos, direccion, telefono)
values
('C001','Sara','Ferro','Calle 10 # 20-30','3001111111'),
('C002','Valentina','Gomez','Carrera 15 # 25-40','3002222222'),
('C003','Juan','Cortes','Calle 50 # 10-20','3003333333'),
('C004','Laura','Martinez','Carrera 7 # 80-15','3004444444'),
('C005','Andres','Villarreal','Calle 30 # 12-25','3005555555'),
('C006','Camila','Rodriguez','Carrera 20 # 40-10','3006666666'),
('C007','Daniel','Perez','Calle 70 # 15-20','3007777777'),
('C008','Sofia','Torres','Carrera 50 # 60-30','3008888888'),
('C009','Mateo','Ramirez','Calle 90 # 20-10','3009999999'),
('C010','Paula','Castro','Carrera 30 # 50-15','3010000000');

select * from cliente;


-- =========================================================
-- 4. INSERTAR MASCOTAS
-- =========================================================

insert into mascota
(idMascota,nombreMascota,tipo,genero,raza,idClienteFK)
values
('M001','Max','Perro','Macho','Golden Retriever','C001'),
('M002','Luna','Gato','Hembra','Persa','C002'),
('M003','Rocky','Perro','Macho','Bulldog','C003'),
('M004','Nala','Gato','Hembra','Siamés','C004'),
('M005','Coco','Perro','Macho','Poodle','C005'),
('M006','Mia','Perro','Hembra','Beagle','C006'),
('M007','Thor','Perro','Macho','Pastor Alemán','C007'),
('M008','Simba','Gato','Macho','Maine Coon','C008'),
('M009','Kira','Perro','Hembra','Labrador','C009'),
('M010','Milo','Gato','Macho','Angora','C010');

select * from mascota;


-- =========================================================
-- 5. INSERTAR PRODUCTOS
-- =========================================================

insert into producto
(codigoBarras,nombreProducto,marca,precio)
values
('P001','Concentrado para perro','Dog Chow',45000.00),
('P002','Concentrado para gato','Cat Chow',38000.00),
('P003','Arena para gato','Arena Plus',25000.00),
('P004','Juguete para perro','PetFun',18000.00),
('P005','Juguete para gato','CatToy',15000.00),
('P006','Shampoo para perro','PetClean',22000.00),
('P007','Collar para perro','PetStyle',12000.00),
('P008','Correa para perro','PetWalk',30000.00),
('P009','Cama para mascota','PetHome',85000.00),
('P010','Comedero','PetFood',20000.00);

select * from producto;


-- =========================================================
-- 6. INSERTAR VENTAS
-- =========================================================

-- No se coloca idVentaProducto porque es AUTO_INCREMENT

insert into ventaProducto
(idClienteFK,codigoBarrasFK)
values
('C001','P001'),
('C002','P002'),
('C003','P003'),
('C004','P004'),
('C005','P005'),
('C006','P006'),
('C007','P007'),
('C008','P008'),
('C009','P009'),
('C010','P010');

select * from ventaProducto;


-- =========================================================
-- 7. INSERTAR VACUNAS
-- =========================================================

insert into vacuna
(codigoVacuna,nombreVacuna,dosis,enfermedad)
values
('V001','Rabia','1 ml','Rabia'),
('V002','Parvovirus','1 ml','Parvovirosis'),
('V003','Moquillo','1 ml','Moquillo canino'),
('V004','Hepatitis','1 ml','Hepatitis infecciosa'),
('V005','Leucemia Felina','1 ml','Leucemia felina'),
('V006','Triple Felina','1 ml','Enfermedades respiratorias'),
('V007','Bordetella','0.5 ml','Tos de las perreras'),
('V008','Coronavirus Canino','1 ml','Coronavirus'),
('V009','Leptospira','1 ml','Leptospirosis'),
('V010','Giardia','1 ml','Giardiasis');

select * from vacuna;


-- =========================================================
-- 8. INSERTAR APLICACIONES DE VACUNAS
-- =========================================================

insert into aplicacionVacuna
(idAplicacion,idMascotaFK,codigoVacunaFK)
values
('A001','M001','V001'),
('A002','M002','V005'),
('A003','M003','V002'),
('A004','M004','V006'),
('A005','M005','V003'),
('A006','M006','V001'),
('A007','M007','V009'),
('A008','M008','V005'),
('A009','M009','V007'),
('A010','M010','V006');

select * from aplicacionVacuna;

-- consultas--

select *
from producto
where precio > 30000;

select nombreProducto, precio
from producto
order by precio desc;

select nombreProducto, precio
from producto
order by precio desc;

select nombreProducto, precio
from producto
where precio between 20000 and 50000;

select *
from producto
where nombreProducto like '%perro%';

select count(*) as cantidadProductos
from producto;

select avg(precio) as precioPromedio
from producto;

select
max(precio) as precioMaximo,
min(precio) as precioMinimo
from producto;

select sum(precio) as sumaPrecios
from producto;

select
c.nombres,
c.apellidos,
p.nombreProducto,
p.marca,
p.precio
from ventaProducto v
inner join cliente c
on v.idClienteFK = c.idCliente
inner join producto p
on v.codigoBarrasFK = p.codigoBarras;

select
c.nombres,
c.apellidos,
m.nombreMascota,
m.tipo,
m.raza
from mascota m
inner join cliente c
on m.idClienteFK = c.idCliente;

-- INDICES

CREATE INDEX idx_cliente_nombre
ON cliente(nombres, apellidos);

CREATE INDEX idx_mascota_tipo_raza
ON mascota(tipo, raza);

CREATE INDEX idx_producto_precio
ON producto(precio);