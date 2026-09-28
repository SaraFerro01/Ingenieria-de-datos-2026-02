/* Reto 1 Reflexión */
/* Al añadir disponibilidad en algunos parametros se verifiica que el cafilcultor y/o la finca sigan trabajando con TrazCafe, y en caso de ser false en ningun mmento hay un delete asignado*/
-- reto 2
create database trazacafe;
use trazacafe;

create table caficultores (
    idCaficultor int auto_increment primary key,
    nombreCaficultor varchar(50) not null,
    caficultorDisponible boolean not null default true
);

create table catadores (
    idCatador int auto_increment primary key,
    nombreCatador varchar(50) not null
);

create table clientes (
    idCliente int auto_increment primary key,
    nombreCliente varchar(50) not null,
    correoCliente varchar(50) not null
);

create table fincas (
    idFinca int auto_increment primary key,
    nombreFinca varchar(50) not null,
    idcaFicultorfk int not null,
    municipio varchar(50) not null,
    departamento varchar(50) not null,
    altitud int not null,

    constraint fk_finca_caficultor
        foreign key (idCaficultorfk)
        references caficultores(idCaficultor)
);

create table lotes (
    idLote int auto_increment primary key,
    codigoLote varchar(50) unique not null,
    idFincafk int not null,
    variedadCafe varchar(50) not null,
    procesoCafe enum('lavado','honey','natural') not null,
    fechaCosecha date not null,
    kilosCosecha decimal(5,2) not null,

    constraint fk_lote_finca
        foreign key (idFincafk)
        references fincas(idFinca)
);

create table cataciones (
    idCatacion int auto_increment primary key,
    idLotefk int not null,
    idCatadorfk int not null,
    puntajeCatacion decimal(5,2) not null,

    constraint fk_catacion_lote
        foreign key (idLotefk)
        references lotes(idLote),

    constraint fk_catacion_catador
        foreign key (idCatadorfk)
        references catadores(idCatador)
);

create table tostiones (
    idTostiones int auto_increment primary key,
    idLotefk int not null,
    fechaTostion date not null,
    kilosIn decimal(7,2) not null,
    kilosOut decimal(7,2) not null,
    perfil varchar(50) not null,

    constraint fk_tostion_lote
        foreign key (idLotefk)
        references lotes(idLote)
);

create table pedido (
    idPedido int auto_increment primary key,
    idClientefk int not null,
    estadoPedido varchar(50) default 'pendiente',

    constraint fk_pedido_cliente
        foreign key (idClientefk)
        references clientes(idCliente)
);

create table lineasPedido (
    idlineaPedido int auto_increment primary key,
    idPedidofk int not null,
    idTostionfk int not null,
    kilosPedido decimal(7,2) not null,
    precioPedido decimal(10,2) not null,

    constraint fk_lineapedido_pedido
        foreign key (idPedidofk)
        references pedido(idPedido),

    constraint fk_lineapedido_tostion
        foreign key (idTostionfk)
        references tostiones(idTostiones)
);

/* Reflexion 2*/
/* Si se pone al contario, las llaves foraneas quedarian puestas antes de las primaras y al correr generariar un error /*

/* Reto 3 */
/* Reglas */

/*Altitud*/
alter table fincas 
	add constraint verify_finca_altitud
    check (altitud between 800 and 2500);
    
/* Puntaje */
alter table cataciones
	add constraint verify_puntaje_catacion
    check (puntajeCatacion between 0 and 100);
    
/* kilos in kilos out*/
alter table tostiones 
	add constraint verify_kilos_tostiones
    check (kilosOut <= kilosIn);
    
/* punto 2*/

alter table tostiones
    add constraint chk_tostion_perfil
    check (perfil in ('claro','medio','oscuro'));
    
select table_name, constraint_name, constraint_type
from information_schema.table_constraints
where table_schema = 'trazacafe'
order by table_name, constraint_type;

/* punto 3*/

/* Un caficultor con fincas no se puede borrar; se da de baja con caficultorDisponible = false */
alter table fincas drop foreign key fk_finca_caficultor;
alter table fincas
    add constraint fk_finca_caficultor
        foreign key (idCaficultorfk) references caficultores(idCaficultor)
        on delete restrict;

/* Una finca con lotes no se puede borrar */
alter table lotes drop foreign key fk_lote_finca;
alter table lotes
    add constraint fk_lote_finca
        foreign key (idFincafk) references fincas(idFinca)
        on delete restrict;

/* Las cataciones son parte de la historia del lote y del catador */
alter table cataciones drop foreign key fk_catacion_lote;
alter table cataciones drop foreign key fk_catacion_catador;
alter table cataciones
    add constraint fk_catacion_lote
        foreign key (idLotefk) references lotes(idLote)
        on delete restrict;
alter table cataciones
    add constraint fk_catacion_catador
        foreign key (idCatadorfk) references catadores(idCatador)
        on delete restrict;

/* Un lote con tostiones no se puede borrar */
alter table tostiones drop foreign key fk_tostion_lote;
alter table tostiones
    add constraint fk_tostion_lote
        foreign key (idLotefk) references lotes(idLote)
        on delete restrict;

/* Un cliente con pedidos no se puede borrar */
alter table pedido drop foreign key fk_pedido_cliente;
alter table pedido
    add constraint fk_pedido_cliente
        foreign key (idClientefk) references clientes(idCliente)
        on delete restrict;

/* Un pedido con líneas y una tostión vendida no se pueden borrar */
alter table lineasPedido drop foreign key fk_lineapedido_pedido;
alter table lineasPedido drop foreign key fk_lineapedido_tostion;
alter table lineasPedido
    add constraint fk_lineapedido_pedido
        foreign key (idPedidofk) references pedido(idPedido)
        on delete restrict;
alter table lineasPedido
    add constraint fk_lineapedido_tostion
        foreign key (idTostionfk) references tostiones(idTostiones)
        on delete restrict;

/* Verificación: debe mostrar RESTRICT en las 8 filas */
select constraint_name, table_name, delete_rule
from information_schema.referential_constraints
where constraint_schema = 'trazacafe';

/* punto 4 */

/* punto 4: datos válidos de base */

insert into caficultores (nombreCaficultor) values ('Carlos Muñoz');

insert into fincas (nombreFinca, idCaficultorfk, municipio, departamento, altitud)
    values ('La Esperanza', 1, 'Pitalito', 'Huila', 1750);
    
insert into lotes (codigoLote, idFincafk, variedadCafe, procesoCafe, fechaCosecha, kilosCosecha)
    values ('HUI-2026-001', 1, 'Caturra', 'lavado', '2026-03-02', 450.50);
    
insert into catadores (nombreCatador) values ('Ana Torres');

insert into cataciones (idLotefk, idCatadorfk, puntajeCatacion) values (1, 1, 86.25);

insert into tostiones (idLotefk, fechaTostion, kilosIn, kilosOut, perfil)
    values (1, '2026-03-10', 100, 85, 'medio');
    
insert into clientes (nombreCliente, correoCliente)
    values ('Rösterei Berlin', 'info@roesterei.de');
    
insert into pedido (idClientefk) values (1);

insert into lineasPedido (idPedidofk, idTostionfk, kilosPedido, precioPedido)
    values (1, 1, 20, 6000);
    
/* 1. altitud fuera de rango (máx. 2500) */
insert into fincas (nombreFinca, idCaficultorfk, municipio, departamento, altitud)
    values ('Finca Nube', 1, 'Salento', 'Quindío', 3000);
    
/* error: Check constraint 'verify_finca_altitud' is violated. */

/* 2. puntaje SCA mayor a 100 */
insert into cataciones (idLotefk, idCatadorfk, puntajeCatacion) values (1, 1, 105);
/* error : Check constraint 'verify_puntaje_catacion' is violated. */

/* 3. salen más kilos de los que entraron */
insert into tostiones (idLotefk, fechaTostion, kilosIn, kilosOut, perfil)
    values (1, '2026-03-11', 100, 120, 'medio');
/* error : Check constraint 'verify_kilos_tostiones' is violated. */

/* 4. perfil que no existe */
insert into tostiones (idLotefk, fechaTostion, kilosIn, kilosOut, perfil)
    values (1, '2026-03-11', 100, 85, 'tostado');
/* erro: Check constraint 'chk_tostion_perfil' is violated. */

/* 5. código de lote repetido */
insert into lotes (codigoLote, idFincafk, variedadCafe, procesoCafe, fechaCosecha, kilosCosecha)
    values ('HUI-2026-001', 1, 'Castillo', 'honey', '2026-04-01', 300);
    
/* error : 1062 Duplicate entry 'HUI-2026-001' for key 'lotes.codigoLote' */

insert into pedido (idClientefk) values (1);

select idPedido, estadoPedido from pedido;
/* el pedido nuevo debe mostrar 'pendiente' */

delete from caficultores where idCaficultor = 1;    /* fk_finca_caficultor: debe fallar */
delete from fincas where idFinca = 1;              /* fk_lote_finca: debe fallar */
delete from lotes where idLote = 1;                /* fk_catacion_lote: debe fallar */
delete from catadores where idCatador = 1;         /* fk_catacion_catador: debe fallar */
delete from tostiones where idTostiones = 1;       /* fk_lineapedido_tostion: debe fallar */
delete from clientes where idCliente = 1;          /* fk_pedido_cliente: debe fallar */
delete from pedido where idPedido = 1;             /* fk_lineapedido_pedido: debe fallar */

/* Reflexion 3*/
/* un CHECK  no sirve para reglas que dependen de otras filas o tablas, como que los kilos que entran a tostión no superen los kilos cosechados
 del lote*/
   
/* Bloque 2 */
/*Reto 4*/

alter table clientes
    add column pais varchar(50) not null default 'Colombia';

describe clientes;

update clientes set pais = 'Alemania' where idCliente = 1;

/* punto 2: huella de carbono */
alter table tostiones
    add column huella_carbono_kg decimal(10,2) null;

alter table tostiones
    add constraint chk_tostion_huella
    check (huella_carbono_kg is null or huella_carbono_kg >= 0);
    
/* punto 3: ampliar precisión de columnas de kilos */
alter table lotes
    modify column kilosCosecha decimal(10,2) not null;

alter table tostiones
    modify column kilosIn decimal(10,2) not null;

alter table tostiones
    modify column kilosOut decimal(10,2) not null;

alter table lineasPedido
    modify column kilosPedido decimal(10,2) not null;

/* verificación */
select table_name, column_name, column_type
from information_schema.columns
where table_schema = 'trazacafe'
  and column_name in ('kilosCosecha','kilosIn','kilosOut','kilosPedido');
  
/* punto 4: certificaciones (N:M con fincas) */

create table certificaciones (
    idCertificacion int auto_increment primary key,
    nombreCertificacion varchar(50) not null unique
);

create table fincaCertificaciones (
    idFincafk int not null,
    idCertificacionfk int not null,
    fechaObtencion date not null,

    primary key (idFincafk, idCertificacionfk),

    constraint fk_fincacert_finca
        foreign key (idFincafk)
        references fincas(idFinca)
        on delete restrict,

    constraint fk_fincacert_certificacion
        foreign key (idCertificacionfk)
        references certificaciones(idCertificacion)
        on delete restrict
);

insert into certificaciones (nombreCertificacion) values
    ('Orgánico'), ('Fair Trade'), ('Rainforest Alliance');

insert into fincaCertificaciones (idFincafk, idCertificacionfk, fechaObtencion)
    values (1, 1, '2025-06-15');

/* debe fallar: fila duplicada, viola la llave primaria compuesta */
insert into fincaCertificaciones (idFincafk, idCertificacionfk, fechaObtencion)
    values (1, 1, '2026-01-10');

/* consulta de comprobación: certificaciones por finca */
select f.nombreFinca, c.nombreCertificacion, fc.fechaObtencion
from fincaCertificaciones fc
join fincas f on f.idFinca = fc.idFincafk
join certificaciones c on c.idCertificacion = fc.idCertificacionfk;

/* punto 5*/

alter table tostiones
    change column perfil perfilTueste varchar(50) not null;

/* verificación */
describe tostiones;
show create table tostiones;

/* Reflexion 4 */ 
/*  borrar y recrear una tabla afectalos datos que ya tiene y rompe las llaves foráneas, vistas e indices dependientes de esa tabla 
y puee verse como una caida del sistema */

/* Reto 5*/
/* punto 1: datos de prueba */

/* --- Caficultores adicionales --- */
insert into caficultores (nombreCaficultor) values
    ('Marta Gómez'), ('José Ramírez'), ('Luis Fernández');

/* --- Fincas: 4 en total (con la de reto 3), 3 departamentos distintos --- */
insert into fincas (nombreFinca, idCaficultorfk, municipio, departamento, altitud) values
    ('El Mirador', (select idCaficultor from caficultores where nombreCaficultor='Marta Gómez'), 'Salento', 'Quindío', 1900),
    ('Buenavista', (select idCaficultor from caficultores where nombreCaficultor='José Ramírez'), 'Inzá', 'Cauca', 1600),
    ('Villa Rica', (select idCaficultor from caficultores where nombreCaficultor='Luis Fernández'), 'Garzón', 'Huila', 1400);
/* con "La Esperanza" (Huila) ya insertada en reto 3: 4 fincas, departamentos Huila/Quindío/Cauca */

/* --- Lotes: 8 en total (con el de reto 3) --- */
insert into lotes (codigoLote, idFincafk, variedadCafe, procesoCafe, fechaCosecha, kilosCosecha) values
    ('HUI-2026-002', (select idFinca from fincas where nombreFinca='La Esperanza'), 'Castillo', 'honey', '2026-03-15', 620.00),
    ('QUI-2026-001', (select idFinca from fincas where nombreFinca='El Mirador'), 'Caturra', 'natural', '2026-02-20', 780.50),
    ('QUI-2026-002', (select idFinca from fincas where nombreFinca='El Mirador'), 'Castillo', 'lavado', '2026-03-05', 510.00),
    ('CAU-2026-001', (select idFinca from fincas where nombreFinca='Buenavista'), 'Tabi', 'lavado', '2026-02-10', 430.75),
    ('CAU-2026-002', (select idFinca from fincas where nombreFinca='Buenavista'), 'Caturra', 'honey', '2026-03-01', 390.00),
    ('HUI-2026-003', (select idFinca from fincas where nombreFinca='Villa Rica'), 'Castillo', 'natural', '2026-02-25', 900.00),
    ('HUI-2026-004', (select idFinca from fincas where nombreFinca='Villa Rica'), 'Caturra', 'lavado', '2026-03-10', 560.20);

/* --- Catadores adicionales --- */
insert into catadores (nombreCatador) values ('Diego Salazar'), ('Paula Restrepo');

/* --- Cataciones: 10 en total (con la de reto 3) --- */
insert into cataciones (idLotefk, idCatadorfk, puntajeCatacion) values
    ((select idLote from lotes where codigoLote='HUI-2026-002'), (select idCatador from catadores where nombreCatador='Ana Torres'), 84.00),
    ((select idLote from lotes where codigoLote='HUI-2026-002'), (select idCatador from catadores where nombreCatador='Diego Salazar'), 85.50),
    ((select idLote from lotes where codigoLote='QUI-2026-001'), (select idCatador from catadores where nombreCatador='Diego Salazar'), 88.25),
    ((select idLote from lotes where codigoLote='QUI-2026-002'), (select idCatador from catadores where nombreCatador='Paula Restrepo'), 82.75),
    ((select idLote from lotes where codigoLote='CAU-2026-001'), (select idCatador from catadores where nombreCatador='Ana Torres'), 80.00),
    ((select idLote from lotes where codigoLote='CAU-2026-002'), (select idCatador from catadores where nombreCatador='Paula Restrepo'), 79.50),
    ((select idLote from lotes where codigoLote='HUI-2026-003'), (select idCatador from catadores where nombreCatador='Diego Salazar'), 90.00),
    ((select idLote from lotes where codigoLote='HUI-2026-003'), (select idCatador from catadores where nombreCatador='Ana Torres'), 89.25),
    ((select idLote from lotes where codigoLote='HUI-2026-004'), (select idCatador from catadores where nombreCatador='Paula Restrepo'), 83.00);

/* --- Tostiones: 5 en total (con la de reto 3). La columna ya se llama perfilTueste --- */
insert into tostiones (idLotefk, fechaTostion, kilosIn, kilosOut, perfilTueste, huella_carbono_kg) values
    ((select idLote from lotes where codigoLote='HUI-2026-002'), '2026-03-20', 200.00, 170.00, 'oscuro', 18.30),
    ((select idLote from lotes where codigoLote='QUI-2026-001'), '2026-03-01', 150.00, 128.00, 'claro', null),
    ((select idLote from lotes where codigoLote='CAU-2026-001'), '2026-02-18', 100.00, 84.00, 'medio', 9.10),
    ((select idLote from lotes where codigoLote='HUI-2026-003'), '2026-03-05', 300.00, 255.00, 'medio', 27.60);

/* --- Clientes: 3 en total (con Rösterei Berlin, Alemania, ya actualizado en reto 4) --- */
insert into clientes (nombreCliente, correoCliente, pais) values
    ('Café Andino S.A.S.', 'ventas@cafeandino.co', 'Colombia'),
    ('Nordic Roasters', 'hello@nordicroasters.se', 'Suecia');

/* --- Pedidos: 4 en total (con el de reto 3) --- */
insert into pedido (idClientefk, estadoPedido) values
    ((select idCliente from clientes where nombreCliente='Rösterei Berlin'), 'enviado'),
    ((select idCliente from clientes where nombreCliente='Café Andino S.A.S.'), 'pendiente'),
    ((select idCliente from clientes where nombreCliente='Nordic Roasters'), 'pendiente');

/* --- Líneas de pedido: mínimo 6 en total (con la de reto 3) --- */
insert into lineasPedido (idPedidofk, idTostionfk, kilosPedido, precioPedido) values
    ((select idPedido from pedido where idClientefk=(select idCliente from clientes where nombreCliente='Rösterei Berlin' limit 1) and estadoPedido='pendiente' limit 1),
     (select idTostiones from tostiones where idLotefk=(select idLote from lotes where codigoLote='CAU-2026-001') limit 1), 15, 45000),
    ((select idPedido from pedido where idClientefk=(select idCliente from clientes where nombreCliente='Rösterei Berlin' limit 1) and estadoPedido='enviado' limit 1),
     (select idTostiones from tostiones where idLotefk=(select idLote from lotes where codigoLote='HUI-2026-002') limit 1), 30, 90000),
    ((select idPedido from pedido where idClientefk=(select idCliente from clientes where nombreCliente='Café Andino S.A.S.' limit 1) limit 1),
     (select idTostiones from tostiones where idLotefk=(select idLote from lotes where codigoLote='QUI-2026-001') limit 1), 25, 75000),
    ((select idPedido from pedido where idClientefk=(select idCliente from clientes where nombreCliente='Café Andino S.A.S.' limit 1) limit 1),
     (select idTostiones from tostiones where idLotefk=(select idLote from lotes where codigoLote='HUI-2026-001') limit 1), 10, 32000),
    ((select idPedido from pedido where idClientefk=(select idCliente from clientes where nombreCliente='Nordic Roasters' limit 1) limit 1),
     (select idTostiones from tostiones where idLotefk=(select idLote from lotes where codigoLote='HUI-2026-003') limit 1), 40, 120000);

/* Punto 4*/
/* punto 4: lotes_especialidad */

create table lotes_especialidad (
    idLote int primary key,
    codigoLote varchar(50) not null,
    idFincafk int not null,
    variedadCafe varchar(50) not null,
    procesoCafe enum('lavado','honey','natural') not null,
    fechaCosecha date not null,
    kilosCosecha decimal(9,2) not null,
    puntajePromedio decimal(5,2) not null
);

insert into lotes_especialidad
select
    l.idLote,
    l.codigoLote,
    l.idFincafk,
    l.variedadCafe,
    l.procesoCafe,
    l.fechaCosecha,
    l.kilosCosecha,
    avg(c.puntajeCatacion)
from lotes l
join cataciones c on c.idLotefk = l.idLote
group by l.idLote, l.codigoLote, l.idFincafk, l.variedadCafe, l.procesoCafe, l.fechaCosecha, l.kilosCosecha
having avg(c.puntajeCatacion) >= 85;

/* verificación */

select count(*) as fincas, count(distinct departamento) as departamentos from fincas;
select count(*) as lotes from lotes;
select count(*) as cataciones from cataciones;
select count(*) as tostiones from tostiones;
select count(*) as clientes from clientes;
select count(*) as pedidos from pedido;
select count(*) as lineas from lineasPedido;

/* Reflexion 5*/
/* lotes especialidad no es una copia de los datos al momento del insert, bucando se puede usarr una vista o una vista como refresh */

/* Reto 6 */

/* Reto 6 */
/* punto 1: tabla de precios de referencia */

create table precios_referencia (
    variedad varchar(50) primary key,
    precio_kg decimal(10,2) not null,
    actualizado_en datetime not null default current_timestamp
);

/* punto 2: precios de la semana 1 */
insert into precios_referencia (variedad, precio_kg) values
    ('Castillo', 32000),
    ('Caturra', 35500),
    ('Geisha', 120000);

/* punto 3: upsert - semana 2 */
insert into precios_referencia (variedad, precio_kg) values
    ('Caturra', 36800),
    ('Geisha', 118000),
    ('Bourbon', 41000)
on duplicate key update
    precio_kg = values(precio_kg),
    actualizado_en = current_timestamp;

/* verificación: deben quedar 4 variedades */

/* Reflexion 6  */

/* No se podria detectar cuando una variedad ya existe y en workbench se  las flas quedarian duplicadas */ 

/* Reto 7 */

/* punto 1: corregir cataciones del catador con la balanza descalibrada */

/* antes del UPDATE: cuántas filas van a cambiar */
select idCatacion, puntajeCatacion
from cataciones
where idCatadorfk = (select idCatador from catadores where nombreCatador = 'Diego Salazar'); 

update cataciones
set puntajeCatacion = greatest(puntajeCatacion - 1.5, 0)
where idCatadorfk = (select idCatador from catadores where nombreCatador = 'Diego Salazar');

select idCatacion, puntajeCatacion
from cataciones
where idCatadorfk = (select idCatador from catadores where nombreCatador = 'Diego Salazar');

/* punto 2: descuento del 10% al cliente alemán */

/* antes del UPDATE: qué filas van a cambiar */
select lp.idlineaPedido, lp.idPedidofk, lp.precioPedido, c.nombreCliente, c.pais
from lineasPedido lp
join pedido p on p.idPedido = lp.idPedidofk
join clientes c on c.idCliente = p.idClientefk
where c.pais = 'Alemania';

update lineasPedido lp
join pedido p on p.idPedido = lp.idPedidofk
join clientes c on c.idCliente = p.idClientefk
set lp.precioPedido = lp.precioPedido * 0.9
where c.pais = 'Alemania';

set sql_safe_updates = 0;

update lineasPedido lp
join pedido p on p.idPedido = lp.idPedidofk
join clientes c on c.idCliente = p.idClientefk
set lp.precioPedido = lp.precioPedido * 0.9
where c.pais = 'Alemania';

select lp.idlineaPedido, lp.precioPedido, c.nombreCliente, c.pais
from lineasPedido lp
join pedido p on p.idPedido = lp.idPedidofk
join clientes c on c.idCliente = p.idClientefk
where c.pais = 'Alemania';

/* Reflexion 7 */

/*  el descuento se habría aplicado dos veces, porque el UPDATE calcula sobre el precio actual */
/* Reto 8 */

/* punto 1: intentar borrar una finca con lotes vendidos */

select idFinca, nombreFinca from fincas where nombreFinca = 'La Esperanza';

select l.codigoLote
from lotes l
join fincas f on f.idFinca = l.idFincafk
where f.nombreFinca = 'La Esperanza';

delete from fincas where nombreFinca = 'La Esperanza';

/* punto 2: baja lógica de la finca */

/* ALTER TABLE: nueva columna */
alter table fincas
    add column activa boolean not null default true;

/* UPDATE: dar de baja a "La Esperanza" */
update fincas
set activa = false
where nombreFinca = 'La Esperanza';

/* verificación */
select idFinca, nombreFinca, activa from fincas;

/* Reto 8 */
/* punto 3: borrar cataciones de un lote de prueba */

select c.idCatacion, c.puntajeCatacion, l.codigoLote
from cataciones c
join lotes l on l.idLote = c.idLotefk
where l.codigoLote = 'HUI-2026-001';

delete c
from cataciones c
join lotes l on l.idLote = c.idLotefk
where l.codigoLote = 'HUI-2026-001';

/* punto 4: vaciar y eliminar lotes_especialidad */

/* TRUNCATE: vacía la tabla y reinicia el auto_increment */
truncate table lotes_especialidad;

/* verificación de que quedó vacía */
select count(*) from lotes_especialidad;

/* DROP TABLE: elimina la tabla por completo */
drop table lotes_especialidad;

/* verificación de que ya no existe */
show tables like 'lotes_especialidad';

/* Reflexion 8*/
/*  DELETE (DML) borra filas según un WHERE, se puede deshacer con ROLLBACK y respeta las llaves foráneas
 TRUNCATE (DDL) vacía toda la tabla de golpe
 DROP (DDL) elimina la tabla completa con su estructura.

/* Reto 9 */
/* punto 1: kilos disponibles por tostión */

alter table tostiones
    add column kilosDisponibles decimal(10,2) not null default 0;

update tostiones set kilosDisponibles = kilosOut;

alter table tostiones
    add constraint chk_tostion_kilosdisponibles
    check (kilosDisponibles >= 0);

/* verificación */
select idTostiones, idLotefk, kilosOut, kilosDisponibles from tostiones;

/* punto 2: transacción exitosa */

start transaction;

insert into pedido (idClientefk, estadoPedido) values
    ((select idCliente from clientes where nombreCliente = 'Café Andino S.A.S.' limit 1), 'pendiente');

set @pedido_ok = last_insert_id();

insert into lineasPedido (idPedidofk, idTostionfk, kilosPedido, precioPedido) values
    (@pedido_ok, (select idTostiones from tostiones where idLotefk = (select idLote from lotes where codigoLote = 'HUI-2026-002') limit 1), 20, 60000),
    (@pedido_ok, (select idTostiones from tostiones where idLotefk = (select idLote from lotes where codigoLote = 'QUI-2026-001') limit 1), 15, 45000);

update tostiones set kilosDisponibles = kilosDisponibles - 20
    where idLotefk = (select idLote from lotes where codigoLote = 'HUI-2026-002');

update tostiones set kilosDisponibles = kilosDisponibles - 15
    where idLotefk = (select idLote from lotes where codigoLote = 'QUI-2026-001');

commit;

/* verificación */
select * from pedido where idPedido = @pedido_ok;
select * from lineasPedido where idPedidofk = @pedido_ok;
select codigoLote, kilosDisponibles from tostiones t join lotes l on l.idLote = t.idLotefk
    where l.codigoLote in ('HUI-2026-002','QUI-2026-001');

/* punto 4: savepoint */

start transaction;

insert into pedido (idClientefk, estadoPedido) values
    ((select idCliente from clientes where nombreCliente = 'Nordic Roasters' limit 1), 'pendiente');

set @pedido_savepoint = last_insert_id();

insert into lineasPedido (idPedidofk, idTostionfk, kilosPedido, precioPedido) values
    (@pedido_savepoint, (select idTostiones from tostiones where idLotefk = (select idLote from lotes where codigoLote = 'HUI-2026-002') limit 1), 10, 30000);

update tostiones set kilosDisponibles = kilosDisponibles - 10
    where idLotefk = (select idLote from lotes where codigoLote = 'HUI-2026-002');

savepoint antes_segunda_linea;

insert into lineasPedido (idPedidofk, idTostionfk, kilosPedido, precioPedido) values
    (@pedido_savepoint, (select idTostiones from tostiones where idLotefk = (select idLote from lotes where codigoLote = 'QUI-2026-002') limit 1), 9999, 500000);

update tostiones set kilosDisponibles = kilosDisponibles - 9999
    where idLotefk = (select idLote from lotes where codigoLote = 'QUI-2026-002');
/* este UPDATE también falla por el CHECK */

rollback to savepoint antes_segunda_linea;

commit;

/* verificación: la cabecera y la primera línea deben existir; la segunda no */
select * from pedido where idPedido = @pedido_savepoint;
select * from lineasPedido where idPedidofk = @pedido_savepoint;

/* punto 5: DDL dentro de una transacción */

start transaction;

create table prueba (id int primary key);

rollback;

show tables like 'prueba';

drop table if exists prueba;

/* Reflexion 9*/
/* el CREATE TABLE dentro de la transacción provocó un commit implícito, así que el ROLLBACK no deshizo la tabla
 si un paso falla a la mitad no se puede revertir todo y queda la base a medias; hay que hacer pasos idempotentes y probar antes.

/* Reto 10 */
/* El QR que cuenta la historia */

/* punto 1: crear la vista de trazabilidad */

create or replace view v_trazabilidad as
select
    lp.idlineaPedido,
    p.idPedido,
    c.nombreCliente as cliente,
    c.pais,
    f.nombreFinca as finca,
    cf.nombreCaficultor as caficultor,
    f.municipio,
    f.altitud,
    l.variedadCafe as variedad,
    l.procesoCafe as proceso,
    avg(cat.puntajeCatacion) as puntajeSCApromedio,
    t.fechaTostion,
    t.perfilTueste,

    /* punto 2: texto que aparecerá en el QR */
    concat(
        l.variedadCafe,
        ' ',
        l.procesoCafe,
        ' de ',
        f.nombreFinca,
        ', ',
        f.municipio,
        ' (',
        format(f.altitud, 0),
        ' m). Puntaje ',
        replace(format(avg(cat.puntajeCatacion), 2), '.', ','),
        '. Tostado ',
        t.perfilTueste,
        ' el ',
        date_format(t.fechaTostion, '%Y-%m-%d'),
        '.'
    ) as texto_qr

from lineasPedido lp

join pedido p
    on p.idPedido = lp.idPedidofk

join clientes c
    on c.idCliente = p.idClientefk

join tostiones t
    on t.idTostiones = lp.idTostionfk

join lotes l
    on l.idLote = t.idLotefk

join fincas f
    on f.idFinca = l.idFincafk

join caficultores cf
    on cf.idCaficultor = f.idCaficultorfk

left join cataciones cat
    on cat.idLotefk = l.idLote

group by
    lp.idlineaPedido,
    p.idPedido,
    c.nombreCliente,
    c.pais,
    f.nombreFinca,
    cf.nombreCaficultor,
    f.municipio,
    f.altitud,
    l.variedadCafe,
    l.procesoCafe,
    t.fechaTostion,
    t.perfilTueste;


/* punto 3: consultar la vista */

select *
from v_trazabilidad
where idPedido = 1;

select
    idPedido,
    cliente,
    pais,
    texto_qr
from v_trazabilidad
where idPedido = 1;

/* punto 4: verificación de la vista */

select *
from v_trazabilidad;

/* Reflexion 10*/
/* una vista no guarda datos, solo la consulta, y la ejecuta cada vez que se pide, así que siempre
refleja el estado actual de fincas, cataciones y pedidos. lotes_especialidad era una copia que se desactualizaba; la vista
evita duplicar datos y no hay que sincronizarla */

/* Reto creativo */

/* Un dato adicional que haría más valiosa la historia del QR
   serían las notas sensoriales de la catación, por ejemplo:
   chocolate, caramelo, frutos rojos, cítricos, etc. */

/* Se agrega el nuevo dato al modelo. */

alter table cataciones
    add column notasSensoriales varchar(255) null;


/* Se agregan notas sensoriales a la catación existente. */

update cataciones
set notasSensoriales = 'chocolate, caramelo y frutos rojos'
where idCatacion = 1;


/* Verificación del nuevo dato */

select
    idCatacion,
    puntajeCatacion,
    notasSensoriales
from cataciones;

