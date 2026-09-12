create database transporte;
use transporte;

create table camionero(
idCamionero varchar (50) primary key,
nombreCamionero varchar (50) not null,
telefono int not null,
direccionCamionero varchar (100) not null 
);

create table conduccion(
idConduccion varchar (50) primary key,
idCamioneroFK varchar (50), 
placaFK varchar (10) not null 
);

alter table conduccion
add idCamioneroFK varchar(50);

alter table conduccion
add constraint conduccionCamionero
foreign key (idCamioneroFK)
references camionero(idCamionero);

alter table conduccion
add placaFK varchar(50);

create table camion(
idCamion varchar (50) primary key,
placaCamion varchar (50) not null,
potenciaCamion int not null,
tipoCamion varchar (50) not null 
);

alter table camion
add constraint uq_placa_camion
unique (placaCamion);

alter table conduccion
add constraint fk_conduccion_camion
foreign key (placaFK)
references camion(placaCamion);

create table paquete(
idPaquete varchar (50) primary key,
descripcionPaquete varchar (100) not null,
destinatarioPaquete varchar (50) not null,
direccionPaquete varchar (100) not null 
);

alter table paquete
add idCamioneroFK varchar(50);

alter table paquete
add constraint fk_paquete_camionero
foreign key (idCamioneroFK)
references camionero(idCamionero);

create table ciudad(
codigoCiudad varchar (50) primary key,  
idPaqueteFK varchar (50),
nombreCiudad varchar (20)
);

alter table ciudad
add constraint fk_ciudad_paquete
foreign key (idPaqueteFK)
references paquete(idPaquete);
