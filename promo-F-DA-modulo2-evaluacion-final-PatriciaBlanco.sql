USE sakila;
-- 1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT `title` AS `nombre_de_peliculas`
FROM `film`;

-- 2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT `title` AS `nombre_de_peliculas_PG-13`
FROM `film`
WHERE `rating` = 'PG-13';

-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%amazing%';

-- 4.Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT `title`
FROM `film`
WHERE `length` >120;

-- 5.Recupera los nombres de todos los actores.
SELECT ALL `first_name`
FROM `actor`;

-- 6.Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT `first_name`, `last_name`
FROM `actor`
WHERE `last_name` = 'GIBSON';

-- 7.Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT `first_name`
FROM `actor`
WHERE `actor_id` BETWEEN 10 AND 20;

-- 8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT `title`
FROM `film`
WHERE `rating` !='R' AND `rating` != 'PG-13';

-- 9.Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT `rating`, COUNT(`film_id`) AS `total_peliculas`
FROM `film`
GROUP BY `rating`;

-- 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT `c`.`first_name`, `c`.`last_name`, COUNT(`r`.`rental_id`) AS `peliculas_alquiladas`
FROM `customer`AS `c`
INNER JOIN `rental` AS `r`
ON `c`.`customer_id` = `r`.`customer_id`
GROUP BY `r`.`customer_id`;

-- 11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres. 
   /*Para construir la query conecto las listas rental, inventory, film_category y category a través de las columnas inventory_id, film_id y category_id
    de category extraigo el dato name, y rental extraigo los totales de alquileres por género*/

SELECT `c`.`name`, COUNT(`r`.`rental_id`) AS `total_alquileres`
FROM `rental` AS `r`
INNER JOIN `inventory` AS `i` ON `r`.`inventory_id` = `i`.`inventory_id`
INNER JOIN `film_category` AS f ON `i`.`film_id` = `f`.`film_id`
INNER JOIN `category` AS `c` ON `f`.`category_id` = `c`.`category_id`
GROUP BY `c`.`category_id`;

-- 12.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
SELECT `rating`, AVG(`length`) AS `promedio_duracion`
FROM `film`
GROUP BY `rating`;

-- 13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
SELECT `first_name`, `last_name`
FROM `actor`
INNER JOIN `film_actor` ON `actor`.`actor_id` = `film_actor`.`actor_id`
WHERE `film_actor`.`film_id` = (
	SELECT `film_id` 
	FROM `film`
	WHERE title = 'Indian Love');

-- 14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción
SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%' ;

-- 15. Hay algún actor que no aparecen en ninguna película en la tabla film_actor
   /*Como no sé si los actores que no han trabajado en ninguna película, directamente no aparecen en la tabla film_actor, creo una CTE 
	donde combino a todos los actores de la tabla actor con el id de las peliculas que han grabado de la tabla film_actor donde, si no hay coincidencias, 
    el id de películafiguraría como NULL. 
    Después busco los valores nulos en esa tabla creada y la relaciono con actor para que salga el nombre, en caso de que haya alguno*/
 
WITH `actores_nulos` AS(SELECT `actor`.`actor_id`, `film_actor`.`film_id`
	FROM `actor` LEFT JOIN `film_actor`
	ON `film_actor`.`actor_id` = `actor`.`actor_id`)

SELECT `actor`.`first_name`, `actor`.`last_name`
FROM `actor`
JOIN `actores_nulos`
WHERE `film_id` IS NULL;

-- 16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010
SELECT `title`
FROM `film`
WHERE `release_year` BETWEEN 2005 AND 2010;

-- 17.Encuentra el título de todas las películas que son de la misma categoría que "Family"
SELECT `f`.`title`
FROM `film` AS `f`
INNER JOIN `film_category` AS `fc`
ON `f`.`film_id` = `fc`.`film_id`
WHERE `fc`.`category_id` IN (
	SELECT `category_id`
	FROM `category`
	WHERE name = 'Family');

-- 18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas
SELECT CONCAT(`a`.`first_name`,' ',`a`.`last_name`) AS `nombre_artistas`
FROM `actor` AS `a`
INNER JOIN `film_actor` AS `f`
ON `a`.`actor_id` = `f`.`actor_id`
GROUP BY `f`.`actor_id`
HAVING COUNT(`f`.`film_id`) >10;

-- 19.Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film
SELECT `title`
FROM `film`
WHERE `rating` = 'R' AND `length` > 120;

-- 20.Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración
SELECT `c`.`name` AS `categoria`, AVG(`f`.`length`) AS `promedio_duracion`
FROM `category` AS `c`
INNER JOIN `film_category` AS `fc` ON `c`.`category_id` = `fc`.`category_id`
INNER JOIN `film` AS `f` ON `fc`.`film_id` = `f`.`film_id`
GROUP BY `fc`.`category_id`
HAVING AVG(`f`.`length`) >120;

-- 21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado
SELECT `a`.`first_name` AS `nombre`,`a`.`last_name` AS `apellido`, COUNT(`f`.`film_id`) AS `cantidad_peliculas`
FROM `actor` AS `a`
INNER JOIN `film_actor` AS `f`
ON `a`.`actor_id` = `f`.`actor_id`
GROUP BY `f`.`actor_id`
HAVING COUNT(`f`.`film_id`) >= 5;

-- 22.Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids 
-- con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT `title`
FROM `film`
WHERE `film_id` IN (SELECT `rental_id`
	FROM `rental`
	WHERE DATEDIFF(`return_date`,`rental_date`) >5);

-- 23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
   /*En la subconsulta filtro los id de actores que han trabajado en películas de horror, enlazando las tablas de film_actor, film_category y category. 
   Luego, utilizo este filtro para seleccionar los artistas que no han trabajado en ninguna de esas películas*/

SELECT `first_name`, `last_name`
FROM `actor`
WHERE `actor_id` NOT IN (SELECT `fa`.`actor_id`
	FROM `film_actor` AS `fa`
	INNER JOIN `film_category` AS `fc` ON `fc`.`film_id` = `fa`.`film_id`
	INNER JOIN `category` AS `c` ON `fc`.`category_id` = `c`.`category_id`
	WHERE `c`.`name` = 'Horror');

-- 24.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film
WITH `comedias` AS (
SELECT `film_id`
FROM `film_category`
INNER JOIN `category`
ON `film_category`.`category_id` = `category`.`category_id`
WHERE `category`.`name` = 'Comedy')

SELECT `f`.`title`
FROM `film` AS `f`
INNER JOIN `comedias` AS `c`
ON `c`.`film_id` = `f`.`film_id`
WHERE `f`.`length` > 180;

-- Mismo ejercicio hecho con subconsulta:
SELECT `film`.`title`
FROM `film`
WHERE `film_id` IN (SELECT `film_id`
	FROM `film_category`
	INNER JOIN `category`
	ON `film_category`.`category_id` = `category`.`category_id`
	WHERE `category`.`name` = 'Comedy')
AND `film`.`length` > 180;

-- 25.BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

/*Primero creo el CTE donde figurarán los pares de actores y el número de películas que han hecho juntos. Para ello, hago un SELF JOIN de la tabla film_actor 
para que agrupe los actores que han coincidido: Diseño las columnas donde irán los id de actores y el número de películas que han hecho juntos.
En JOIN uno los actores que comparten el mismo ID de película y añadimos != para que no nos una un actor consigo mismo.
Con GROUP BY agrupamos en parejas de actores y filtramos para que solo muestre los pares que han trabajado juntos al menos en 1 película.
COUNT cuenta el número de veces que aparece cada combinación de actores en la misma película 
Después utilizo ese CTE para la consulta principal, donde lo conecto con la tabla actor para sacar los nombres de los artistas*/

WITH `artistas_juntos` AS (
	SELECT `fa1`.`actor_id` AS `actor_1`, `fa2`.`actor_id` AS `actor_2`, COUNT(*) AS `peliculas_juntos`
	FROM `film_actor` AS `fa1`
	JOIN `film_actor` AS `fa2` 
	ON `fa1`.`film_id` = `fa2`.`film_id` AND `fa1`.`actor_id` != `fa2`.`actor_id`
	GROUP BY `fa1`.`actor_id`, `fa2`.`actor_id`
	HAVING `peliculas_juntos` >= 1)

SELECT CONCAT(`a1`.`first_name`,' ',`a1`.`last_name`) AS `ACTOR_1`, 
		CONCAT(`a2`.`first_name`,`a2`.`last_name`) AS `ACTOR_2`, 
		`aj`.`peliculas_juntos` AS `PELICULAS_JUNTOS`
FROM `artistas_juntos` AS `aj` 
JOIN `actor` AS `a1`
ON `a1`.`actor_id` = `aj`.`actor_1` 
JOIN `actor` AS `a2`
ON `a2`.`actor_id` = `aj`.`actor_2`
;















