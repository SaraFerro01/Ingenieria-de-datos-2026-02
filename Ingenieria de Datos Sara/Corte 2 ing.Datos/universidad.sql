
create database if not exists universidad;

use universidad;

create table facultad (
    num_bloque int not null,
    nombre varchar(100) not null,
    ubicacion varchar(150) not null,
    primary key (num_bloque)
);

create table decano (
    cedula varchar(20) not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    celular varchar(20),
    num_bloque int not null,
    primary key (cedula),
    unique (num_bloque),
    foreign key (num_bloque) references facultad (num_bloque)
        on update cascade
        on delete restrict
);

create table docente (
    cedula varchar(20) not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    titulo varchar(150) not null,
    num_bloque int not null,
    primary key (cedula),
    foreign key (num_bloque) references facultad (num_bloque)
        on update cascade
        on delete restrict
);

create table asignatura (
    codigo varchar(20) not null,
    nombre varchar(100) not null,
    creditos int not null,
    primary key (codigo)
);

create table docente_asignatura (
    cedula_docente varchar(20) not null,
    codigo_asignatura varchar(20) not null,
    primary key (cedula_docente, codigo_asignatura),
    foreign key (cedula_docente) references docente (cedula)
        on update cascade
        on delete cascade,
    foreign key (codigo_asignatura) references asignatura (codigo)
        on update cascade
        on delete cascade
);

create table estudiante (
    identificacion varchar(20) not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    direccion varchar(150) not null,
    primary key (identificacion)
);

create table inscripcion (
    identificacion_estudiante varchar(20) not null,
    codigo_asignatura varchar(20) not null,
    semestre varchar(20) not null,
    anio int not null,

    primary key (
        identificacion_estudiante,
        codigo_asignatura,
        semestre,
        anio
    ),

    foreign key (identificacion_estudiante)
        references estudiante (identificacion)
        on update cascade
        on delete cascade,

    foreign key (codigo_asignatura)
        references asignatura (codigo)
        on update cascade
        on delete cascade
);

insert into facultad (
    num_bloque,
    nombre,
    ubicacion
) values
(1, 'ingeniería', 'sede norte, bloque a'),
(2, 'ciencias económicas', 'sede centro, bloque b'),
(3, 'ciencias de la salud', 'sede sur, bloque c');


insert into decano (
    cedula,
    nombre,
    apellido,
    celular,
    num_bloque
) values
('1001001001', 'carlos', 'ramírez', '3001111111', 1),
('1002002002', 'laura', 'gómez', '3002222222', 2),
('1003003003', 'andrés', 'martínez', '3003333333', 3);

insert into docente (
    cedula,
    nombre,
    apellido,
    titulo,
    num_bloque
) values
('1010101010', 'juan', 'perez', 'ingeniero de sistemas', 1),
('1020202020', 'ana', 'gomez', 'ingeniera industrial', 1),
('1030303030', 'carlos', 'lopez', 'economista', 2),
('1040404040', 'diana', 'torres', 'ingeniera ambiental', 1);

insert into asignatura (
    codigo,
    nombre,
    creditos
) values
('mat101', 'matematicas', 3),
('prog101', 'programacion', 4),
('fis101', 'fisica', 3),
('eco101', 'economia', 3);

insert into docente_asignatura (
    cedula_docente,
    codigo_asignatura
) values
('1010101010', 'mat101'),
('1010101010', 'prog101'),
('1020202020', 'prog101'),
('1040404040', 'fis101'),
('1030303030', 'eco101');

insert into estudiante (
    identificacion,
    nombres,
    apellidos,
    direccion
) values
('2001001001', 'maria', 'rodriguez', 'calle 10 # 20-30'),
('2002002002', 'pedro', 'martinez', 'carrera 15 # 30-40'),
('2003003003', 'sofia', 'hernandez', 'calle 50 # 10-20'),
('2004004004', 'daniel', 'lopez', 'carrera 7 # 80-10');

insert into inscripcion (
    identificacion_estudiante,
    codigo_asignatura,
    semestre,
    anio
) values
('2001001001', 'mat101', '1', 2026),
('2001001001', 'prog101', '1', 2026),
('2002002002', 'prog101', '1', 2026),
('2002002002', 'fis101', '1', 2026),
('2003003003', 'eco101', '1', 2026),
('2003003003', 'mat101', '1', 2026),
('2004004004', 'prog101', '1', 2026);

create or replace view vista_docentes_facultad as
select d.cedula,
       d.nombre,
       d.apellido,
       d.titulo,
       f.nombre as facultad,
       f.ubicacion
from docente d
inner join facultad f
    on d.num_bloque = f.num_bloque;

create or replace view vista_total_docentes_por_facultad as
select f.num_bloque,
       f.nombre as facultad,
       count(d.cedula) as total_docentes
from facultad f
left join docente d
    on f.num_bloque = d.num_bloque
group by f.num_bloque, f.nombre;

delimiter //


create procedure registrar_facultad(
    in p_num_bloque int,
    in p_nombre varchar(100),
    in p_ubicacion varchar(150)
)
begin
    insert into facultad (
        num_bloque,
        nombre,
        ubicacion
    )
    values (
        p_num_bloque,
        p_nombre,
        p_ubicacion
    );
end //

create procedure registrar_docente(
    in p_cedula varchar(20),
    in p_nombre varchar(50),
    in p_apellido varchar(50),
    in p_titulo varchar(150),
    in p_num_bloque int
)
begin
    insert into docente (
        cedula,
        nombre,
        apellido,
        titulo,
        num_bloque
    )
    values (
        p_cedula,
        p_nombre,
        p_apellido,
        p_titulo,
        p_num_bloque
    );
end //


create procedure docentes_por_facultad(
    in p_num_bloque int
)
begin
    select d.cedula,
           d.nombre,
           d.apellido,
           d.titulo,
           f.nombre as facultad
    from docente d
    inner join facultad f
        on d.num_bloque = f.num_bloque
    where d.num_bloque = p_num_bloque;
end //

create procedure actualizar_ubicacion_facultad(
    in p_num_bloque int,
    in p_ubicacion varchar(150)
)
begin
    update facultad
    set ubicacion = p_ubicacion
    where num_bloque = p_num_bloque;
end //


delimiter ;



select * from vista_docentes_facultad;

select * from vista_total_docentes_por_facultad;



call registrar_facultad(
    4,
    'derecho',
    'sede centro, bloque d'
);


call registrar_docente(
    '1050505050',
    'paula',
    'torres',
    'abogada',
    4
);


call docentes_por_facultad(1);


call actualizar_ubicacion_facultad(
    2,
    'sede centro, bloque e'
);


select * from vista_docentes_facultad;

select * from vista_total_docentes_por_facultad;



 
