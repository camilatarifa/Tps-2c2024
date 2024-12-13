drop database Procedimientos_Almacenados;
create database Procedimientos_Almacenados;
use Procedimientos_Almacenados;

CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nota DECIMAL(4, 2) NOT NULL
);

-- Trigger 1: trigger_check_nota_before_insert
DELIMITER $$
CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.nota < 0 THEN
        SET NEW.nota = 0;
    ELSEIF NEW.nota > 10 THEN
        SET NEW.nota = 10;
    END IF;
END$$
DELIMITER ;

-- Trigger 2: trigger_check_nota_before_update
DELIMITER $$
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.nota < 0 THEN
        SET NEW.nota = 0;
    ELSEIF NEW.nota > 10 THEN
        SET NEW.nota = 10;
    END IF;
END$$
DELIMITER ;

INSERT INTO alumnos (nombre, apellido, nota) VALUES ('Carla', 'Saavedra', 9.5); 
INSERT INTO alumnos (nombre, apellido, nota) VALUES ('Jorge', 'López', -4.5); 
INSERT INTO alumnos (nombre, apellido, nota) VALUES ('Patricio', 'venezia', 9.8); 

SELECT * FROM alumnos;

-- Actualización con nota fuera del rango
UPDATE alumnos SET nota = -5 WHERE id = 3;
UPDATE alumnos SET nota = 15 WHERE id = 1; 
UPDATE alumnos SET nota = 9.5 WHERE id = 2; 

SELECT * FROM alumnos;