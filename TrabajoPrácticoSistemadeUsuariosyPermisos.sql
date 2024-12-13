-- 1. Crear un usuario sin privilegios específicos

CREATE USER 'usuario_sin_privilegios'@'localhost' IDENTIFIED BY 'contraseña123';

-- 2. Crear un usuario con privilegios de lectura sobre la base pubs

CREATE USER 'lector_pubs'@'localhost' IDENTIFIED BY 'lectura123';

GRANT SELECT ON pubs.* TO 'lector_pubs'@'localhost';

-- 3. Crear un usuario con privilegios de escritura sobre la base pubs

CREATE USER 'escritor_pubs'@'localhost' IDENTIFIED BY 'escritura123';

GRANT INSERT, UPDATE, DELETE ON pubs.* TO 'escritor_pubs'@'localhost';
-- 4. Crear un usuario con todos los privilegios sobre la base pubs

CREATE USER 'admin_pubs'@'localhost' IDENTIFIED BY 'admin123';

GRANT ALL PRIVILEGES ON pubs.* TO 'admin_pubs'@'localhost';

-- 5. Crear un usuario con privilegios de lectura sobre la tabla titles

CREATE USER 'lector_titles'@'localhost' IDENTIFIED BY 'titulos123';

GRANT SELECT ON pubs.titles TO 'lector_titles'@'localhost';

-- 6. Eliminar al usuario que tiene todos los privilegios sobre la base pubs

DROP USER 'admin_pubs'@'localhost';

-- 7. Eliminar a dos usuarios a la vez

DROP USER 'lector_pubs'@'localhost', 'escritor_pubs'@'localhost';

-- 8. Eliminar un usuario y sus privilegios asociados

DROP USER 'usuario_sin_privilegios'@'localhost';

-- 9. Revisar los privilegios de un usuario

SHOW GRANTS FOR 'lector_titles'@'localhost';


