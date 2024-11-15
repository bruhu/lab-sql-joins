-- sql joins lab

-- film amount per category - join `film` and `category` tables
SELECT c.name AS category_name, COUNT(f.film_id) AS num_of_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY num_of_films DESC;

-- get ID, city and country for each store
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;


-- calc total revenue per store (in dollars)
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

DESCRIBE payment;

-- average film length per category
SELECT c.name AS category_name, AVG(f.length) AS average_running_time
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY average_running_time DESC;

-- bonus

-- film categories with highest average length
SELECT c.name AS category_name, AVG(f.length) AS avg_running_time
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY avg_running_time DESC;

-- top 10 rented films
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 10;

-- check if academy dinosaur is available in store 1
SELECT f.title,
       CASE 
           WHEN i.inventory_id IS NOT NULL AND i.store_id = 1 AND i.inventory_id NOT IN (SELECT inventory_id FROM rental WHERE return_date IS NULL) THEN 'Available'
           ELSE 'NOT Available'
       END AS availability_status
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Academy Dinosaur' AND i.store_id = 1;

-- titles and availability
SELECT f.title,
       CASE
           WHEN IFNULL(i.inventory_id, 0) = 0 THEN 'NOT Available'
           ELSE 'Available'
       END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
ORDER BY f.title;