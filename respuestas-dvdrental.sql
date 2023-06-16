-- 1. Construlle las siguientes consultas; Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.
-- INSERTAR CUSTOMER.
INSERT INTO customer(store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'Jhon', 'Doe', 'john.doe@sakilacustomer.org', 469, 1); 
-- MODIFICAR CUSTOMER.
UPDATE customer 
SET first_name = 'Victor', last_name = 'Araya', email = 'victor.araya@sakilacustomer.org', address_id = 49 
WHERE customer_id = 600;
-- ELMINAR CUSTOMER Y REINICIAR SECUENCIA.
DELETE FROM customer WHERE customer_id = 600;
ALTER SEQUENCE customer_customer_id_seq RESTART WITH 600;
-- REVISAR
SELECT * FROM customer ORDER BY customer_id DESC;

-- INSERTAR STAFF
INSERT INTO staff(first_name, last_name, address_id, email, store_id, username, password)
VALUES ('Lance', 'Knott', 5, 'lance.knott@sakilastaff.com', 1, 'Lance', MD5('userPassword'));
-- MODIFICAR STAFF
UPDATE staff SET email = 'Lance.Knott@sakilastaff.com', address_id = 6 WHERE staff_id = 3;
-- ELIMINAR STAFF Y REINICIAR SECUENCIA
DELETE FROM staff WHERE staff_id = 3;
ALTER SEQUENCE staff_staff_id_seq RESTART WITH 3;
-- REVISAR
SELECT * FROM staff;

-- INSERTAR ACTOR.
INSERT INTO actor(first_name, last_name) VALUES ('Jhonny', 'Deep');
SELECT * FROM actor WHERE first_name = 'Keanu' AND last_name = 'Reeves';
-- MODIFICAR ACTOR.
UPDATE actor SET first_name = 'Keanu', last_name = 'Reeves' WHERE actor_id = 201;
-- ELIMINAR ACTOR Y REINICIAR SECUENCIA.
DELETE FROM actor WHERE actor_id = 201;
ALTER SEQUENCE actor_actor_id_seq RESTART WITH 201;
-- REVISAR
SELECT * FROM actor ORDER BY actor_id DESC;

-- 2. Listar todas las "rental" con los datos del "customer" dado un año y mes.
SELECT re.*, cu.* FROM rental re
JOIN customer cu ON re.customer_id = cu.customer_id
WHERE EXTRACT(YEAR FROM re.rental_date) = 2005
AND EXTRACT(MONTH FROM re.rental_date) = 5
ORDER BY rental_date DESC;

-- 3. Listar Número, Fecha (payment_date) y Total (amount) de todas las "payment".
SELECT payment_id AS numero, 
payment_date AS fecha, 
amount AS total
FROM payment
GROUP BY payment_id, payment_date;

-- 4. Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
SELECT * FROM film WHERE release_year = 2006 AND rental_rate > 4.0;

-- 5. Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, 
-- si éstas pueden ser nulas, y su tipo de dato correspondiente.

/* information_schema es un esquema (schema) especial en PostgreSQL que contiene 
una colección de vistas y tablas que proporcionan metadatos sobre la estructura y objetos 
de la base de datos. Este esquema es parte del estándar SQL y está diseñado para ser 
compatible con diferentes sistemas de gestión de bases de datos.

Para realizar el Diccionario de datos se utilizarón estas tres vistas u objetos.
 - information_schema.columns.
 - information_schema.constraint_column_usage.
 - information_schema.table_constraints.
 */

-- Lista todas las tablas y sus campos, excepto su constraint.
SELECT 
   table_name AS nombre_tabla,
   column_name AS nombre_columna, 
   udt_name AS tipo_dato, 
   character_maximum_length AS largo,
   is_nullable AS es_null, 
   column_default AS defecto
FROM
   information_schema.columns
WHERE
    table_schema = 'public'
ORDER BY nombre_tabla;

/* Lista por tabla (se debe indicar el nombre de la tabla y el schema),
obtiene las constraints, ideal para ver en detalle cada tabla. */
SELECT
    c.column_name AS nombre_columna,
    c.data_type AS tipo_dato,
    c.character_maximum_length AS largo,
	 tc.constraint_type AS tipo_constraint,
    c.is_nullable AS es_null,
    c.column_default AS defecto
FROM
    information_schema.columns c
LEFT JOIN (
    SELECT ccu.column_name, tc.constraint_type
    FROM information_schema.constraint_column_usage ccu
    JOIN information_schema.table_constraints tc
	ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
    WHERE tc.table_name = 'payment' AND tc.table_schema = 'public'
) tc
ON c.column_name = tc.column_name
WHERE c.table_name = 'payment' AND c.table_schema = 'public';