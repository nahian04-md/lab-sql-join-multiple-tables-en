Challenge 1
1. Write a query to display for each store its store ID, city, and country.
SELECT
    s.store_id AS "STORE ID",
    c.city     AS "CITY",
    co.country AS "COUNTRY"
FROM store s
JOIN address a
    ON s.address_id = a.address_id
JOIN city c
    ON a.city_id = c.city_id
JOIN country co
    ON c.country_id = co.country_id
ORDER BY s.store_id;

*******************************************
Challenge 2
2. Write a query to display how much business, in dollars, each store brought in.
SELECT
    s.store_id AS "STORE ID",
    SUM(p.amount) AS "TOTAL BUSINESS ($)"
FROM store s
JOIN customer c
    ON s.store_id = c.store_id
JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY s.store_id
ORDER BY "TOTAL BUSINESS ($)" DESC

********************************************
Challenge 3
3. What is the average running time of films by category?
SELECT
    c.name AS "CATEGORY",
    ROUND(AVG(f.rental_duration), 2) AS "AVG_RENTAL_DURATION"
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY "AVG_RENTAL_DURATION" DESC;

*********************************************
Challenge 4
4. Which film categories are longest?
WITH total_duration_per_category AS (
    SELECT
        c.name AS category,
        SUM(f.rental_duration) AS total_rental_duration
    FROM film f
    JOIN film_category fc
        ON f.film_id = fc.film_id
    JOIN category c
        ON fc.category_id = c.category_id
    GROUP BY c.name
)
SELECT
    category,
    total_rental_duration
FROM total_duration_per_category
WHERE total_rental_duration = (
    SELECT MAX(total_rental_duration)
    FROM total_duration_per_category
);
*********************************************
Challenge 5
5. Display the most frequently rented movies in descending order.
SELECT
    f.title AS "FILM TITLE",
    COUNT(r.rental_id) AS "NUM_RENTALS"
FROM rental r
JOIN inventory i
    ON r.inventory_id = i.inventory_id
JOIN film f
    ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY NUM_RENTALS DESC;
*********************************************
Challenge 6
6. List the top five genres in gross revenue in descending order.
SELECT
    c.name AS "CATEGORY",
    SUM(p.amount) AS "GROSS_REVENUE"
FROM payment p
JOIN rental r
    ON p.customer_id = r.customer_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
JOIN film f
    ON i.film_id = f.film_id
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY GROSS_REVENUE DESC
LIMIT 5;
*********************************************
Challenge 7
7. Is "Academy Dinosaur" available for rent from Store 1?
SELECT
    s.store_id AS "STORE ID",
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM inventory i
            JOIN film f ON i.film_id = f.film_id
            LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
            WHERE f.title = 'Academy Dinosaur'
              AND i.store_id = s.store_id
              AND r.rental_id IS NULL
        )
        THEN 'YES'
        ELSE 'NO'
    END AS "AVAILABLE"
FROM store s
ORDER BY s.store_id;