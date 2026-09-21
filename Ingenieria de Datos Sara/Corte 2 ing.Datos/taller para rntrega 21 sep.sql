

CREATE DATABASE techcorp;
USE techcorp;



CREATE TABLE departamento(
    idDepartamento INT AUTO_INCREMENT PRIMARY KEY,
    nombreDepartamento VARCHAR(100) NOT NULL
);



CREATE TABLE empleado(
    idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    nombreEmpleado VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    fechaContratacion DATE NOT NULL,
    idDepartamentoFK INT,
    
    CONSTRAINT fk_empleado_departamento
    FOREIGN KEY (idDepartamentoFK)
    REFERENCES departamento(idDepartamento)
);




INSERT INTO departamento(nombreDepartamento)
VALUES
('Ventas'),
('IT'),
('Recursos Humanos'),
('Marketing'),
('Finanzas');




INSERT INTO empleado
(nombreEmpleado, edad, salario, fechaContratacion, idDepartamentoFK)
VALUES
('Ana Torres', 28, 3500.00, '2021-03-15', 1),
('Carlos Ramirez', 35, 4800.00, '2019-07-10', 2),
('Andres Martinez', 42, 5200.00, '2018-01-20', 1),
('Camila Rodriguez', 31, 4100.00, '2022-05-12', 3),
('Juan Perez', 29, 3900.00, '2023-02-01', 2),
('Laura Gomez', 36, 4500.00, '2020-08-17', 4),
('Pedro Sanchez', 40, 4300.00, '2017-11-25', 5),
('Carolina Vargas', 33, 4700.00, '2021-09-05', 1),
('Miguel Hernandez', 27, 3200.00, '2024-01-15', 2),
('Alejandra Castro', 38, 5500.00, '2019-04-22', 3);




SELECT 
    nombreEmpleado,
    edad,
    salario
FROM empleado;




SELECT
    nombreEmpleado,
    salario
FROM empleado
WHERE salario > 4000;



SELECT
    e.nombreEmpleado,
    d.nombreDepartamento
FROM empleado e
INNER JOIN departamento d
ON e.idDepartamentoFK = d.idDepartamento
WHERE d.nombreDepartamento = 'Ventas';



SELECT
    nombreEmpleado,
    edad
FROM empleado
WHERE edad BETWEEN 30 AND 40;



SELECT
    nombreEmpleado,
    fechaContratacion
FROM empleado
WHERE fechaContratacion > '2020-12-31';




SELECT
    d.nombreDepartamento,
    COUNT(e.idEmpleado) AS cantidadEmpleados
FROM departamento d
LEFT JOIN empleado e
ON d.idDepartamento = e.idDepartamentoFK
GROUP BY d.idDepartamento, d.nombreDepartamento;




SELECT
    AVG(salario) AS salarioPromedio
FROM empleado;




SELECT
    nombreEmpleado
FROM empleado
WHERE nombreEmpleado LIKE 'A%'
   OR nombreEmpleado LIKE 'C%';




SELECT
    e.nombreEmpleado,
    d.nombreDepartamento
FROM empleado e
INNER JOIN departamento d
ON e.idDepartamentoFK = d.idDepartamento
WHERE d.nombreDepartamento <> 'IT';




SELECT
    nombreEmpleado,
    salario
FROM empleado
WHERE salario = (
    SELECT MAX(salario)
    FROM empleado
);