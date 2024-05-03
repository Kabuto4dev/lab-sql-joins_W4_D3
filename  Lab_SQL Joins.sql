USE sakila

# Challenge - Joining on multiple tables

# Write SQL queries to perform the following tasks using the Sakila database:
-- 1. List the number of films per category.

SELECT c.name AS category_name, 
COUNT(f.film_id) AS num_films FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;


-- 2. Retrieve the store ID, city, and country for each store.

SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.

SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM store
JOIN staff ON store.manager_staff_id = staff.staff_id
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 4. Determine the average running time of films for each category.

SELECT category.name, AVG(film.length) AS average_running_time
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

# Bonus:

--    5. Identify the film categories with the longest average running time.

SELECT category.name AS category_name, AVG(film.length) AS average_running_time
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY average_running_time DESC;

--    6. Display the top 10 most frequently rented movies in descending order.

SELECT film.title AS movie_title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 10;

--    7. Determine if "Academy Dinosaur" can be rented from Store 1.

SELECT 
    IFNULL(
        CASE 
            WHEN COUNT(*) > 0 THEN 'Available' 
            ELSE 'NOT available' 
        END,
        'NOT in inventory'
    ) AS availability_status
FROM 
    inventory
JOIN 
    film ON inventory.film_id = film.film_id
WHERE 
    film.title = 'Academy Dinosaur';

--    8. Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."
    
SELECT 
    film.title AS film_title,
    IFNULL(
        CASE 
            WHEN COUNT(inventory.inventory_id) > 0 THEN 'Available' 
            ELSE 'NOT available' 
        END,
        'NOT in inventory'
    ) AS availability_status
FROM 
    film
LEFT JOIN 
    inventory ON film.film_id = inventory.film_id
GROUP BY 
    film.title;