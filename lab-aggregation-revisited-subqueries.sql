USE sakila;

# 1.Select the first name, last name, and email address of all the customers who have rented a movie.

Select c.customer_id,c.first_name,c.last_name,c.email,r.rental_date
from customer as c
join rental as r on c.customer_id=r.customer_id
group by c.customer_id;

# 2.What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

Select c.customer_id,concat(c.first_name,' ',c.last_name) as full_name, round(avg(p.amount),2) as average_payment
from customer as c
join payment as p on c.customer_id=p.customer_id
group by c.customer_id, full_name;

# 3.Select the name and email address of all the customers who have rented the "Action" movies.

		# 3.a Write the query using multiple join statements

Select concat(c.first_name,' ',c.last_name) as full_name,c.email,cat.name
from customer as c
join rental as r on r.customer_id=c.customer_id
join inventory as i on i.inventory_id=r.inventory_id
join film as f on f.film_id=i.film_id
join film_category as f_cat on f_cat.film_id=f.film_id
join category as cat on f_cat.category_id=cat.category_id
where cat.name='Action'
group by c.email,full_name;

		# 3.b Write the query using sub queries with multiple WHERE clause and IN condition

Select concat(c.first_name,' ', c.last_name) AS full_name,c.email
from customer as c
where c.customer_id in (Select r.customer_id from rental as r where r.inventory_id in (Select i.inventory_id from inventory as i
where i.film_id in (Select film_cat.film_id from film_category as film_cat where film_cat.category_id in (Select cat.category_id from category as cat
where cat.name = 'Action'))))
group by c.email,full_name;

		# 3.c Verify if the above two queries produce the same results or not
		# We can see that above two queries return the same result as 510 rows.


# 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

Select*,
Case when amount between 0 and 2 then 'Low' when amount between 2 and 4 then 'Medium' else 'High' 
end as payment_score
from payment;






