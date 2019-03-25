USE sakila;

-- Displaying first_namd and last_name of Actors
SELECT first_name, last_name FROM actor;

-- Diplaying first_namd and last_name of Actors as one column with a new column name
SELECT UPPER(CONCAT( first_name, ' ', last_name)) AS `Actor Name` FROM actor;

-- displying ID and last name of and actor whose first name is joe
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'joe';

-- all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name FROM actor 
WHERE last_name LIKE '%GEN%';

-- actors whose last names contain the letters `LI`
SELECT actor_id, last_name, first_name FROM actor 
WHERE last_name LIKE '%LI%';

-- Using `IN`, display the `country_id` and `country` columns of Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country 
WHERE country IN 
('Afghanistan', 'Bangladesh', 'China');

-- Creating new column called Description with data type BLOB
ALTER TABLE actor
ADD COLUMN Description BLOB;

-- Droping the column Description
ALTER TABLE actor
DROP COLUMN Description;

-- Changing first_name of one of the actors from Groucho to Harpo
UPDATE actor 
SET first_name = 'HARPO'
WHERE First_name = "Groucho" AND last_name = "Williams";

Select * FROM actor where last_name = "Williams";

UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

SELECT * FROM actor where last_name = "Williams";
-- query would you use to re-create schema of `address` table
DESC Sakila.address;

CREATE TABLE IF NOT EXISTS `address`(
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- PPulling First and last names from staff table and adress from adress table using inner JOIN
SELECT staff.first_name, staff.last_name, address.address 
	FROM staff 
INNER JOIN address ON staff.address_id=address.address_id;

-- Use `JOIN` to display the total amount rung up by each staff member in August
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(payment.amount), payment.payment_date
FROM staff LEFT JOIN payment ON
staff.staff_id = payment.staff_id 
WHERE payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;
 
-- List each film and the number of actors who are listed for that film
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS `Number of Actor` FROM film
	JOIN film_actor
ON film.film_id = film_actor.actor_id
GROUP BY film_id;

-- otal paid by each customer
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS `Total Amount Paid` FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;

-- Display  of titles of movies starting with the letters `K` and `Q` whose language is English 
SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

-- Using subqueries to display all actors who appear in the film `Alone Trip`
SELECT first_name, last_name FROM actor
	WHERE actor_id
IN (
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

-- names and email addresses of all Canadian customers
SELECT customer.first_name, customer.last_name, customer.email
FROM customer JOIN address 
ON (customer.address_id = address.address_id)
JOIN city 
ON (city.city_id = address.city_id)
WHERE (country_id = 20);
 
 -- Identifying all movies categorized as family films
SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

-- most frequently rented movies in descending order
SELECT film.title, COUNT(rental_id) AS 'Frequency/Number of times'
FROM rental
JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
JOIN film
ON (inventory.film_id = film .film_id)
GROUP BY film.title
ORDER BY `Frequency/Number of times` DESC;

-- How much business, each store brought in
SELECT store.store_id, SUM(payment.amount) AS 'Revenue'
FROM payment
JOIN rental
ON (payment.rental_id = rental.rental_id)
JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
JOIN store
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id; 

-- display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country_id 
FROM store
JOIN address ON (store.address_id = address.address_id)
JOIN city ON (city.city_id = address.city_id)
JOIN country ON (country.country_id = city.country_id);

-- 7f List of top five genres in gross revenue in descending order
SELECT category.name AS `Genre`, SUM(payment.amount) AS `Gross Revenue` 
FROM category
JOIN film_category 
ON (category.category_id=film_category.category_id)
JOIN inventory
ON (film_category.film_id = inventory.film_id)
JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
JOIN payment 
ON (rental.rental_id = payment.rental_id)
GROUP BY category.name 
ORDER BY `Gross Revenue` LIMIT 5;

-- EASY way to view the Top 5 Genres by Gross Revenue
CREATE VIEW `Top 5 Genres by Gross Revenue` AS
SELECT category.name AS `Genre`, SUM(payment.amount) AS `Gross Revenue` 
FROM category
JOIN film_category 
ON (category.category_id=film_category.category_id)
JOIN inventory
ON (film_category.film_id = inventory.film_id)
JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
JOIN payment 
ON (rental.rental_id = payment.rental_id)
GROUP BY category.name 
ORDER BY `Gross Revenue` LIMIT 5;

--- How to view the create view 
SELECT *  FROM `Top 5 Genres by Gross Revenue`;

-- Deleting the Top 5 Genres by Gross Revenue
DROP VIEW `Top 5 Genres by Gross Revenue`;




