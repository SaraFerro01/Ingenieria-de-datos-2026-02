drop database if exists dronAndes;
create database dronAndes;
use dronAndes;

create table bases(
id_base int primary key not null auto_increment,
nombre varchar(60) unique not null,
municipio varchar (60) not null,
departamento  varchar (40) not null,
capacidad_drones int not null,
constraint chk_bases_capacidad check (capacidad_drones > 0),
fecha_apertura date not null
);

create table tipo_cargas(
id_tipo int primary key not null auto_increment,
nombre varchar(40) not null unique,
tarifa_kg decimal(10,2) not null, 
constraint chk_tipos_carga_tarifa check (tarifa_kg > 0),
requiere_frio boolean not null default FALSE
);

create table drones (
id_dron int primary key not null auto_increment,
codigo_serie varchar(12) not null unique,
modelo varchar(40) not null,
carga_max_kg decimal (5,2) not null,
constraint chk_carga_max_kg check (carga_max_kg between 0.5 and 25),
autonomia_km decimal(5,1) not null,
constraint chk_drones_autonomia check (autonomia_km > 0),
estado varchar(15) not null  default 'ACTIVO',
constraint chk_drones_estado check (estado in ('ACTIVO','MANTENIMIENTO','RETIRADO')),
horas_vuelo decimal(7,1) not null default 0,
constraint chk_drones_horas check (horas_vuelo >= 0),
fecha_adquisicion date not null,
id_base int not null, -- r01 cada dron tiene una sola base, una base puede tener varios drones-- 
constraint fk_drones_id_base foreign key (id_base) references bases(id_base)
);

create table pilotos (
id_piloto int primary key not null auto_increment,
documento varchar(15) not null unique,
nombres varchar(50) not null,
apellidos varchar(50) not null,
email varchar(80) not null unique,
licencia char(1) not null,
constraint chk_pilotos_licencia check (licencia in ('A','B','C')),
fecha_ingreso date not null,
id_base int not null,
constraint fk_id_pilotos_base foreign key (id_base) references bases(id_base),
id_supervisor int null -- r02 null jefe de operacion no tiene supervisor, max un supervisor porpiloto--
);


create table clientes(
id_cliente int primary key not null auto_increment,
tipo varchar(12) not null check(tipo in( 'HOSPITAL', 'FARMACIA', 'COMERCIO', 'ONG', 'PERSONA')),
nombre varchar (80) not null,
nit_documento varchar(15) not null unique,
email varchar(80) unique,
telefono varchar(15),
municipio varchar(60) not null,
fecha_registro date not null default (current_date)
);

create table entregas(                  -- RN-04: cada entrega pertenece a un cliente, la hace un dron y la opera un piloto -- 
id_entrega int primary key not null auto_increment,
codigo varchar(10) not null unique,
id_cliente int not null,
id_dron int not null,
id_piloto int not null,
constraint fk_id_entregas_cliente foreign key (id_cliente) references clientes (id_cliente),
constraint fk_id_entregas_dron foreign key (id_dron) references drones (id_dron),
constraint fk_id_entregas_piloto foreign key (id_piloto) references pilotos(id_piloto),
fecha_programada datetime not null,
fecha_entrega datetime,
municipio_destino varchar(60) not null,
distancia_km decimal(5,1) not null,
constraint chk_entregas_distancia check (distancia_km > 0),
prioridad varchar(8) not null default 'NORMAL',
constraint chk_entregas_prioridad check (prioridad in ('NORMAL','URGENTE','VITAL')),
estado varchar(12) not null default 'PROGRAMADA',
 constraint chk_entregas_estado check (estado in ('PROGRAMADA','EN_VUELO','ENTREGADA','CANCELADA','FALLIDA')),
calificacion smallint null,
  constraint chk_entregas_calificacion check (calificacion between 1 and 5)
);

create table carga_entrega (
id_entrega int not null,
id_tipo int not null,
constraint fk_carga_entrega_id_entrega foreign key (id_entrega) references entregas(id_entrega),
constraint fk_carga_entrega_id_tipo foreign key (id_tipo) references tipo_cargas(id_tipo),
peso_kg decimal(6,2) not null check(peso_kg >0),
unidades int not null default 1 check(unidades > 0)
);

create table mantenimientos(
id_mantenimiento int primary key not null auto_increment,
id_dron int not null,
constraint fk_mantenimiento_id_dron foreign key (id_dron) references drones (id_dron),
fecha date not null,
tipo varchar(12) not null, check(tipo in('PREVENTIVO','CORRECTIVO')),
descripcion varchar(200),
costo decimal(10,2) not null check(costo>= 0)
);

create table historial_entregas (
id_historial int primary key not null auto_increment,
id_entrega int not null,
constraint fk_historial_entregas_id_entrega foreign key (id_entrega) references entregas(id_entrega),
estado_anterior varchar(12) not null,
estado_nuevo varchar(12) not null,
fecha_cambio datetime not null default current_timestamp
);

show tables;
describe entregas;

-- DATOS INICIALES 

-- =====================================================================
-- DATOS INICIALES — Proyecto Cóndor (DronAndes Express S.A.S.)
-- Corte: 30 de septiembre de 2026, 18:00
-- Script COMÚN para MySQL y PostgreSQL. Ejecutar DESPUÉS del DDL (R2).
-- =====================================================================
INSERT INTO bases (id_base, nombre, municipio, departamento, capacidad_drones,
fecha_apertura) VALUES
(1, 'Base Cóndor', 'Rionegro', 'Antioquia', 6, '2024-02-15'),
(2, 'Base Colibrí', 'Guatapé', 'Antioquia', 4, '2024-08-01'),
(3, 'Base Frailejón', 'Tunja', 'Boyacá', 5, '2025-01-20'),
(4, 'Base Guadua', 'Salento', 'Quindío', 3, '2026-07-01');
INSERT INTO tipo_cargas (id_tipo, nombre, tarifa_kg, requiere_frio) VALUES
(1, 'Vacunas', 12000, TRUE),
(2, 'Muestras de laboratorio', 10000, TRUE),
(3, 'Medicamentos', 8000, FALSE),
(4, 'Documentos', 5000, FALSE),
(5, 'Repuestos', 4500, FALSE),
(6, 'Alimentos', 3500, FALSE);
INSERT INTO drones (id_dron, codigo_serie, modelo, carga_max_kg, autonomia_km, estado,
horas_vuelo, fecha_adquisicion, id_base) VALUES
(1, 'DA-CX4-01', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 312.5, '2024-02-20', 1),
(2, 'DA-CX4-02', 'Cóndor X4', 8.00, 45.0, 'ACTIVO', 468.0, '2024-03-10', 1),
(3, 'DA-CX6-01', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 205.0, '2025-01-15', 1),
(4, 'DA-COL-01', 'Colibrí Mini', 2.50, 25.0, 'ACTIVO', 520.5, '2024-08-05', 2),
(5, 'DA-COL-02', 'Colibrí Mini', 2.50, 25.0, 'MANTENIMIENTO', 610.0, '2024-08-05', 2),
(6, 'DA-ALB-01', 'Albatros H8', 25.00, 90.0, 'ACTIVO', 98.0, '2025-02-01', 3),
(7, 'DA-CX6-02', 'Cóndor X6', 15.00, 60.0, 'ACTIVO', 150.5, '2025-03-12', 3),
(8, 'DA-ALB-02', 'Albatros H8', 25.00, 90.0, 'RETIRADO', 890.0, '2024-05-01', 3);
-- Los supervisores (id_supervisor NULL) se insertan primero.
INSERT INTO pilotos (id_piloto, documento, nombres, apellidos, email, licencia, fecha_ingreso,
id_supervisor, id_base) VALUES
(1, '1036600111', 'Laura', 'Restrepo Gil', 'laura.restrepo@dronandes.co', 'C', '2024-02-01', NULL,
1),
(2, '1049600222', 'Camilo', 'Duarte Rojas', 'camilo.duarte@dronandes.co', 'C', '2025-01-10', NULL,
3),
(3, '1036600333', 'Mateo', 'Zapata Vélez', 'mateo.zapata@dronandes.co', 'B', '2024-04-15', 1, 1),
(4, '1036600444', 'Sara', 'Montoya Ruiz', 'sara.montoya@dronandes.co', 'B', '2024-08-10', 1, 2),
(5, '1036600555', 'Julián', 'Patiño Cruz', 'julian.patino@dronandes.co', 'A', '2025-06-01', 1, 2),
(6, '1049600666', 'Daniela', 'Suárez León', 'daniela.suarez@dronandes.co', 'B', '2025-02-01', 2, 3),
(7, '1049600777', 'Tomás', 'Becerra Niño', 'tomas.becerra@dronandes.co', 'A', '2026-06-15', 2, 3);
INSERT INTO clientes (id_cliente, tipo, nombre, nit_documento, email, telefono, municipio,
fecha_registro) VALUES
(1, 'HOSPITAL', 'Hospital San Juan de Dios de Rionegro', '890980000-1', 'compras@hsjdrionegro.org',
'6045310000', 'Rionegro', '2024-03-01'),
(2, 'FARMACIA', 'Droguería La Esperanza', '71234567', 'esperanza.drogueria@gmail.com',
'3104567890', 'Guatapé', '2024-09-12'),
(3, 'HOSPITAL', 'E.S.E. Hospital San Rafael de Tunja', '891800231-6', 'Logistica@HSRTunja.gov.co',
'6087405050', 'Tunja', '2025-01-25'),
(4, 'ONG', 'Fundación Alas para el Campo', '900456789-2', 'contacto@alasparaelcampo.org',
NULL, 'Marinilla', '2024-11-03'),
(5, 'COMERCIO', 'Repuestos Agrícolas El Arriero', '900123456-7', NULL, '31245678',
'El Peñol', '2025-04-18'),
(6, 'PERSONA', 'Mariana Gómez Arango', '1040123456', 'mariana.gomez@hotmail.com',
'3157778899', 'Guarne', '2025-07-07'),
(7, 'FARMACIA', 'Farmacia Botica del Páramo', '900777888-1', 'boticaparamo@gmail.com',
'3209998877', 'Ventaquemada', '2025-02-14'),
(8, 'COMERCIO', 'Café de Altura Las Nubes', '901222333-4', 'ventas@cafelasnubes.co',
'3001112233', 'Salento', '2026-07-20'),
(9, 'PERSONA', 'Jorge Iván Ríos', '79888777', NULL, NULL, 'Rionegro',
'2026-08-30'),
(10, 'ONG', 'Corporación Montaña Viva', '900999111-0', 'info@montanaviva.org',
'310555444', 'Sáchica', '2025-09-01');
INSERT INTO entregas (id_entrega, codigo, id_cliente, id_dron, id_piloto, fecha_programada,
fecha_entrega, municipio_destino, distancia_km, prioridad, estado, calificacion) VALUES
(1, 'ENT-0001', 1, 1, 3, '2026-08-03 08:00:00', '2026-08-03 08:42:00', 'San Vicente', 18.5, 'VITAL',
'ENTREGADA', 5),
(2, 'ENT-0002', 1, 3, 1, '2026-08-05 09:30:00', '2026-08-05 10:20:00', 'Concepción', 32.0,
'VITAL', 'ENTREGADA', 4),
(3, 'ENT-0003', 2, 4, 4, '2026-08-07 14:00:00', '2026-08-07 14:25:00', 'San Rafael', 12.0,
'NORMAL', 'ENTREGADA', 5),
(4, 'ENT-0004', 4, 2, 3, '2026-08-10 07:45:00', '2026-08-10 08:30:00', 'El Carmen de Viboral', 22.4,
'URGENTE', 'ENTREGADA', 3),
(5, 'ENT-0005', 5, 3, 1, '2026-08-12 11:00:00', NULL, 'El Peñol', 15.0, 'NORMAL',
'CANCELADA', NULL),
(6, 'ENT-0006', 3, 6, 2, '2026-08-14 06:30:00', '2026-08-14 07:40:00', 'Ramiriquí', 48.0, 'VITAL',
'ENTREGADA', 5),
(7, 'ENT-0007', 10, 7, 6, '2026-08-18 10:00:00', '2026-08-18 10:35:00', 'Samacá', 20.5,
'NORMAL', 'ENTREGADA', 4),
(8, 'ENT-0008', 3, 8, 6, '2026-08-20 08:15:00', NULL, 'Chíquiza', 35.0, 'URGENTE',
'FALLIDA', NULL),
(9, 'ENT-0009', 6, 4, 5, '2026-08-22 16:00:00', '2026-08-22 16:20:00', 'Guarne', 9.5, 'NORMAL',
'ENTREGADA', 2),
(10, 'ENT-0010', 1, 1, 1, '2026-08-25 07:00:00', '2026-08-25 07:50:00', 'Sonsón', 41.0, 'VITAL',
'ENTREGADA', 5),
(11, 'ENT-0011', 10, 6, 2, '2026-08-27 09:00:00', '2026-08-27 10:05:00', 'Sáchica', 52.5,
'URGENTE', 'ENTREGADA', NULL),
(12, 'ENT-0012', 2, 5, 4, '2026-08-29 13:00:00', NULL, 'Alejandría', 14.0, 'NORMAL',
'CANCELADA', NULL),
(13, 'ENT-0013', 4, 2, 1, '2026-09-01 08:00:00', '2026-09-01 08:55:00', 'Granada', 38.0,
'URGENTE', 'ENTREGADA', 4),
(14, 'ENT-0014', 1, 3, 1, '2026-09-03 10:30:00', '2026-09-03 11:15:00', 'Abejorral', 44.0, 'VITAL',
'ENTREGADA', 5),
(15, 'ENT-0015', 7, 7, 6, '2026-09-08 15:00:00', '2026-09-08 15:30:00', 'Turmequé', 17.0,
'NORMAL', 'ENTREGADA', 3),
(16, 'ENT-0016', 3, 6, 2, '2026-09-15 06:00:00', '2026-09-15 07:10:00', 'Miraflores', 58.0, 'VITAL',
'ENTREGADA', 4),
(17, 'ENT-0017', 6, 2, 3, '2026-09-21 17:00:00', NULL, 'Guarne', 10.0, 'NORMAL',
'CANCELADA', NULL),
(18, 'ENT-0018', 10, 7, 6, '2026-09-30 17:40:00', NULL, 'Villa de Leyva', 26.0, 'NORMAL',
'EN_VUELO', NULL),
(19, 'ENT-0019', 1, 1, 1, '2026-10-01 07:30:00', NULL, 'Nariño', 47.0, 'VITAL',
'PROGRAMADA', NULL),
(20, 'ENT-0020', 3, 6, 6, '2026-10-02 06:00:00', NULL, 'Pesca', 39.0, 'VITAL',
'PROGRAMADA', NULL);
INSERT INTO carga_entrega (id_entrega, id_tipo, peso_kg, unidades) VALUES
(1, 1, 3.00, 60), (1, 3, 2.00, 15),
(2, 2, 1.50, 30), (2, 3, 4.00, 40),
(3, 3, 1.80, 12),
(4, 3, 3.50, 25), (4, 4, 0.50, 3),
(5, 5, 6.00, 4),
(6, 1, 5.00, 100), (6, 2, 2.00, 40),
(7, 3, 6.00, 50),
(8, 1, 8.00, 160), (8, 3, 4.00, 30),
(9, 4, 0.80, 5),
(10, 1, 4.00, 80), (10, 2, 1.00, 20), (10, 3, 2.50, 20),
(11, 3, 7.00, 60), (11, 4, 1.00, 6),
(13, 3, 5.00, 40), (13, 5, 2.00, 2),
(14, 1, 6.00, 120), (14, 2, 3.00, 60),
(15, 3, 3.00, 25), (15, 4, 0.30, 2),
(16, 1, 10.00, 200), (16, 3, 8.00, 70),
(18, 3, 4.00, 35),
(19, 1, 3.50, 70),
(20, 2, 2.50, 50), (20, 1, 6.00, 120);
INSERT INTO mantenimientos (id_mantenimiento, id_dron, fecha, tipo, descripcion, costo) VALUES
(1, 2, '2026-03-15', 'PREVENTIVO', 'Cambio de hélices', 350000),
(2, 4, '2026-04-02', 'PREVENTIVO', 'Calibración de GPS', 180000),
(3, 5, '2026-09-25', 'CORRECTIVO', 'Falla en motor 3', 1250000),
(4, 8, '2026-08-21', 'CORRECTIVO', 'Impacto en aterrizaje, evaluación de daños', 2800000),
(5, 1, '2026-06-10', 'PREVENTIVO', 'Revisión general de 300 horas', 420000),
(6, 6, '2026-07-05', 'PREVENTIVO', NULL, 260000),
(7, 5, '2026-05-14', 'PREVENTIVO', 'Cambio de baterías', 950000),
(8, 2, '2026-09-12', 'CORRECTIVO', 'Sensor de altitud defectuoso', 610000);

-- R3.a --
alter table clientes modify column nombre varchar(120) not null;
-- R3.b--
ALTER TABLE drones
add constraint chk_drones_carga check (carga_max_kg between 0.5 and 25);

-- R3.c --
alter table pilotos
add constraint fk_pilotos_supervisor foreign key (id_supervisor) references pilotos (id_piloto);

-- R4.a --
insert into clientes (tipo, nombre, nit_documento, email, telefono, municipio, fecha_registro) values
('FARMACIA', 'Droguería Santa Ana',     '900314159-2', 'santaana@gmail.com',          '3112223344', 'Marinilla', '2026-09-28'),
('PERSONA',  'Esteban Mejía Toro',      '1036987654',  null,                          '3015556677', 'Rionegro',  '2026-09-29'),
('COMERCIO', 'Tienda Naturista Frailejón','901555666-3','tienda.frailejon@outlook.com','3209871234', 'Tunja',     '2026-09-30');

-- R4.b --
-- consultar drones --
select id_dron, codigo_serie, horas_vuelo, estado
from drones
where estado = 'ACTIVO' and horas_vuelo > 500;

update drones 
set estado = 'MANTENIMIENTO'
where id_dron in (4); 

-- R4.c --
-- (eliminar CANCELADAS sin carga registrada) --
select * from entregas 
where estado = 'CANCELADA'
and id_entrega not in (select id_entrega from carga_entrega);

delete from entregas 
where id_entrega in (12 , 17);

-- R4.d -- 
-- Escriba una consulta que muestre en una sola salida el total de clientes, el total de --
-- entregas y el número de drones en MANTENIMIENTO (evidencia 03) --

select (select count(*) from clientes) as total_clientes,
	(select count(*) from entregas) as total_entregas,
    (select count(*) from drones where estado = 'MANTENIMIENTO') as drones_mantenimiento; 
    
-- R5.a --
select codigo, municipio_destino, distancia_km, prioridad
from entregas
where estado = 'ENTREGADA'
  and distancia_km between 20 and 45
  and prioridad in ('VITAL', 'URGENTE')
order by distancia_km desc;

-- R5.b.1
SELECT codigo, estado, fecha_programada
FROM entregas
WHERE estado NOT IN ('PROGRAMADA', 'EN_VUELO', 'ENTREGADA')
  AND fecha_entrega IS NULL
ORDER BY codigo;
 
-- R5.b.2
SELECT codigo, fecha_entrega
FROM entregas
WHERE fecha_entrega IS NOT NULL
  AND calificacion IS NULL
ORDER BY codigo;
 
-- R5.c
SELECT codigo_serie, modelo, carga_max_kg, horas_vuelo, autonomia_km, estado
FROM drones
WHERE estado <> 'RETIRADO'
  AND ((carga_max_kg >= 8 AND horas_vuelo < 400) OR autonomia_km > 80)
ORDER BY codigo_serie ASC;
 
-- R5.d
SELECT nombres, apellidos, licencia, fecha_ingreso
FROM pilotos
WHERE NOT licencia = 'A'
  AND fecha_ingreso <= '2025-02-01'
ORDER BY fecha_ingreso ASC;

-- R6. Directorio comercial y calidad de datos
-- ---------------------------------------------------------------------
-- R6.a
SELECT UPPER(nombre) AS cliente,
       municipio,
       COALESCE(telefono, 'SIN TELÉFONO') AS telefono,
       COALESCE(LENGTH(telefono), 0) AS digitos
FROM clientes
WHERE telefono IS NULL OR LENGTH(telefono) <> 10
ORDER BY nombre ASC;
 
-- R6.b
SELECT nombre,
       LOWER(email) AS correo,
       CONCAT(nombre, ' <', LOWER(email), '>') AS contacto
FROM clientes
WHERE email IS NOT NULL
  AND LOWER(email) NOT LIKE '%@gmail.com'
  AND LOWER(email) NOT LIKE '%@hotmail.com'
  AND LOWER(email) NOT LIKE '%@outlook.com'
ORDER BY nombre;
 
-- R6.c
SELECT codigo_serie,
       UPPER(modelo) AS modelo,
       horas_vuelo,
       ROUND(horas_vuelo / 1000 * 100, 1) AS pct_vida_util
FROM drones
WHERE codigo_serie LIKE 'DA-CX_-__'
ORDER BY horas_vuelo DESC;

-- R7. Indicadores de gestion
-- ---------------------------------------------------------------------
-- R7.a
SELECT tc.nombre AS tipo_carga,
       COUNT(*) AS num_entregas,
       SUM(ce.peso_kg) AS kg_totales,
       ROUND(AVG(ce.peso_kg), 2) AS kg_promedio,
       MIN(ce.peso_kg) AS kg_minimo,
       MAX(ce.peso_kg) AS kg_maximo
FROM carga_entrega ce
INNER JOIN entregas e ON e.id_entrega = ce.id_entrega
INNER JOIN tipo_cargas tc ON tc.id_tipo = ce.id_tipo
WHERE e.estado = 'ENTREGADA'
GROUP BY tc.id_tipo, tc.nombre
ORDER BY kg_totales DESC;
 
-- R7.b
SELECT c.nombre AS cliente,
       COUNT(*) AS entregas_realizadas,
       ROUND(AVG(e.calificacion), 2) AS calificacion_promedio
FROM clientes c
INNER JOIN entregas e ON e.id_cliente = c.id_cliente
WHERE e.estado = 'ENTREGADA'
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(*) >= 2 AND AVG(e.calificacion) >= 4
ORDER BY calificacion_promedio DESC, cliente ASC;

-- R8. Consultas multitabla
-- ---------------------------------------------------------------------
-- R8.a
SELECT e.codigo,
       c.nombre AS cliente,
       CONCAT(p.nombres, ' ', p.apellidos) AS piloto,
       d.codigo_serie AS dron,
       b.nombre AS base,
       TIMESTAMPDIFF(MINUTE, e.fecha_programada, e.fecha_entrega) AS minutos_vuelo
FROM entregas e
INNER JOIN clientes c ON c.id_cliente = e.id_cliente
INNER JOIN pilotos p  ON p.id_piloto  = e.id_piloto
INNER JOIN drones d   ON d.id_dron    = e.id_dron
INNER JOIN bases b    ON b.id_base    = d.id_base
WHERE e.prioridad = 'VITAL' AND e.estado = 'ENTREGADA'
ORDER BY e.fecha_programada ASC;
 
-- R8.b  (evidencia 04)
SELECT CONCAT(p.nombres, ' ', p.apellidos) AS piloto,
       p.licencia,
       COUNT(e.id_entrega) AS entregas_realizadas
FROM pilotos p
LEFT JOIN entregas e ON e.id_piloto = p.id_piloto AND e.estado = 'ENTREGADA'
GROUP BY p.id_piloto, p.nombres, p.apellidos, p.licencia
ORDER BY entregas_realizadas DESC, piloto ASC;
 
-- R8.c
SELECT CONCAT(p.nombres, ' ', p.apellidos) AS piloto,
       p.licencia,
       COALESCE(CONCAT(s.nombres, ' ', s.apellidos), 'DIRECCIÓN DE OPERACIONES') AS supervisor
FROM pilotos p
LEFT JOIN pilotos s ON s.id_piloto = p.id_supervisor
ORDER BY supervisor, piloto;
 
-- R8.d
SELECT e.codigo,
       c.nombre AS cliente,
       d.codigo_serie AS dron,
       e.distancia_km,
       d.autonomia_km,
       e.distancia_km - d.autonomia_km AS exceso_km
FROM entregas e
INNER JOIN clientes c ON c.id_cliente = e.id_cliente
INNER JOIN drones d   ON d.id_dron    = e.id_dron
WHERE e.estado = 'PROGRAMADA'
  AND e.distancia_km > d.autonomia_km
ORDER BY e.codigo; 

-- R9. Subconsultas
-- ---------------------------------------------------------------------
-- R9.a
SELECT codigo, municipio_destino, distancia_km
FROM entregas
WHERE estado = 'ENTREGADA'
  AND distancia_km > (SELECT AVG(distancia_km) FROM entregas WHERE estado = 'ENTREGADA')
ORDER BY distancia_km DESC;
 
-- R9.b
SELECT nombre, tipo, municipio, fecha_registro
FROM clientes
WHERE id_cliente NOT IN (SELECT id_cliente FROM entregas)
ORDER BY fecha_registro, nombre;
 
-- R9.c  (evidencia 05)
SELECT d.codigo_serie, b.nombre AS base, d.horas_vuelo
FROM drones d
INNER JOIN bases b ON b.id_base = d.id_base
WHERE d.horas_vuelo > (SELECT AVG(d2.horas_vuelo) FROM drones d2 WHERE d2.id_base = d.id_base)
ORDER BY b.nombre, d.codigo_serie;
 
-- R9.d  (evidencia 05)
SELECT d.codigo_serie, d.modelo, d.estado
FROM drones d
WHERE d.estado <> 'RETIRADO'
  AND NOT EXISTS (SELECT 1 FROM mantenimientos m WHERE m.id_dron = d.id_dron)
ORDER BY d.codigo_serie;

-- R10. Vista e indices
-- ---------------------------------------------------------------------
-- R10.a
CREATE OR REPLACE VIEW vw_tablero_entregas AS
SELECT e.codigo,
       e.fecha_programada,
       c.nombre AS cliente,
       c.tipo AS tipo_cliente,
       e.municipio_destino,
       d.codigo_serie AS dron,
       CONCAT(p.nombres, ' ', p.apellidos) AS piloto,
       e.prioridad,
       e.estado,
       COUNT(ce.id_tipo) AS tipos_carga,
       COALESCE(SUM(ce.peso_kg), 0) AS peso_total_kg
FROM entregas e
INNER JOIN clientes c ON c.id_cliente = e.id_cliente
INNER JOIN drones d   ON d.id_dron    = e.id_dron
INNER JOIN pilotos p  ON p.id_piloto  = e.id_piloto
LEFT JOIN carga_entrega ce ON ce.id_entrega = e.id_entrega
GROUP BY e.id_entrega, e.codigo, e.fecha_programada, c.nombre, c.tipo,
         e.municipio_destino, d.codigo_serie, p.nombres, p.apellidos,
         e.prioridad, e.estado;
 
-- Prueba de la vista (evidencia 06)
SELECT *
FROM vw_tablero_entregas
WHERE estado IN ('PROGRAMADA', 'EN_VUELO')
ORDER BY fecha_programada;
 
-- R10.b
-- Indice 1: la busqueda "entregas por estado dentro de un rango de fechas" filtra
-- primero por igualdad (estado) y luego por rango (fecha_programada); por eso
-- el orden de columnas es (estado, fecha_programada).
CREATE INDEX idx_entregas_estado_fecha ON entregas (estado, fecha_programada);
 
-- Indice 2: la busqueda "clientes por tipo y municipio" usa ambas columnas con
-- igualdad; el indice compuesto evita recorrer toda la tabla de clientes.
CREATE INDEX idx_clientes_tipo_municipio ON clientes (tipo, municipio);
 
SHOW INDEX FROM entregas;
SHOW INDEX FROM clientes;

-- R11. Funcion almacenada
-- ---------------------------------------------------------------------
-- R11.a / R11.c

DELIMITER //

CREATE FUNCTION fn_valor_entrega(p_id_entrega INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_distancia DECIMAL(5,1);
    DECLARE v_prioridad VARCHAR(8);
    DECLARE v_carga DECIMAL(14,2);
    DECLARE v_total DECIMAL(14,2);
 
    IF NOT EXISTS (SELECT 1 FROM entregas WHERE id_entrega = p_id_entrega) THEN
        RETURN NULL;
    END IF;
 
    SELECT distancia_km, prioridad
    INTO v_distancia, v_prioridad
    FROM entregas
    WHERE id_entrega = p_id_entrega;
 
    SELECT COALESCE(SUM(ce.peso_kg * tc.tarifa_kg), 0)
    INTO v_carga
    FROM carga_entrega ce
    INNER JOIN tipo_cargas tc ON tc.id_tipo = ce.id_tipo -- Corregido a 'tipo_cargas'
    WHERE ce.id_entrega = p_id_entrega;
 
    SET v_total = v_carga + v_distancia * 1200;
    IF v_prioridad = 'URGENTE' THEN
        SET v_total = v_total * 1.20;
    END IF;
 
    RETURN ROUND(v_total, 2);
END//

DELIMITER ;
 
-- R11.b (1)  (evidencia 06)
SELECT codigo, prioridad, fn_valor_entrega(id_entrega) AS valor_cop
FROM entregas
WHERE estado = 'ENTREGADA' AND prioridad = 'URGENTE'
ORDER BY valor_cop DESC;
 
-- R11.b (2)
SELECT fn_valor_entrega(999) AS valor_entrega_inexistente;

-- R12. Trigger de auditoria
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_entregas_estado;
DELIMITER //
CREATE TRIGGER trg_entregas_estado
BEFORE UPDATE ON entregas
FOR EACH ROW
BEGIN
    IF NEW.estado <> OLD.estado THEN
        IF NEW.estado = 'ENTREGADA' AND NEW.fecha_entrega IS NULL THEN
            SET NEW.fecha_entrega = NOW();
        END IF;
        INSERT INTO historial_entregas (id_entrega, estado_anterior, estado_nuevo)
        VALUES (OLD.id_entrega, OLD.estado, NEW.estado);
    END IF;
END$$
DELIMITER ;
 
-- Demostracion (evidencia 07 si MySQL es el "otro motor")
UPDATE entregas SET estado = 'ENTREGADA', calificacion = 5 WHERE codigo = 'ENT-0018';
UPDATE entregas SET estado = 'CANCELADA' WHERE codigo = 'ENT-0019';
UPDATE entregas SET calificacion = 4 WHERE codigo = 'ENT-0011';
 
SELECT e.codigo, h.estado_anterior, h.estado_nuevo, h.fecha_cambio
FROM historial_entregas h
INNER JOIN entregas e ON e.id_entrega = h.id_entrega
ORDER BY h.id_historial;
 
SELECT codigo, estado, fecha_entrega, calificacion
FROM entregas
WHERE codigo IN ('ENT-0018', 'ENT-0019', 'ENT-0011')
ORDER BY codigo;

-- R13. Procedimiento almacenado
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_programar_entrega;
DELIMITER //
CREATE PROCEDURE sp_programar_entrega(
    IN p_codigo            VARCHAR(10),
    IN p_id_cliente        INT,
    IN p_id_dron           INT,
    IN p_id_piloto         INT,
    IN p_fecha_programada  DATETIME,
    IN p_municipio_destino VARCHAR(60),
    IN p_distancia_km      DECIMAL(5,1),
    IN p_prioridad         VARCHAR(8)
)
BEGIN
    DECLARE v_estado    VARCHAR(15);
    DECLARE v_autonomia DECIMAL(5,1);
    DECLARE v_licencia  CHAR(1);
 
    -- 1. El dron y el piloto deben existir
    IF NOT EXISTS (SELECT 1 FROM drones WHERE id_dron = p_id_dron) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dron indicado no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pilotos WHERE id_piloto = p_id_piloto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El piloto indicado no existe';
    END IF;
 
    SELECT estado, autonomia_km INTO v_estado, v_autonomia
    FROM drones WHERE id_dron = p_id_dron;
    SELECT licencia INTO v_licencia
    FROM pilotos WHERE id_piloto = p_id_piloto;
 
    -- 2. El dron debe estar ACTIVO (RN-06)
    IF v_estado <> 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dron no esta ACTIVO (RN-06)';
    END IF;
 
    -- 3. La distancia no puede superar la autonomia (RN-05)
    IF p_distancia_km > v_autonomia THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La distancia supera la autonomia del dron (RN-05)';
    END IF;
 
    -- 4. La licencia debe permitir la distancia (RN-03)
    IF (v_licencia = 'A' AND p_distancia_km > 20)
       OR (v_licencia = 'B' AND p_distancia_km > 40) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La licencia del piloto no permite esa distancia (RN-03)';
    END IF;
 
    INSERT INTO entregas (codigo, id_cliente, id_dron, id_piloto, fecha_programada,
                          municipio_destino, distancia_km, prioridad)
    VALUES (p_codigo, p_id_cliente, p_id_dron, p_id_piloto, p_fecha_programada,
            p_municipio_destino, p_distancia_km, p_prioridad);
 
    SELECT LAST_INSERT_ID() AS id_entrega_generado;
END//
DELIMITER ;
 
-- Pruebas. La 1a es valida; la 2a falla por RN-06 (DA-COL-01 quedo en
-- MANTENIMIENTO tras R4.b) y la 3a por RN-03 (piloto con licencia A, 28 km).
-- Los dos errores son ESPERADOS: ejecutar el script con "mysql --force".
CALL sp_programar_entrega('ENT-0021', 11, 3, 3, '2026-10-03 10:00:00', 'Marinilla', 16.0, 'URGENTE');
SELECT * FROM vw_tablero_entregas WHERE codigo = 'ENT-0021';
CALL sp_programar_entrega('ENT-0022', 6, 4, 4, '2026-10-03 11:00:00', 'Guarne', 9.0, 'NORMAL');
CALL sp_programar_entrega('ENT-0023', 2, 7, 7, '2026-10-04 08:00:00', 'Arcabuco', 28.0, 'NORMAL');

