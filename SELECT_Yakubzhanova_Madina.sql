
---1---
select * from  rental where rental_date = null;


---2---
select f.title as movie_title, 
sum(p.amount) as total_revenue
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.title
order by total_revenue asc
limit 3;

---3---
SELECT 
    i.store_id, 
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE p.payment_date >= '2017-01-01' AND p.payment_date < '2018-01-01'
GROUP BY i.store_id
ORDER BY total_revenue DESC;

-- Which staff members made the highest revenue for each store and deserve a bonus for the year 2017?
--1
SELECT 
    st.store_id, 
    st.staff_id, 
    st.first_name, 
    st.last_name, 
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
WHERE p.payment_date >= '2017-01-01' AND p.payment_date < '2018-01-01'
GROUP BY st.store_id, st.staff_id, st.first_name, st.last_name
HAVING SUM(p.amount) = (
    SELECT MAX(sub_revenue)
    FROM (
        SELECT SUM(p2.amount) AS sub_revenue
        FROM payment p2
        JOIN staff st2 ON p2.staff_id = st2.staff_id
        WHERE st2.store_id = st.store_id -- Связываем магазины
          AND p2.payment_date >= '2017-01-01' AND p2.payment_date < '2018-01-01'
        GROUP BY st2.staff_id
    ) AS store_max_sales
);

--2
SELECT store_id, staff_id, first_name, last_name, total_revenue
FROM (
    SELECT 
        s.store_id,
        st.staff_id,
        st.first_name,
        st.last_name,
        SUM(p.amount) AS total_revenue,
        RANK() OVER (PARTITION BY s.store_id ORDER BY SUM(p.amount) DESC) as rn
    FROM payment p
    JOIN staff st ON p.staff_id = st.staff_id
    JOIN store s ON st.store_id = s.store_id
    WHERE p.payment_date >= '2017-01-01' AND p.payment_date < '2018-01-01'
    GROUP BY s.store_id, st.staff_id, st.first_name, st.last_name
) AS ranked_sales
WHERE rn = 1;

-- Which five movies were rented more than the others, and what is the expected age of the audience for these movies?
--1
SELECT 
    f.title AS movie_title, 
    COUNT(r.rental_id) AS rental_count,
    f.rating,
    CASE 
        WHEN f.rating = 'G' THEN 'All ages'
        WHEN f.rating = 'PG' THEN '7+ (with parental guidance)'
        WHEN f.rating = 'PG-13' THEN '13+'
        WHEN f.rating = 'R' THEN '17+'
        WHEN f.rating = 'NC-17' THEN '18+'
        ELSE 'Unknown'
    END AS expected_age_group
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.rating
ORDER BY rental_count DESC
LIMIT 5;

--2
WITH movie_rentals AS (
    SELECT film_id, COUNT(rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY film_id
    ORDER BY rental_count DESC
    LIMIT 5
)
SELECT 
    f.title, 
    mr.rental_count, 
    f.rating,
    CASE f.rating 
        WHEN 'G' THEN 'General Audience'
        WHEN 'PG' THEN 'Parental Guidance'
        WHEN 'PG-13' THEN 'Teens 13+'
        WHEN 'R' THEN 'Adults 17+'
        WHEN 'NC-17' THEN 'Adults Only 18+'
    END AS age_recommendation
FROM film f
JOIN movie_rentals mr ON f.film_id = mr.film_id;

-- Which actors/actresses didn't act for a longer period of time than the others?
--1
SELECT 
    a.first_name, 
    a.last_name, 
    (MAX(f.release_year) - MIN(f.release_year)) AS career_duration
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY career_duration ASC;

--2
SELECT 
    a.first_name, 
    a.last_name, 
    (MAX(f.release_year) - MIN(f.release_year)) AS career_duration
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING (MAX(f.release_year) - MIN(f.release_year)) <= ALL (
    SELECT (MAX(f2.release_year) - MIN(f2.release_year))
    FROM film_actor fa2
    JOIN film f2 ON fa2.film_id = f2.film_id
    GROUP BY fa2.actor_id
)
ORDER BY career_duration, a.last_name;