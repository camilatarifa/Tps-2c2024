-- eliminar la base de datos si existe
drop database if exists transacciones;
create database transacciones;
use transacciones;

-- Ejercicio 1: Transferencia de fondos

create table cuentas (
    numero_cuenta varchar(10) primary key,
    saldo decimal(10, 2)
);

insert into cuentas (numero_cuenta, saldo) values
    ('a', 1000.00),
    ('b', 750.00),
    ('c', 1200.00),
    ('d', 500.00),
    ('e', 2000.00);

select * from cuentas;

start transaction;

update cuentas set saldo = saldo - 100 where numero_cuenta = 'a';

update cuentas set saldo = saldo + 100 where numero_cuenta = 'b';

-- confirmar transacción
commit;

select * from cuentas;

-- ejercicio 2: procedimiento actualizarinventario

create table inventario (
    producto_id varchar(10) primary key,
    cantidad int
);


insert into inventario (producto_id, cantidad) values
    ('producto1', 50),
    ('producto2', 30),
    ('producto3', 70),
    ('producto4', 20),
    ('producto5', 60);

select * from inventario;

delimiter //

create procedure actualizarinventario (
    in p_producto_id varchar(10),
    in cantidad_a_restar int
)
begin
    declare nueva_cantidad int;

    start transaction;

    select cantidad into nueva_cantidad from inventario where producto_id = p_producto_id;

    if nueva_cantidad - cantidad_a_restar >= 0 then
    
        update inventario set cantidad = nueva_cantidad - cantidad_a_restar where producto_id = p_producto_id;
        commit;
    else
        select 'la cantidad restada resultaría en un inventario negativo. operación cancelada.';
        rollback;
    end if;
end;
//
delimiter ;

-- llamar al procedimiento
call actualizarinventario('producto1', 15); 
call actualizarinventario('producto1', 1500); 

select * from inventario;

-- ejercicio 3: procedimiento registrarcompra

create table cuentas_clientes (
    numero_cuenta varchar(10) primary key,
    saldo decimal(10, 2)
);

create table transacciones (
    id int auto_increment primary key,
    numero_cuenta varchar(10),
    monto decimal(10, 2)
);

insert into cuentas_clientes (numero_cuenta, saldo) values
    ('cuenta1', 1000.00),
    ('cuenta2', 750.00),
    ('cuenta3', 1200.00),
    ('cuenta4', 500.00),
    ('cuenta5', 2000.00);

select * from cuentas_clientes;

delimiter //

create procedure registrarcompra (
    in cuenta varchar(10),
    in monto decimal(10, 2)
)
begin
    declare saldo_actual decimal(10, 2);

    start transaction;

    select saldo into saldo_actual from cuentas_clientes where numero_cuenta = cuenta;

    if saldo_actual >= monto then

        update cuentas_clientes set saldo = saldo_actual - monto where numero_cuenta = cuenta;
        insert into transacciones (numero_cuenta, monto) values (cuenta, monto);
        commit;
    else
        select 'saldo insuficiente. operación cancelada.';
        rollback;
    end if;
end;
//
delimiter ;

call registrarcompra('cuenta1', 300.00); 
call registrarcompra('cuenta2', 800.00); 

select * from cuentas_clientes;
select * from transacciones;