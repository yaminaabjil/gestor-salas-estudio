
# Fichero para la solución del Caso Práctico de "Bases de datos" de 2026

-- Si existe, borrar la base de datos ReservasSalas:

DROP DATABASE IF EXISTS ReservasSalas2026;

-- Crear la base de datos ReservasSalas:

CREATE DATABASE IF NOT EXISTS ReservasSalas2026;

-- Usar la base de datos ReservasSalas: 

USE ReservasSalas2026;

-- Si las tablas ya existen, las borramos en el orden inverso a sus dependencias
DROP TABLE IF EXISTS Incidencias;
DROP TABLE IF EXISTS Reservas;
DROP TABLE IF EXISTS Salas;
DROP TABLE IF EXISTS Estudiantes;

#################################################################################################
#    Crear el esquema de la base de datos con las tablas que se extraen 
#    del enunciado del problema.
#################################################################################################
# Apartado 1: Crear la tabla Estudiantes
#################################################################################################


CREATE TABLE Estudiantes (
	dni char(9) not null,
    apellidos varchar(70) not null,
    nombre varchar (59) not null,
    grado enum ('Matematicas', 'Informatica', 'Fisica', 'Ciencia de Datos', 'Telecomunicaciones') not null,
    email varchar(100) not null,
    primary key (dni)
);
 
 
 
#################################################################################################
# Apartado 2: Crear la tabla Salas
#################################################################################################


create table Salas (
	id_sala varchar(10) not null,
    ubicacion enum ('Planta Baja', 'Planta 1', 'Planta 2', 'Edificio Anexo') not null,
    capacidad int not null,
    tiene_proyector boolean not null,
    primary key (id_sala),
    check (capacidad > 0)
    );
    



#################################################################################################
# Apartado 3: Crear la tabla Reservas
#################################################################################################



create table Reservas (
	id_reserva int not null auto_increment,
    fecha date not null,
    turno enum ('Mañana', 'Tarde') not null, 
    dni_estudiante char (9) not null,
    id_sala varchar(10) not null,
    asistio boolean,
    estado enum ('Confirmada', 'Cancelada') not null,
    primary key (id_reserva),
    foreign key (dni_estudiante) references Estudiantes(dni) on delete restrict on update cascade,
    foreign key (id_sala) references Salas(id_sala) on delete restrict on update cascade,
    unique (dni_estudiante, fecha, turno)
    );



#################################################################################################
# Apartado 4: Crear la tabla Incidencias
#################################################################################################


create table Incidencias (
id_incidencia int not null auto_increment,
id_reserva int not null,
fecha_registro date not null,
tipo_incidencia enum('Ruido', 'Material roto', 'Incumplimiento de normas', 'Otro') not null,
estado_resolucion enum('Abierta', 'En proceso', 'Resuelta') not null,
descripcion text,
primary key (id_incidencia),
foreign key (id_reserva) references Reservas(id_reserva) on delete cascade 
);



################################################################################################
# Poblar las cuatro tablas creadas con los datos proporcionados en los comandos siguientes
# Considerando fecha actual: 13 de abril de 2026
#################################################################################################

-- ESTUDIANTES
-- =========================================== 
INSERT INTO Estudiantes (dni, apellidos, nombre, grado, email) VALUES
('11111111A', 'García Pérez', 'Laura', 'Informática', 'laura.garcia@universidad.edu'),
('22222222B', 'López Gómez', 'Carlos', 'Matemáticas', 'carlos.lopez@universidad.edu'),
('33333333C', 'Sánchez Ruiz', 'Ana', 'Física', 'ana.sanchez@universidad.edu'),
('44444444D', 'Martín Díaz', 'Javier', 'Ciencia de Datos', 'javier.martin@universidad.edu'),
('55555555E', 'Ruiz Alonso', 'Marta', 'Telecomunicaciones', 'marta.ruiz@universidad.edu'),
('66666666F', 'Navarro Torres', 'David', 'Informática', 'david.navarro@universidad.edu'),
('77777777G', 'Romero Sanz', 'Elena', 'Informática', 'elena.romero@universidad.edu'),
('88888888H', 'Ramírez Gil', 'Pablo', 'Matemáticas', 'pablo.ramirez@universidad.edu'),
('99999999I', 'Torres Mora', 'Lucía', 'Ciencia de Datos', 'lucia.torres@universidad.edu'),
('10101010J', 'Gil Castro', 'Sergio', 'Física', 'sergio.gil@universidad.edu');


-- SALAS
-- =========================================== 
INSERT INTO Salas (id_sala, ubicacion, capacidad, tiene_proyector) VALUES
('A1', 'Planta Baja', 6, TRUE),
('B2', 'Planta 1', 8, FALSE),
('C3', 'Planta 2', 10, TRUE),
('D4', 'Edificio Anexo', 4, FALSE);

-- RESERVAS
-- =========================================== 
INSERT INTO Reservas (fecha, turno, dni_estudiante, id_sala, asistio, estado) VALUES
-- --- BLOQUE 1: RESERVAS PASADAS (1 al 12 de abril) - Necesarias para incidencias y asistencia ---
('2026-04-05', 'Mañana', '11111111A', 'A1', TRUE, 'confirmada'),  -- ID 1
('2026-04-05', 'Tarde',  '22222222B', 'B2', FALSE, 'confirmada'), -- ID 2 (No show)
('2026-04-06', 'Mañana', '33333333C', 'C3', TRUE, 'confirmada'),  -- ID 3 (Tendrá varias incidencias)
('2026-04-06', 'Mañana', '44444444D', 'C3', TRUE, 'confirmada'),  -- ID 4
('2026-04-07', 'Tarde',  '55555555E', 'D4', TRUE, 'confirmada'),  -- ID 5 (Problema de material)
('2026-04-08', 'Mañana', '66666666F', 'A1', FALSE, 'cancelada'),  -- ID 6 (Cancelada a tiempo)
('2026-04-09', 'Tarde',  '77777777G', 'B2', TRUE, 'confirmada'),  -- ID 7
('2026-04-10', 'Mañana', '88888888H', 'C3', FALSE, 'confirmada'), -- ID 8 (No show)
('2026-04-11', 'Tarde',  '99999999I', 'D4', TRUE, 'confirmada'),  -- ID 9
('2026-04-12', 'Mañana', '10101010J', 'A1', TRUE, 'confirmada'),  -- ID 10

-- --- BLOQUE 2: RESERVAS FUTURAS (13 de abril al 13 de mayo) - Asistencia NULL ---
-- Escenario A: Estudiante (Marta, 55555555E) al límite de 3 reservas pendientes
('2026-04-14', 'Mañana', '55555555E', 'C3', NULL, 'confirmada'),
('2026-04-20', 'Tarde',  '55555555E', 'A1', NULL, 'confirmada'),
('2026-04-25', 'Mañana', '55555555E', 'B2', NULL, 'confirmada'),

-- Escenario B: Sala D4 LLENA (Capacidad 4) el 15 de abril por la Tarde
('2026-04-15', 'Tarde',  '11111111A', 'D4', NULL, 'confirmada'),
('2026-04-15', 'Tarde',  '22222222B', 'D4', NULL, 'confirmada'),
('2026-04-15', 'Tarde',  '33333333C', 'D4', NULL, 'confirmada'),
('2026-04-15', 'Tarde',  '44444444D', 'D4', NULL, 'confirmada'),

-- Escenario C: Reservas canceladas en el futuro (No suman para el límite de 3)
('2026-04-16', 'Mañana', '88888888H', 'B2', NULL, 'cancelada'),
('2026-05-01', 'Tarde',  '99999999I', 'C3', NULL, 'cancelada'), -- Cancelación 1 de C3
('2026-04-21', 'Mañana', '11111111A', 'C3', NULL, 'cancelada'), -- Cancelación 2 de C3
('2026-04-24', 'Tarde',  '22222222B', 'C3', NULL, 'cancelada'), -- Cancelación 3 de C3

-- Escenario D: Doble turno en el mismo día (Sergio, 10101010J)
('2026-04-18', 'Mañana', '10101010J', 'A1', NULL, 'confirmada'),
('2026-04-18', 'Tarde',  '10101010J', 'A1', NULL, 'confirmada'),

-- Relleno de reservas variadas repartidas por el mes
('2026-04-22', 'Mañana', '77777777G', 'A1', NULL, 'confirmada'),
('2026-04-22', 'Mañana', '88888888H', 'A1', NULL, 'confirmada'),
('2026-04-23', 'Tarde',  '11111111A', 'B2', NULL, 'confirmada'),
('2026-04-26', 'Mañana', '66666666F', 'C3', NULL, 'confirmada'),
('2026-04-28', 'Tarde',  '99999999I', 'B2', NULL, 'confirmada'),
('2026-04-30', 'Mañana', '10101010J', 'C3', NULL, 'confirmada'),
('2026-05-02', 'Tarde',  '22222222B', 'D4', NULL, 'confirmada'),
('2026-05-05', 'Mañana', '33333333C', 'A1', NULL, 'confirmada'),
('2026-05-08', 'Tarde',  '44444444D', 'B2', NULL, 'confirmada'),
('2026-05-10', 'Mañana', '77777777G', 'C3', NULL, 'confirmada'),

-- Escenario E: El límite exacto de 1 mes (13 de mayo)
('2026-05-13', 'Mañana', '66666666F', 'D4', NULL, 'confirmada'),
('2026-05-13', 'Tarde',  '77777777G', 'A1', NULL, 'confirmada');

-- INCIDENCIAS
-- =========================================== 
INSERT INTO Incidencias (id_reserva, fecha_registro, tipo_incidencia, estado_resolucion, descripcion) VALUES
-- Asociada a la reserva 2 (Carlos, no asistió)
(2, '2026-04-05', 'Incumplimiento de normas', 'Resuelta', 'El estudiante no se presentó y no canceló su reserva.'),

-- Asociadas a la reserva 3 (Ana, Sala C3). Doble incidencia para el mismo estudiante.
(3, '2026-04-06', 'Ruido', 'Resuelta', 'Grupo excesivamente ruidoso. Se les tuvo que llamar la atención.'),
(3, '2026-04-06', 'Material roto', 'Abierta', 'Dejaron una silla con el respaldo partido al salir de la sala.'),

-- Asociada a la reserva 5 (Marta, Sala D4)
(5, '2026-04-07', 'Otro', 'En proceso', 'El aire acondicionado de la sala no funcionaba bien y goteaba.'),

-- Asociada a la reserva 8 (Pablo, no asistió)
(8, '2026-04-10', 'Incumplimiento de normas', 'Resuelta', 'Reserva confirmada pero la sala estuvo vacía todo el turno.'),

-- Asociada a la reserva 9 (Lucía, Sala D4)
(9, '2026-04-11', 'Ruido', 'En proceso', 'Quejas de los estudiantes de la sala contigua por música alta.');

################################################################################################# 
# Apartado 5: CONSULTA 

# Obtener el DNI, los apellidos y el nombre de los estudiantes que han realizado al menos una 
# reserva que se encuentre en estado 'cancelada'. 
# El resultado no debe contener filas duplicadas y debe estar ordenado alfabéticamente 
# por los apellidos.
# Salida: (dni, apellidos, nombre)
#################################################################################################


select distinct e.dni, e.apellidos, e.nombre
from Estudiantes e
join Reservas r on e.dni = r.dni_estudiante
where r.estado = 'Cancelada'
order by e.apellidos;


################################################################################################# 
# Apartado 6: CONSULTA 

# Listar el identificador de la sala y su capacidad para aquellas salas que estén ubicadas en la 
# 'Planta Baja' o en la 'Planta 1', y que además dispongan de proyector.
# El resultado debe mostrarse ordenado de mayor a menor capacidad.
# Salida: (id_sala, capacidad)
#################################################################################################


select id_sala, capacidad
from Salas
where (ubicacion ='Planta Baja' or ubicacion='Planta 1')
and tiene_proyector=true
order by capacidad desc;


################################################################################################# 
# Apartado 7: CONSULTA 

# Mostrar la fecha, el turno y la sala reservada de todas las reservas asociadas al estudiante 
# con DNI '55555555E' cuya asistencia esté aún pendiente de comprobación (es decir, que no 
# se haya marcado ni como verdadera ni como falsa).
# Ordenar los resultados cronológicamente (desde la fecha más antigua a la más reciente).
# Salida: (fecha, turno, id_sala)
#################################################################################################


select fecha, turno, id_sala 
from Reservas 
where dni_estudiante = '55555555E'
and asistio is null
order by fecha asc;


    
################################################################################################# 
# Apartado 8: CONSULTA 

# Para cada sala que haya registrado alguna reserva en estado 'cancelada', mostrar el  
# identificador de la sala y el número total de reservas canceladas que tiene asociadas.
# El resultado debe mostrarse ordenado de mayor a menor número de cancelaciones, y en 
# caso de empate, alfabéticamente por el identificador de la sala.
# Salida: (id_sala, total_canceladas)
#################################################################################################

select id_sala, count(*)  as total_canceladas
from Reservas
where estado ='Cancelada'
group by id_sala 
order by total_canceladas desc, id_sala asc;


################################################################################################# 
# Apartado 9: CONSULTA 

# Se desea identificar a los estudiantes que tienen un volumen considerable de reservas 
# planificadas. Obtener el DNI, los apellidos y el número total de reservas asociadas a 
# aquellos estudiantes que tengan 2 o más reservas confirmadas y cuya asistencia esté 
# pendiente de comprobación (valor nulo).
# El resultado debe mostrarse ordenado de mayor a menor número de reservas pendientes y, 
# en caso de empate, alfabéticamente por los apellidos del estudiante.
# Salida: (dni, apellidos, reservas_pendientes)
#################################################################################################


select e.dni, e.apellidos, count(*) reservas_pendientes
from Estudiantes e 
join Reservas r on e.dni = r.dni_estudiante
where r.estado ='Confirmada'
and r.asistio is null
group by e.dni, e.apellidos 
HAVING reservas_pendientes >= 2
order by reservas_pendientes desc, e.apellidos asc;


################################################################################################# 
# Apartado 10: CONSULTA 

# Analizar la ocupación de la biblioteca por turnos. 
# Mostrar la fecha, el turno y el total de plazas reservadas (sumando la capacidad de las 
# salas reservadas) para aquellos turnos en los que la suma total de plazas reservadas 
# supere estrictamente las 15 plazas. Se deben considerar únicamente las reservas confirmadas.
# El resultado debe ordenarse cronológicamente por fecha y turno (Mañana primero, Tarde después).
# Salida: (fecha, turno, total_plazas_reservadas)
#################################################################################################


select r.fecha, r.turno, sum(s.capacidad) as total_plazas_reservadas
from Reservas r
join Salas s on r.id_sala = s.id_sala
where r.estado = 'Confirmada'
group by r.fecha, r.turno
having sum(s.capacidad) > 15
order by r.fecha asc, r.turno asc;

    
################################################################################################# 
# Apartado 11: CONSULTA 

# Obtener el DNI, los apellidos y el nombre de los estudiantes que NUNCA han realizado 
# una reserva para una sala ubicada en el 'Edificio Anexo' (independientemente del estado 
# de la reserva). 
# Es OBLIGATORIO resolver esta consulta empleando una subconsulta y el operador de 
# pertenencia a conjuntos NOT IN.
# El resultado debe ordenarse alfabéticamente por los apellidos del estudiante.
# Salida: (dni, apellidos, nombre)
#################################################################################################


select dni, apellidos, nombre
from Estudiantes 
where dni not in (
	select r.dni_estudiante 
    from Reservas r
    join Salas s on r.id_sala= s.id_sala
    where s.ubicacion = 'Edificio Anexo'
)
order by apellidos;


################################################################################################# 
# Apartado 12: CONSULTA 

# Determinar qué sala (o salas, en caso de empate) es la más solicitada históricamente.
# Obtener el identificador de la sala y el número total de reservas asociadas a aquellas 
# salas que tengan el MAYOR número total de reservas (contando tanto confirmadas como 
# canceladas). 
# Es OBLIGATORIO resolver esta consulta empleando una subconsulta y el operador de 
# comparación ALL.
# Salida: (id_sala, total_reservas)
#################################################################################################


select id_sala, count(*) as total_reservas
from Reservas 
group by id_sala
having count(*) >= all (
	select count(*) 
    from Reservas 
    group by id_sala
);

################################################################################################# 
# Apartado 13: CONSULTA 

# Analizar las incidencias provocadas por los estudiantes de un grado específico.
# Obtener la fecha de registro y la descripción de las incidencias asociadas a reservas 
# realizadas por estudiantes que cursan el grado de 'Física'.
# Es OBLIGATORIO resolver esta consulta empleando subconsultas anidadas y el operador IN. 
# Queda totalmente PROHIBIDO el uso de cláusulas JOIN (es decir, cada cláusula FROM, 
# tanto en la consulta principal como en las subconsultas, debe referenciar a una única tabla).
# Salida: (fecha_registro, descripcion)
#################################################################################################

select fecha_registro, descripcion 
from Incidencias 
where id_reserva in(
	select id_reserva 
    from Reservas
    where dni_estudiante in(
		select dni
        from Estudiantes 
        where grado = 'Fisica'
	)
);


################################################################################################# 
# Apartado 14: FUNCION 

# Devuelve el número de reservas confirmadas cuya asistencia esté pendiente de 
# comprobación (valor nulo) para un estudiante concreto.
#
# Nombre de la función: reservas_pendientes()
#
# Parámetro de entrada:
#   • p_dni_estudiante (CHAR(9)): DNI del estudiante
#
# Valor devuelto:
#   • INT: número de reservas confirmadas y con asistencia pendiente (NULL)
#################################################################################################

-- Habilitar permisos para creación de funciones (necesario en algunos servidores MySQL)
SET GLOBAL log_bin_trust_function_creators = 1;

delimiter //
create function reservas_pendientes(p_dni_estudiante char(9))
returns int
deterministic
begin
	declare total int;
    select count(*) 
    into total 
    from Reservas
    where dni_estudiante = p_dni_estudiante
    and estado = 'Confirmada'
    and asistio is null;
    return total; 
end //
delimiter ;




-- ==============================================================================
-- Código para probar la función reservas_pendientes()
-- Comprobamos el estudiante 55555555E (Marta). Según los datos, tiene 3 reservas pendientes.
SELECT reservas_pendientes('55555555E') AS pendientes_marta;
-- Comprobamos el estudiante 55555555E (Laura). Según los datos, tiene 2 reservas pendientes.
SELECT reservas_pendientes('11111111A') AS pendientes_laura;
-- ==============================================================================


################################################################################################# 
# Apartado 15: FUNCION 

# Devuelve el número de plazas libres que quedan en una sala concreta, en una fecha y turno 
# específicos, teniendo en cuenta ÚNICAMENTE las reservas en estado 'confirmada'.
#
# Nombre de la función: plazas_libres()
#
# Parámetros de entrada:
#   • p_id_sala (VARCHAR(10)): identificador alfanumérico de la sala
#   • p_fecha (DATE): fecha de la reserva
#   • p_turno (ENUM('Mañana', 'Tarde')): turno de la reserva
#
# Valor devuelto:
#   • INT: número de plazas libres en la sala para ese día y turno
#################################################################################################


delimiter //
create function plazas_libres(
		p_id_sala varchar(10),
        p_fecha date,
        p_turno enum('Mañana', 'Tarde'))
returns int
deterministic
begin
	declare capacidad_sala int;
    declare ocupadas int;
    declare libres int;
    
    #capacidad de la sala
    select capacidad
    into capacidad_sala
    from Salas
    where id_sala = p_id_sala;
    
	#plazas ocupadas solo las confirmadas
    select count(*)
    into ocupadas 
    from Reservas 
    where id_sala = p_id_sala
    and fecha = p_fecha
    and turno =p_turno
    and estado = 'Confirmada';
    
    set libres = capacidad_sala - ocupadas;
    return libres;
    
end //
delimiter ;



-- ==============================================================================
-- Código para probar la función plazas_libres()
-- Ejecuta estas consultas para comprobar si tu función devuelve los valores correctos:
-- ==============================================================================

-- PRUEBA 1: Sala completamente llena.
-- La Sala D4 (capacidad 4) tiene 4 reservas confirmadas el 15 de abril por la Tarde.
-- Resultado esperado: 0
SELECT plazas_libres('D4', '2026-04-15', 'Tarde') AS libres_D4;

-- PRUEBA 2: Sala con reservas, pero en estado 'cancelada'.
-- La Sala B2 (capacidad 8) tiene 1 reserva el 16 de abril por la Mañana, pero fue cancelada.
-- La función NO debe restar las canceladas.
-- Resultado esperado: 8
SELECT plazas_libres('B2', '2026-04-16', 'Mañana') AS libres_B2;

-- PRUEBA 3: Sala parcialmente ocupada.
-- La Sala C3 (capacidad 10) tiene 2 reservas confirmadas el 6 de abril por la Mañana.
-- Resultado esperado: 8
SELECT plazas_libres('C3', '2026-04-06', 'Mañana') AS libres_C3;

-- PRUEBA 4: Sala completamente vacía en ese turno.
-- La Sala A1 (capacidad 6) tiene una reserva el 20 de abril, pero es por la Tarde.
-- Por la Mañana debería estar intacta.
-- Resultado esperado: 6
SELECT plazas_libres('A1', '2026-04-20', 'Mañana') AS libres_A1;


################################################################################################# 
# Apartado 16: DISPARADOR SENCILLO (TRIGGER)

# Es importante mantener la consistencia en los datos de contacto. Se ha detectado que 
# a veces las aplicaciones externas envían los correos electrónicos con letras mayúsculas.
#
# Crea un disparador sencillo denominado trg_formato_email que se ejecute ANTES de 
# insertar un nuevo registro en la tabla Estudiantes.
# El disparador debe modificar el valor del correo electrónico que está a punto de 
# insertarse para convertirlo completamente a minúsculas.
#################################################################################################


delimiter //
create trigger trg_formato_email
before insert on Estudiantes
for each row
begin
	set new.email = lower(new.email);
end //
delimiter ;



-- ==============================================================================
-- Código para probar el disparador trg_formato_email
-- Insertamos un estudiante de prueba con el email con algunas de mayúsculas:

INSERT INTO Estudiantes (dni, apellidos, nombre, grado, email) 
VALUES ('99988877Z', 'Prueba', 'Test', 'Física', 'MiCoRReo@UNIVERsiDAD.EDU');

-- Comprobamos si el trigger ha corregido el correo al insertarlo:
SELECT * FROM Estudiantes WHERE dni = '99988877Z';

-- Borramos el estudiante de prueba añadido
DELETE FROM Estudiantes WHERE dni = '99988877Z';
-- ==============================================================================


################################################################################################# 
# Apartado 17: DISPARADOR (TRIGGER)

# Este disparador garantiza que las nuevas inserciones en la tabla Reservas cumplan 
# las reglas de negocio de la biblioteca de manera automática. Para ello, es OBLIGATORIO 
# utilizar las funciones auxiliares plazas_libres() y reservas_pendientes() creadas 
# en los apartados anteriores.
#
# ¿Cuándo se dispara?
#   • Antes de insertar una nueva fila en la tabla Reservas.
#
# ¿Qué debe comprobar?
#   1. Regla de antelación: La fecha de la reserva no puede ser posterior a DOS MESES desde la 
#      fecha actual del sistema (CURDATE()). 
#      Si falla, lanza error: 'Error: No se puede reservar con más de dos meses de antelación.'
#
#   Si la reserva que se está intentando insertar tiene estado 'confirmada':
#   2. Regla de aforo:   Debe haber plazas libres en la sala solicitada, ese día y en ese turno.
#      Usar función plazas_libres() creada en apartado anterior.
#      Si falla, lanza error: 'Error: La sala ha superado su capacidad máxima.'
#
#   3. Regla de morosidad: El estudiante no puede tener 3 o más reservas confirmadas 
#      con asistencia pendiente. Usar función reservas_pendientes() creada en apartado anterior.
#      Si falla, lanza error: 'Error: El estudiante ya ha alcanzado el límite de reservas pendientes.'
#################################################################################################


delimiter //
create trigger trg_validar_reservas
before insert on Reservas
for each row
begin
	#Regla antelacion
    if new.fecha > date_add(curdate(), interval 2 month) then
		signal sqlstate '45000'
        set message_text = 'Error: No se puede reservar con más de dos meses de antelación.' ;
	end if;
    
    #Solo si la reserva es confirmada
    if new.estado = 'Confirmada' then
		#Regla del aforo
        if plazas_libres (new.id_sala, new.fecha, new.turno) <=0 then
			signal sqlstate '45000'
            set message_text = 'Error: La sala ha superado su capacidad máxima.';
		end if;
        #Regla de morosidad
        if reservas_pendientes (new.dni_estudiante) >= 3 then
			signal sqlstate '45000'
            set message_text = 'Error: El estudiante ya ha alcanzado el límite de reservas pendientes.';
		end if;
	end if;
end //
delimiter ;
    



-- ==============================================================================
-- Código para probar el disparador trg_validar_nueva_reserva

-- PRUEBA 1: (Falla por fecha > 2 meses respecto a abril/mayo de 2026): 
-- Intentamos reservar para septiembre de 2026.
INSERT INTO Reservas (fecha, turno, dni_estudiante, id_sala, asistio, estado) 
VALUES ('2026-09-15', 'Mañana', '11111111A', 'A1', NULL, 'confirmada');

-- PRUEBA 2:  (Falla por aforo - La sala D4 ya está llena esa Tarde): 
INSERT INTO Reservas (fecha, turno, dni_estudiante, id_sala, asistio, estado) 
VALUES ('2026-04-15', 'Tarde', '55555555E', 'D4', NULL, 'confirmada');

-- PRUEBA 3:  (Falla por límite pendiente de Marta (55555555E), que ya tiene 3): 
INSERT INTO Reservas (fecha, turno, dni_estudiante, id_sala, asistio, estado) 
VALUES ('2026-04-29', 'Mañana', '55555555E', 'C3', NULL, 'confirmada');
-- ==============================================================================
    
  
################################################################################################# 
# Apartado 18: VISTA SENCILLA 

# La universidad necesita un directorio de contacto rápido para enviar comunicados a los 
# estudiantes. 
#
# Crea una vista denominada Vista_Directorio_Estudiantes que consulte únicamente la 
# tabla Estudiantes. La vista debe mostrar el DNI, el nombre completo (concatenando 
# apellidos, una coma, un espacio en blanco y el nombre, en una sola columna llamada 
# 'nombre_completo') y su correo electrónico.
#
# Salida: (dni, nombre_completo, email)
#################################################################################################


create view Vista_Directorio_Estudiantes as 
select 
	dni,
    concat(apellidos, ', ', nombre) as nombre_completo,
    email
from Estudiantes;


-- ==============================================================================
-- Código para probar la vista Vista_Directorio_Estudiantes
SELECT * FROM Vista_Directorio_Estudiantes ORDER BY nombre_completo;
-- ==============================================================================

    
################################################################################################# 
# Apartado 19: VISTA SOBRE TRES TABLAS

# El personal de la biblioteca necesita consultar habitualmente el listado de reservas sin 
# tener que realizar los cruces de tablas (JOINs) manualmente cada vez.
# 
# Crea una vista denominada Vista_Reservas_Detalladas que muestre la información de las 
# reservas de forma clara y legible. 
#
# Salida: (fecha, turno, dni, apellidos, nombre, id_sala, estado)
#################################################################################################

create view Vista_Reservas_Detalladas as 
select 
	r.fecha,
    r.turno,
    e.dni,
    e.apellidos,
    e.nombre,
    s.id_sala,
    r.estado
from Reservas r
join Estudiantes e on r.dni_estudiante = e.dni
join Salas s on r.id_sala = s.id_sala;



-- ==============================================================================
-- Código para probar la vista Vista_Reservas_Detalladas
SELECT * FROM Vista_Reservas_Detalladas ORDER BY fecha, id_sala;
-- ==============================================================================


################################################################################################# 
# Apartado 20: VISTA SOBRE TRES TABLAS

# El equipo de mantenimiento necesita un acceso rápido a las incidencias que requieren su 
# atención. Para que sea realmente útil, la vista debe mostrar no solo la sala, sino 
# también su ubicación física exacta.
#
# Crea una vista denominada Vista_Incidencias_Pendientes que muestre los datos de la 
# incidencia, el identificador de la sala y su ubicación.
#
# Salida: (id_incidencia, fecha_registro, id_sala, ubicacion, tipo_incidencia, 
#          estado_resolucion, descripcion)
#################################################################################################


create view Vista_Incidencias_Pendientes as
select 
	i.id_incidencia,
    i.fecha_registro,
    r.id_sala,
    s.ubicacion,
    i.tipo_incidencia,
    i.estado_resolucion,
    i.descripcion
from Incidencias i 
join Reservas r on i.id_reserva = r.id_reserva
join Salas s on r.id_sala = s.id_sala;



-- ==============================================================================
-- Código para probar la vista Vista_Incidencias_Pendientes
SELECT * FROM Vista_Incidencias_Pendientes;
-- ==============================================================================
    
