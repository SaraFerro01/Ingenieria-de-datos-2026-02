drop database if exists cicloVerde;
create database cicloVerde;
use cicloVerde;

create table estaciones (
id_estacion int not null primary key auto_increment,
nombre varchar(50) not null unique,
barrio varchar(50) not null,
capacidad int not null,
constraint chk_capacidad check (capacidad>0),
activa boolean not null default TRUE
);

create table bicicleta (
id_bici int not null primary key auto_increment,
codigo varchar (10) not null unique,
modelo varchar(40) not null,
estado varchar (10) not null default 'ACTIVA',
constraint chk_estado check (estado in('ACTIVA', 'TALLER', 'BAJA')),
km_recorridos decimal(7,1) not null default 0,
constraint chk_km_recorridos check (km_recorridos >= 0),
id_estacion int not null, 
constraint fk_bicicleta_id_estacion foreign key (id_estacion) references estaciones(id_estacion)
);

create table usuarios(
id_usuario int not null primary key auto_increment,
documento varchar(15) not null unique,
nombres varchar(50) not null,
apellidos varchar(50) not null,
email varchar(80) unique,
telefono varchar(15),
plan varchar(10) not null default 'BASICO',
constraint chk_plan check (plan in ('BASICO', 'PREMIUM')),
fecha_registro date not null,
id_referidor int null
);

create table accesorios (
id_accesorio  int not null primary key auto_increment,
nombre varchar(40) not null unique,
precio decimal(8,2) not null,
constraint chk_precio check (precio > 0)
);


create table viajes(
    id_viaje int not null primary key auto_increment,
    id_usuario int not null,
    constraint fk_viajes_id_usuario foreign key (id_usuario) references usuarios(id_usuario),
    id_bici int not null,
    constraint fk_viajes_id_bici foreign key (id_bici) references bicicleta(id_bici), 
    id_estacion_origen int not null, 
    constraint fk_estacionorigen_id_estacion_origen foreign key (id_estacion_origen) references estaciones(id_estacion), 
    id_estacion_destino int not null,
    constraint fk_estaciondestino_id_estacion_destino foreign key (id_estacion_destino) references estaciones(id_estacion),
    fecha_inicio datetime not null,
    fecha_fin datetime,
    km decimal( 5,1) default 0,
    constraint chk_km check (km>0),
    estado varchar (12) not null default 'EN_CURSO',
    constraint chk_estado_viaje check (estado in( 'EN_CURSO' , 'FINALIZADO' , 'CANCELADO')) 
);

create table viaje_accesorio (
id_viaje int not null,
constraint fk_viaje_accesorio_id_viaje foreign key (id_viaje) references viajes(id_viaje),
id_accesorio int not null,
constraint fk_viaje_accesorio_id_accesorio foreign key (id_accesorio) references accesorios(id_accesorio),
cantidad int not null default 1,
constraint chk_cantidad check( cantidad>0)
);

create table historial_bicicletas (
id_historial int not null primary key auto_increment,
id_bici int not null,
constraint fk_historial_bicicletas_id_bici foreign key (id_bici) references bicicletas(id_bici),
estado_anterior varchar(10) not null,
estado_nuevo varchar(10) not null,
fecha_cambio datetime default current_timestamp
);

alter table usuarios




