/*1a. Display the first and last names of all actors from the table actor.*/

USE 		sakila;
SELECT		first_name AS "First Name", last_name AS "Last Name"
FROM		actor;

/*1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.*/

SELECT		concat(first_name, " ", last_name) AS "Actor Name"
FROM		actor;

/*2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information?*/

SELECT		actor_id, first_name, last_name
FROM		actor
WHERE		first_name IN ("Joe");

/*2b. Find all actors whose last name contain the letters GEN*/

SELECT		concat(first_name, " ", last_name) AS "Actor Name"
FROM		actor
WHERE		last_name LIKE '%gen%';

/*2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order*/

SELECT		first_name AS "First Name", last_name AS "Last Name"
FROM		actor
WHERE		last_name LIKE '%LI%'
ORDER BY	last_name, first_name;

/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China*/

SELECT		country_id, country
FROM		country
WHERE		country IN ("AFGHANISTAN", "BANGLADESH", "CHINA");

/*3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
so create a column in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).*/

ALTER TABLE	actor
ADD COLUMN	description BLOB AFTER last_name;

SELECT		*
FROM		actor;

/*3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.*/

ALTER TABLE	actor
DROP COLUMN description;

SELECT		*
FROM 		actor;

/*4a. List the last names of actors, as well as how many actors have that last name.*/

SELECT		last_name AS "Last Name", COUNT(last_name) AS "Actor Count"
FROM		actor
GROUP BY	last_name;

/*4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors*/

SELECT		last_name AS "Last Name", COUNT(last_name) AS "Actor Count"
FROM		actor
GROUP BY	last_name
HAVING		COUNT(last_name)>=2;

/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
Write a query to fix the record.*/

update 		actor
set 		first_name = "HARPO"
where		first_name = "GROUCHO" AND last_name = "WILLIAMS";

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/

update 		actor
set 		first_name="GROUCHO"
where		first_name = "HARPO";

/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it?*/

SHOW CREATE TABLE address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
Use the tables staff and address*/

SELECT 		staff.first_name, staff.last_name, address.address
FROM 		staff
INNER JOIN 	address
ON			staff.address_id=address.address_id;

/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment.*/

SELECT 		staff.first_name, staff.last_name, SUM(payment.amount) AS "Total"
FROM 		staff
INNER JOIN 	payment
ON			staff.staff_id=payment.staff_id
WHERE		payment.payment_date LIKE '%2005-08%'
GROUP BY	staff.first_name;

/*6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join.*/

SELECT 		film.title, COUNT(film_actor.actor_id) AS "Number of Actors"
FROM 		film
INNER JOIN 	film_actor
ON			film.film_id=film_actor.film_id
GROUP BY	film.title;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

SELECT		COUNT(inventory_id) AS "Copies of Hunchback Impossible"
FROM		inventory
WHERE		film_id IN(
	SELECT		film_id
    FROM		film
    WHERE		title IN("Hunchback Impossible")
    )
;

/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name*/

SELECT 		customer.first_name,customer.last_name, SUM(payment.amount) AS "Total Paid"
FROM 		payment
INNER JOIN 	customer
ON			customer.customer_id=payment.customer_id
GROUP BY	customer.last_name
ORDER BY	customer.last_name;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/

SELECT		title
FROM		film
WHERE		(title LIKE "Q%" OR title LIKE "K%") AND language_id IN(
	SELECT 		language_id
    FROM		language
    WHERE		name="English"
    )
;



/*7b. Use subqueries to display all actors who appear in the film Alone Trip.*/

select		first_name, last_name
from		actor
where		actor_id in (
	select		actor_id
	from		film_actor
	where		film_id in(
		select		film_id
		from		film
		where		title in ("Alone Trip")
		)
	);
    
/*7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers.
 Use joins to retrieve this information.*/
 
SELECT 		customer.first_name,customer.last_name, customer.email
FROM 		customer
INNER JOIN 	address
ON			customer.address_id=address.address_id
WHERE		address.city_id IN (
		SELECT		city_id
        FROM		city
        WHERE		country_id IN (
				SELECT		country_id
                FROM		country
                WHERE		country="Canada"
                )
        )
; 

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/

SELECT		title
FROM		film
WHERE		film_id IN(
		SELECT 		film_id
        FROM		film_category
        WHERE		category_id IN(
				SELECT		category_id
                FROM		category
                WHERE		name="FAMILY"
                )
		)
;

/*7e. Display the most frequently rented movies in descending order.*/
SELECT 		film.title, COUNT(inventory.inventory_id) AS Rental_Count
FROM 		film
INNER JOIN 	inventory
ON			film.film_id=inventory.film_id
WHERE		inventory.inventory_id IN (
			SELECT		inventory_id
            FROM		rental
            )
GROUP BY	film.title
ORDER BY	Rental_Count DESC
;

/*7f. Write a query to display how much business, in dollars, each store brought in.*/

SELECT		staff.store_id as Store, SUM(payment.amount) as "Total Business"
FROM		staff
INNER JOIN	payment
ON			payment.staff_id=staff.staff_id
GROUP BY	Store;

select * from store;

/*7g. Write a query to display for each store its store ID, city, and country.*/

SELECT		store.store_id, city.city, country.country
FROM		store
INNER JOIN	address
ON			address.address_id=store.address_id
INNER JOIN	city
ON			address.city_id=city.city_id
INNER JOIN	country
ON			city.country_id=country.country_id;

/*7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

SELECT		category.name AS Category, SUM(payment.amount) AS Gross_revenue
FROM		category
INNER JOIN	film_category
ON			film_category.category_id=category.category_id
INNER JOIN	inventory
ON			inventory.film_id=film_category.film_id
INNER JOIN	rental
ON			rental.inventory_id=inventory.inventory_id
INNER JOIN	payment
ON			payment.rental_id=rental.rental_id
GROUP BY	Category
ORDER BY	Gross_revenue
LIMIT		5;

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/

CREATE VIEW top_genres AS
SELECT		category.name AS Category, SUM(payment.amount) AS Gross_revenue
FROM		category
INNER JOIN	film_category
ON			film_category.category_id=category.category_id
INNER JOIN	inventory
ON			inventory.film_id=film_category.film_id
INNER JOIN	rental
ON			rental.inventory_id=inventory.inventory_id
INNER JOIN	payment
ON			payment.rental_id=rental.rental_id
GROUP BY	Category
ORDER BY	Gross_revenue
LIMIT		5;

/*8b. How would you display the view that you created in 8a?*/

SELECT * FROM top_genres;

/*8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/

DROP VIEW top_genres;