-- eliminar la base de datos si existe
drop database if exists usuario;
create database usuario;
use usuario;

-- ejercicio 1: crear una función para calcular la regalía total de cada autor.
create table autor (
    au_id int primary key,
    au_nombre varchar(50) not null,
    au_apellido varchar(50) not null,
    email varchar(100) unique not null
);

insert into autor (au_id, au_nombre, au_apellido, email) values
(1, 'gabriel', 'garcia marquez', 'gabriel@example.com'),
(2, 'isabel', 'allende', 'isabel@example.com'),
(3, 'jorge', 'luis borges', 'jorge@example.com'),
(4, 'mario', 'vargas llosa', 'mario@example.com'),
(5, 'julio', 'cortazar', 'julio@example.com');

create table titleauthor (
    title_id int,
    au_id int,
    royaltyper decimal(10,2),
    primary key (title_id, au_id),
    foreign key (au_id) references autor(au_id)
);

insert into titleauthor (title_id, au_id, royaltyper) values
(1, 1, 100.00),
(2, 1, 150.00),  
(3, 2, 200.00),  
(4, 3, 250.00); 

delimiter //

create function calcular_regalia_total(au_id int)
returns decimal(10,2)
begin
    declare total_regalia decimal(10,2);
    select sum(royaltyper) into total_regalia
    from titleauthor
    where au_id = au_id;
    return total_regalia;
end;
//
delimiter ;

select au_id, calcular_regalia_total(au_id) as regalía_total
from autor;

-- ejercicio 2: crear una función para obtener el precio máximo de cada tipo de libro.
create table libros (
    libro_id int primary key,
    titulo varchar(255) not null,
    tipo varchar(50) not null,
    precio decimal(10, 2) not null
);

insert into libros (libro_id, titulo, tipo, precio) values
(1, 'el amor en los tiempos del cólera', 'novela', 20.00),
(2, 'cien años de soledad', 'novela', 25.50),
(3, 'la casa de los espíritus', 'novela', 15.75),
(4, 'fundación', 'ciencia ficción', 30.00),
(5, 'el túnel', 'novela', 18.00);

delimiter //
create function obtener_precio_maximo(tipo_param varchar(50)) 
returns decimal(10, 2)
deterministic
begin
    declare precio_max decimal(10, 2);
    select max(precio) 
    into precio_max
    from libros
    where tipo = tipo_param;

    return ifnull(precio_max, 0);
end;
//
delimiter ;

select tipo, obtener_precio_maximo(tipo) as precio_maximo
from (select distinct tipo from libros) as tipos;

-- ejercicio 3: crear una función para calcular el ingreso (cantidad vendida multiplicada por el precio) de cada título.
create table ventas (
    venta_id int primary key,
    libro_id int,
    cantidad int,
    foreign key (libro_id) references libros(libro_id)
);

insert into ventas (venta_id, libro_id, cantidad) values
(1, 1, 10),  -- 10 copias del libro_id 1
(2, 2, 5),   -- 5 copias del libro_id 2
(3, 3, 8),   -- 8 copias del libro_id 3
(4, 4, 2),   -- 2 copias del libro_id 4
(5, 5, 12);  -- 12 copias del libro_id 5

delimiter //
create function calcular_ingreso(libro_id_param int)
returns decimal(10, 2)
begin
    declare ingreso_total decimal(10, 2);
    
    select sum(v.cantidad * l.precio) into ingreso_total
    from ventas v
    join libros l on v.libro_id = l.libro_id
    where v.libro_id = libro_id_param;

    return ifnull(ingreso_total, 0);
end;
//
delimiter ;

select l.libro_id, l.titulo, calcular_ingreso(l.libro_id) as ingreso_total
from libros l;

-- ejercicio 4: crear una función para obtener el nombre completo de un empleado a partir de su código.
create table empleados (
    empleados_codigo int primary key,
    empleados_nombre varchar(50) not null,
    empleados_apellido varchar(50) not null,
    email varchar(100) unique not null
);

insert into empleados (empleados_codigo, empleados_nombre, empleados_apellido, email) values
(1, 'juan', 'pérez', 'juan.perez@example.com'),
(2, 'ana', 'gómez', 'ana.gomez@example.com'),
(3, 'luis', 'martínez', 'luis.martinez@example.com'),
(4, 'maría', 'lópez', 'maria.lopez@example.com'),
(5, 'carlos', 'sánchez', 'carlos.sanchez@example.com');

delimiter //
create function obtener_nombre_completo(emp_codigo_param int)
returns varchar(100)
begin
    declare nombre_completo varchar(100);
    
    select concat(empleados_nombre, ' ', empleados_apellido) into nombre_completo
    from empleados
    where empleados_codigo = emp_codigo_param;

    return ifnull(nombre_completo, 'empleado no encontrado');
end;
//
delimiter ;

select empleados_codigo, obtener_nombre_completo(empleados_codigo) as nombre_completo
from empleados;

-- ejercicio 5: crear una función para calcular el precio promedio de libros publicados de cada editorial.
drop table if exists libros;

create table editoriales (
    editorial_id int primary key,
    nombre varchar(100) not null
);

insert into editoriales (editorial_id, nombre) values
(1, 'editorial a'),
(2, 'editorial b'),
(3, 'editorial c');

create table libros (
    libro_id int primary key,
    titulo varchar(255) not null,
    tipo varchar(50) not null,
    precio decimal(10, 2) not null,
    editorial_id int,
    foreign key (editorial_id) references editoriales(editorial_id)
);

insert into libros (libro_id, titulo, tipo, precio, editorial_id) values
(1, 'el amor en los tiempos del cólera', 'novela', 20.00, 1),
(2, 'cien años de soledad', 'novela', 25.50, 1),
(3, 'la casa de los espíritus', 'novela', 15.75, 2),
(4, 'fundación', 'ciencia ficción', 30.00, 3),
(5, 'el túnel', 'novela', 18.00, 2),
(6, '1984', 'ciencia ficción', 22.00, 1),
(7, 'el principito', 'infantil', 15.00, 2),
(8, 'rayuela', 'novela', 17.00, 2),
(9, 'sapiens: de animales a dioses', 'no ficción', 30.00, 3);

delimiter //
create function calcular_precio_promedio(editorial_id_param int)
returns decimal(10, 2)
begin
    declare precio_promedio decimal(10, 2);
    
    select avg(precio) into precio_promedio
    from libros
    where editorial_id = editorial_id_param;

    return ifnull(precio_promedio, 0);
end;
//
delimiter ;

select e.editorial_id, e.nombre, calcular_precio_promedio(e.editorial_id) as precio_promedio
from editoriales e;