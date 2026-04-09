--Alter the rental duration and rental rates of the film you inserted before to three weeks and 9.99, respectively.
select * from film 
where film_id='1002';

update film
set 
rental_duration='3',
rental_rate='9.99'
where film_id='1002';

--Alter any existing customer in the database with at least 10 rental and 10 payment records. Change their personal data to yours (first name, last name, address, etc.). You can use any existing address from the "address" table. Please do not perform any updates on the "address" table, as this can impact multiple records with the same address.
--Change the customer's create_date value to current_date.

select * from customer;
select * from rental r 
where r.customer_id ='1';

SELECT c.customer_id
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT r.rental_id) >= 10 
   AND COUNT(DISTINCT p.payment_id) >= 10
LIMIT 1;

update customer
set first_name ='Madina',
last_name='Yakubzhanova',
email='maddi.19@mail.ru',
address_id ='5',
create_date = CURRENT_DATE
where customer_id ='1';

select * from customer c 
where c.customer_id ='1';