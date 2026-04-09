--Choose one of your favorite films and add it to the "film" table. Fill in rental rates with 4.99 and rental durations with 2 weeks.
--Add the actors who play leading roles in your favorite film to the "actor" and "film_actor" tables (three or more actors in total).
--Add your favorite movies to any store's inventory.

select * from film f ;

insert into film (title, language_id, rental_duration, rental_rate)
values 
	('1+1','1','2','4.99');

select * from actor;
select * from film_actor;

select * from film f 
where f.title ='1+1';

insert into actor (first_name, last_name)
values
	('Francois','Cluzet'),
	('Omar','Sy'),
	('Anne','Le Ny');

insert into film_actor (actor_id, film_id)
values 
	('201','1002'),
	('202','1002'),
	('203','1002');

select * from store;
select * from inventory i ;

insert into inventory (film_id, store_id)
values
	('1002','1');
