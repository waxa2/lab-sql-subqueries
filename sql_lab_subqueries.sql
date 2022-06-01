use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(DISTINCT(i.inventory_id)) as amount
FROM film f
JOIN inventory i USING(film_id)
WHERE f.title='Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT DISTINCT(title), length
FROM film
WHERE length>(SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT f.title, a.first_name, a.last_name
FROM film f
JOIN film_actor fa USING(film_id)
JOIN actor a USING(actor_id)
WHERE f.title='Alone Trip';

SELECT first_name, last_name
FROM actor 
WHERE actor_id in (SELECT actor_id FROM film_actor
						WHERE film_id in (SELECT film_id FROM film
											WHERE title='Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT f.title, c.name as category_name
FROM film f
JOIN film_category fc USING(film_id)
JOIN category c USING (category_id)
WHERE c.name='Family';



-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join,
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name,c.email, co.country
FROM customer c
JOIN address a  USING(address_id)
JOIN city ci  USING(city_id)
JOIN country co USING(country_id)
WHERE co.country='Canada';

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address
							WHERE city_id IN (SELECT city_id FROM city
								WHERE country_id IN (SELECT country_id FROM country
														WHERE country='Canada')));


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number
--  of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she 
-- starred.
SELECT actor_id, COUNT(film_id) as films_amount
FROM(SELECT DISTINCT(film_id), actor_id
FROM film_actor)sub1
GROUP BY actor_id
ORDER BY films_amount
LIMIT 1;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

SELECT first_name, last_name,customer_id
FROM customer
JOIN (SELECT customer_id, SUM(amount) as most_profitable
FROM payment
GROUP BY customer_id
ORDER BY most_profitable DESC
LIMIT 1)sub1 USING (customer_id);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by 
-- each client.

SELECT customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent> (
	SELECT AVG(total_amount) as total_avg_clients 
    FROM (
		SELECT SUM(amount) total_amount
		FROM payment
		GROUP BY customer_id) sub1);
