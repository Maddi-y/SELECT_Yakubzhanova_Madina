--Remove a previously inserted film from the inventory and all corresponding rental records

select * from film where film_id ='1002';

select * from rental;
select * from inventory i ;
select * from film_actor fa ;
select * from payment p ;


DELETE FROM payment 
WHERE rental_id IN (SELECT rental_id FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = '1002'));

DELETE FROM rental 
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = '1002');

DELETE FROM inventory WHERE film_id = '1002';

DELETE FROM film_actor WHERE film_id = '1002';

DELETE FROM film_category WHERE film_id = '1002';

DELETE FROM film WHERE film_id = '1002';

--Remove any records related to you (as a customer) from all tables except "Customer" and "Inventory"

select * from customer c 
where c.email ='maddi.19@mail.ru';

select * from payment p 
where p.customer_id ='1';

select * from rental
where customer_id ='1';

DELETE FROM payment 
WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'maddi.19@mail.ru');

DELETE FROM rental 
WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'maddi.19@mail.ru');


/*TRUNCATE очищает все значения полей таблицы полностью
/*DELETE удаляет записи с условием WHERE
/*Есть еще CASCADE который применяется с DELETE он удаляет запись во всех таблицах, где есть связь по внешнему ключу