create database Empresa_de_Seguros;
use Empresa_de_Seguros;

create table Compañia(
idCompañia varchar(50) primary key,
nitCompañia int not null,
nombreCompañia varchar(50) not null,
fechaFundacion date,
RepresentanteLegal varchar (50) not null
);

create table Automovil(
idAutomovil varchar (50) primary key,
marcaAutomovil varchar (50) not null,
modeloAutomovil varchar (50) not null,
placaAutomovil varchar(10) not null,
tipoAutomovil varchar (50) not null,
anioFabricacion year not null,
serieChasis int not null,
pasajeros int,
cilindrajeAutomovil varchar(30),
idCompañiaFK varchar (50),
fechaInicio date,
estadoAutomovil bool, 
valorAsegurado int not null,
costoAutomovil int not null
);

alter table Automovil
add constraint compañia
foreign key (idCompañiaFK)
references Compañia (idCompañia);

create table Involucra(
idInvolucra varchar(50) primary key,
idAutomovilKF varchar (50),
idAccidenteFK varchar (50)
);

alter table Involucra
add constraint automovil
foreign key (idAutomovilKF)
references Automovil (idAutomovil);


create table Accidente(
idAccidente varchar (50) primary key,
fechaAccidente date,
lugarAccidente varchar(50) not null,
heridosAccidente int not null,
fatalidades varchar (50) not null,
automores int not null
);

alter table Involucra
add constraint accidente
foreign key (idAccidenteFK)
references Accidente (idAccidente);
