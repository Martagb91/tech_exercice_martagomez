-- Modulo 2 - Ejercicio técnico

/* INTRODUCCIÓN: 
Para este ejerccio utilizaremos la BBDD Sakila que hemos estado utilizando durante el repaso de SQL. Es
una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como film
(películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras.
Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para
realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas.*/

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. 

USE sakila;

SELECT * FROM film;  -- Primero ejecuto la tabla, ya que no se las variables que hay en ellas, así como su nomenclatura.  

SELECT DISTINCT title as Nombre_pelicula -- nos proporcia un listado de peliculas SIN que aparezcan duplicados
FROM film;

SELECT COUNT(title) -- nos da el número de peliculas SIN diferenciar
FROM film;

SELECT COUNT(DISTINCT title) -- nos da el número de peliculas diferenciando
FROM film;

/* El resultado da el mismo 1000 peliculas, porque no se repetía ningún valor. */

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT 
title AS Nombre_pelicula,
rating AS Clasificación -- Esto no hace falta, pero lo añado para comprobar que me da el resultado correcto. Si no lo quisiera mostrar, lo quitaría y el resultado sería el mismo sin esta columna
FROM film
WHERE rating = "PG";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT
title as Nombre_pelicula,
description as Descripcion
FROM film
WHERE description REGEXP 'amazing'; -- Este operador de filtro 'REGEXP' nos sirve para poder diferentes patrones en este caso le decimos que en la descripción contenga 'amazing'

SELECT
title as Nombre_pelicula,
description as Descripcion
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. 

SELECT
title as Nombre_pelicula,
length as Duracion_pelicula
FROM film
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.

SELECT * FROM actor; -- Primero vemos la tabla

SELECT CONCAT(first_name,' ',last_name) AS nombre_actor
FROM actor; 


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name,' ',last_name) AS nombre_actor
FROM actor
WHERE last_name = 'Gibson'; -- En este caso podemos usar el igual porque sabemos que NO es un apellido compuesto

SELECT CONCAT(first_name,' ',last_name) AS nombre_actor
FROM actor
WHERE last_name REGEXP ('Gibson');  -- Si no supieramos si el apellido es COMPUESTO o SIMPLE tendríamos que usar REGEXP 

/* En este caso podemos utilizar las tres porque solo consta una palabra, pero si tuviera más de uno se tendría que usar REFEXP */

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name AS nombre_actor
FROM actor
WHERE actor_id between 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT * FROM film; -- Primero vemos la tabla

SELECT title as Nombre_pelicula,
rating-- nos proporcia un listado de peliculas SIN que aparezcan duplicados
FROM film
WHERE rating NOT IN ("R", "PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT 
rating as clasificación,
COUNT(title) as número_peliculas
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT * FROM customer;         -- Para tener Nombre cliente y Apellido
SELECT * FROM rental;           -- Para tener el número total de películas alquiladas
                                -- Las dos tablas tienen en común el customer_id

SELECT
c.customer_id as ID_cliente,
CONCAT(c.first_name,' ',c.last_name) AS Nombre_cliente,  -- Dime el nombre del cliente juntando nombre y apellido y renombrándomelo de la tabla customer
COUNT(r.rental_id) as Peliculas_alquiladas               -- contando el total de alquileres y renombrándomelo de la tabla rental
FROM customer c                                          -- Desde la tabla customer para saber el ID & el nombre y apellido
INNER JOIN rental r                                      -- Unes todos los datos que no sean NULL con la tabla rental para poder saber el número total de películas alquiladas     
ON c.customer_id = r.customer_id                         -- Donde la variable que tienen en común para enlazar es customer_id
GROUP BY Nombre_cliente, c.customer_id                   -- Me lo agrupas por Nombre de cliente porque quiero saber cada cliente cuantas peliculas ha alquilado
ORDER BY ID_cliente ASC;                                 -- Me lo ordenas por el ID_cliente

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT * FROM category;        -- Para obtener Nombre de la categoría y poder agrupar por categoría   
SELECT * FROM rental;          -- Para tener el número total de películas alquiladas
SELECT * FROM film_category;   -- Para conseguir llegar hasta inventory
SELECT * FROM inventory;       /* Para poder unir film y rental a través de film_category ya que para conseguir la relación Cateogría & total peliculas alquiladas:
						              -- Film se une a Inventory a través 'film_id'
							          -- Rental se une a Inventory a través de 'inventory_id' */ 

                           
SELECT
c.name AS Categoría_pelicula ,                      -- Dime la categoría de la pelicula de la tabla category
COUNT(r.rental_id) as Total_Peliculas_alquiladas    -- contando el total de alquileres y renombrándomelo de la tabla rental
FROM category c                                     -- Desde la tabla category donde extaeré el nombre de la categoría
INNER JOIN film_category fc                         -- Unes todos los datos que no sean NULL con la tabla film_category  para llegar a inventory
ON c.category_id = fc.category_id                   -- Donde la variable que tienen en común para enlazar es 'category_id'
INNER JOIN inventory i                              -- Unes todos los datos que no sean NULL con la tabla inventory para llegar a rental   
ON fc.film_id = i.film_id		                    -- Donde la variable que tienen en común para enlazar es 'film_id'
INNER JOIN rental r                                 -- Unes todos los datos que no sean null de la tabla rental para poder saber el número total de películas alquiladas
ON r.inventory_id = i.inventory_id                  -- Donde la variable que tienen en común para enlazar es 'inventory_id' (Aquí ya tienes unidas las cuatro tablas)
GROUP BY Categoría_pelicula                         -- Me lo agrupas por categoría de película porque quiero saber cuántas películas se han alquilado por categoría
ORDER BY Total_Peliculas_alquiladas ASC;            -- Me lo ordenas por el número de Peliculas_alquiladas 

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT * FROM film;            -- Para obtener la duración media 
SELECT * FROM category;        -- Para obtener el Nombre de la categoría y poder agrupar por este valor
SELECT * FROM film_category;   -- Para poder unir la tabla film & category a través de 'film_id'
                                
SELECT 
c.name Categoría_pelicula,          -- Dime la categoría de la pelicula de la tabla category
AVG(f.length) Duración_media        -- Dime la duración media de la tabla film
FROM category c                     -- Desde la tabla category donde extraeré el nombre de la categoría
INNER JOIN film_category fc         -- La unes con la tabla film_category donde me darás todos los datos cuando no sean NULL  para poder llegar a FILM
ON c.category_id = fc.category_id   -- Donde la variable que tienen en común es category_id
INNER JOIN film f                   -- La unes con la tabla film 
ON f.film_id = fc.film_id           -- A través de la variable film_id ya que esta tabla me dará la duración promedio
GROUP BY Categoría_pelicula         -- Lo agrupas por categoría
ORDER BY Duración_media ASC;        -- Lo ordenas por duración media de forma ascendente
                                

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT * FROM film;        -- Para obtener el nombre de la pelicula 'Indian Love'
SELECT * FROM actor;       -- Para obtener el nombre y apellido de los actores


SELECT
FROM film f
INNER JOIN actor a
ON 

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta 
--     para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. 
--     Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna pelícla de la  categoría "Horror". 
--     utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.