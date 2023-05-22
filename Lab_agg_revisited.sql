# Lab | Aggregation Revisited - Subqueries

USE sakila;

# 1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT first_name, last_name, email
FROM customer
WHERE active = 1;

# 2. What is the average payment made by each customer (display the customer id, customer name
# (concatenated), and the average payment made).

SELECT P.customer_id, CONCAT(first_name, (" "), last_name) , ROUND(AVG(amount),1)
FROM payment as P
JOIN customer as C
ON P.customer_id = C.customer_id
GROUP BY P.customer_id;

# 3. Select the name and email address of all the customers who have rented the "Action" movies.
# - Write the query using multiple join statements
SELECT DISTINCT(CONCAT(first_name, (" "), last_name)), email 
FROM customer as C
JOIN inventory as I
ON C.store_id = I.store_id
JOIN film_category as F
ON I.film_id = F.film_id
JOIN category as CC
ON F.category_id = CC.category_id
WHERE CC.name = "Action";

# - Write the query using sub queries with multiple WHERE clause and IN condition

SELECT DISTINCT CONCAT(C.first_name, ' ', C.last_name) AS full_name, C.email
FROM customer AS C
WHERE C.store_id IN (
    SELECT I.store_id
    FROM inventory AS I
    WHERE I.film_id IN (
        SELECT F.film_id
        FROM film_category AS F
        WHERE F.category_id IN (
            SELECT CC.category_id
            FROM category AS CC
            WHERE CC.name = 'Action'
        )
    )
);

# - Verify if the above two queries produce the same results or not

# 4. Use the case statement to create a new column classifying existing columns 
# as either or high value transactions based on the amount of payment.
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
# the label should be medium, and if it is more than 4, then it should be high.

SELECT *,
CASE 
 WHEN amount >= 0 AND amount <= 2 THEN "low" 
 WHEN amount >2 AND amount <= 4 THEN "medium"  
 WHEN amount > 4 THEN "high"
END AS value_transactions    
FROM payment;