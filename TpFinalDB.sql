create database final;
drop database final;
use final;
-- Ejercicio 6
CREATE TABLE fabricantes (
    id_fabricante INT PRIMARY KEY,
    nombre_fabricante VARCHAR(255) NOT NULL
);

INSERT INTO fabricantes (id_fabricante, nombre_fabricante)
VALUES(1, 'Fabricante A'),(2, 'Fabricante B'),(3, 'Fabricante C');

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    id_fabricante INT,
    nombre_producto VARCHAR(255) NOT NULL,
    fecha_lanzamiento DATE,
    FOREIGN KEY (id_fabricante) REFERENCES fabricantes(id_fabricante)
);

INSERT INTO productos (id_producto, id_fabricante, nombre_producto, fecha_lanzamiento)
VALUES(1, 1, 'Producto X', '2020-01-01'),(2, 2, 'Producto Y', '2019-12-01'), (3, 3, 'Producto Z', '2021-05-15'); 

-- 6 a)Crear un índice compuesto en las columnas id_fabricante y nombre_producto de la tabla productos.
create index idx_productos_id_fabricante_nombre  on productos (id_fabricante, nombre_producto);
show index from productos;
-- b) Crear un índice único en la columna id_producto de la tabla productos.
create index id_producto on productos (id_producto);

-- c) Modificar el índice idx_productos_id_fabricante_nombre para que sea  único en la columna id_fabricante.
create index idx_productos_id_fabricante_nombre on ;


