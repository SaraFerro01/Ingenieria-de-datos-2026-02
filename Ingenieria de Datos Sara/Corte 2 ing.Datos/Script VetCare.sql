create database veterinaria;
use veterinaria;

create table cliente(
idCliente varchar(50) primary key,
nombreCompleto varchar(100) not null,
telefono varchar(20) not null,
correo varchar(100) not null,
direccion varchar(100) not null
);

create table sede(
idSede varchar(50) primary key,
nombreSede varchar(100) not null,
ubicacionSede varchar(150) not null,
horarioAtencion varchar(100) not null
);

create table veterinario(
idVeterinario varchar(50) primary key,
especialidad varchar(100) not null,
horarioTrabajo varchar(100) not null
);

create table mascota(
idMascota varchar(50) primary key,
nombreMascota varchar(100) not null,
especie varchar(50) not null,
raza varchar(50) not null,
fechaNacimiento date not null,
sexo varchar(20) not null,
peso decimal(6,2) not null,
idClienteFK varchar(50),
numeroMicrochip varchar(50) not null
);

alter table mascota
add constraint fk_mascota_cliente
foreign key (idClienteFK)
references cliente(idCliente);

create table cita(
idCita varchar(50) primary key,
motivo varchar(200) not null,
fecha date not null,
idClienteFK varchar(50),
hora time not null
);

alter table cita
add constraint fk_cita_cliente
foreign key (idClienteFK)
references cliente(idCliente);

alter table cita
add idMascotaFK varchar(50),
add idSedeFK varchar(50),
add idVeterinarioFK varchar(50);

alter table cita
add constraint fk_cita_mascota
foreign key (idMascotaFK)
references mascota(idMascota);

alter table cita
add constraint fk_cita_sede
foreign key (idSedeFK)
references sede(idSede);

alter table cita
add constraint fk_cita_veterinario
foreign key (idVeterinarioFK)
references veterinario(idVeterinario);

create table consulta(
idConsulta varchar(50) primary key,
sintomas varchar(500) not null,
diagnostico varchar(500) not null,
indicaciones varchar(500) not null,
idCitaFK varchar(50) unique 
);

alter table consulta
add constraint fk_consulta_cita
foreign key (idCitaFK)
references cita(idCita);


create table medicamento(
idMedicamento varchar(50) primary key,
nombreMedicamento varchar(100) not null,
descripcionMedicamento varchar(300) not null
);

create table inventario(
idInventario varchar(50) primary key,
cantidadDisponible int not null,
lote varchar(50) not null,
fechaVencimiento date not null
);

alter table inventario
add idSedeFK varchar(50),
add idMedicamentoFK varchar(50)
;

alter table inventario
add constraint fk_inventario_sede
foreign key (idSedeFK)
references sede(idSede);

alter table inventario
add constraint fk_inventario_medicamento
foreign key (idMedicamentoFK)
references medicamento(idMedicamento);

create table prescripcion(
idPrescripcion varchar(50) primary key,
dosis varchar(100) not null,
frecuencia varchar(100) not null,
duracion varchar(100) not null,
idConsultaFK varchar(50),
idMedicamentoFK varchar(50)
);

alter table prescripcion
add constraint fk_prescripcion_consulta
foreign key (idConsultaFK)
references consulta(idConsulta);

alter table prescripcion
add constraint fk_prescripcion_medicamento
foreign key (idMedicamentoFK)
references medicamento(idMedicamento);

create table hospitalizacion(
idHospitalizacion varchar(50) primary key,
fechaIngreso date not null,
fechaSalida date,
notasEvolucion varchar(500),
jaula varchar(50),
idMascotaFK varchar(50)
);

alter table hospitalizacion
add constraint fk_hospitalizacion_mascota
foreign key (idMascotaFK)
references mascota(idMascota);

create table factura(
idFactura varchar(50) primary key,
fecha date not null,
total decimal(12,2) not null,
estadoPago varchar(30) not null,
idClienteFK varchar(50),
idConsultaFK varchar(50) unique 
);

alter table factura
add constraint fk_factura_cliente
foreign key (idClienteFK)
references cliente(idCliente);

alter table factura
add constraint fk_factura_consulta
foreign key (idConsultaFK)
references consulta(idConsulta);
