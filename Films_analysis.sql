-- In this document, we will analyze the DVD RENTAL database that displays DVD rental data. This 
-- represents the business processes of a DVD rental store.

-- A series of questions will be asked and through queries we will seek to answer the questions.

-- Question # 1. -- What are the available movies that are rated 'PG' or 'PG-13', 
-- and their rental duration is between 5 to 6, and their size (length) is greater than 180?


SELECT 
TITLE, DESCRIPTION, RENTAL_DURATION,
LENGTH
FROM FILM
WHERE (RATING='PG' OR RATING ='PG-13')
AND RENTAL_DURATION BETWEEN 5 AND 6
AND LENGTH >180;


-- RESULTS OBTAINED
-- A total of 7 available movies are shown that are classified with a rating of 'PG' or 'PG-13',
-- in which their rental duration is between 5 to 6, and their size (length) is greater than 180.

-- Question # 2.
--Who are all the customers who rented videos but must comply with: The Last Name is 'Simpson',
-- the inventory_id is 2580 or 596, and the store where it was rented is 1.
-- Show them with their First Name, Last Name and email


SELECT 
C.CUSTOMER_ID, 
CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS "NOMBRE CLIENTE",
C.EMAIL,
I.INVENTORY_ID,
I.STORE_ID

FROM 
RENTAL AS R

JOIN 
CUSTOMER AS C ON R.CUSTOMER_ID = C.CUSTOMER_ID

JOIN
INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID

WHERE 
LAST_NAME = 'Simpson'
AND (I.INVENTORY_ID = 2580 OR I.INVENTORY_ID = 596)
AND I.STORE_ID = 1

-- RESULTS OBTAINED
-- The results show that there is a person who rented videos with the following characteristics:
-- The last name is ‘Simpson’, the inventory_id is 2580 or 596, and the store where it was rented is 1.

-- Question # 3.
-- Create a list of all the movies in ‘English’ and whose movie title
-- contains ‘Egg’ somewhere. Film and language can be joined

SELECT
F.TITLE AS "MOVIE NAME",
L.NAME AS "LANGUAGE"

FROM 
FILM AS F

JOIN
LANGUAGE AS L ON L.LANGUAGE_ID = F.LANGUAGE_ID

WHERE L.NAME = 'English'
AND F.TITLE LIKE '%Egg%'

-- RESULTS OBTAINED
-- The search shows that there are 3 movies with the language in ‘English’ and whose title of the movie
-- contains ‘Egg’ somewhere.

-- Question # 4.
-- What are the movies whose actor has the name ‘Penelope’, the movie has
-- a rental rate of 0.99 and a size (length) of 175?

SELECT
F.TITLE,
F.LENGTH,
F.RENTAL_RATE,
A.FIRST_NAME, 
A.LAST_NAME

FROM 
FILM AS F

JOIN 
FILM_ACTOR AS FA ON FA.FILM_ID = F.FILM_ID

JOIN
ACTOR AS A ON A.ACTOR_ID = FA.ACTOR_ID

WHERE
A.FIRST_NAME = 'Penelope'
AND F.LENGTH = 175
AND F.RENTAL_RATE = 0.99

-- RESULTS OBTAINED
-- There is a movie in which the actress is named 'Penelope', the movie has a rental rate of 0.99 and a length of 175.

-- Question # 5.
-- What are the countries where the Video Rental company is present?
-- Include the number of customers in that country, and the total sales made to date.

SELECT 
C.COUNTRY AS "COUNTRY",
COUNT(CU.CUSTOMER_ID) AS "TOTAL OF CLIENTES",
SUM(P.AMOUNT) AS "TOTAL OF SALES"

FROM COUNTRY AS C

JOIN 
CITY AS CI ON CI.COUNTRY_ID = C.COUNTRY_ID

JOIN
ADDRESS AS A ON A.CITY_ID = CI.CITY_ID

JOIN
CUSTOMER AS CU ON CU.ADDRESS_ID = A.ADDRESS_ID

JOIN
PAYMENT AS P ON P.CUSTOMER_ID = CU.CUSTOMER_ID

GROUP BY C.COUNTRY
ORDER BY "TOTAL OF SALES" DESC

-- RESULTS OBTAINED
-- There are 108 countries where the Video Rental company is present. India, China and the United States
-- lead the list of the highest number of sales of all countries.

-- Question # 6.
-- How many movies are in the category of “Action”, “Comedy”
-- or “Family”?

SELECT 
CASE 
	WHEN C.NAME = 'Action' THEN 'ACTION'
	WHEN C.NAME = 'Comedy' THEN 'COMEDY'
	WHEN C.NAME = 'Family' THEN 'FAMILY'
END AS CATEGORIA,
COUNT (FC.FILM_ID) AS "TOTAL OF VIDEOS"

FROM CATEGORY AS C

JOIN FILM_CATEGORY AS FC ON FC.CATEGORY_ID = C.CATEGORY_ID

WHERE
C.NAME IN ('Action', 'Comedy', 'Family')

GROUP BY C.NAME;

-- RESULTS OBTAINED
-- The number of movies that fall into the “Action”, “Comedy” or “Family” categories
-- are 64, 58 and 69 respectively.

-- Question # 7.
-- How many clients have the first name ‘Grace’, how many actresses
-- have the first name ‘Susan’ and how many employees (staff) have the first name
-- ‘Mike’?

SELECT 'Clients named Grace' AS tipo, COUNT(*) AS "TOTAL"
FROM CUSTOMER
WHERE FIRST_NAME = 'Grace'

UNION ALL 

SELECT 'Actors named Susan' AS tipo, COUNT(*) AS "TOTAL"
FROM ACTOR
WHERE FIRST_NAME = 'Susan'

UNION ALL 

SELECT 'Employees named Mike' AS tipo, COUNT(*) AS "TOTAL"
FROM STAFF
WHERE FIRST_NAME = 'Mike'

-- RESULTS OBTAINED
-- There is 1 customer named Grace, 2 actresses named Susan, and an employee named Mike.

-- Question # 8.
-- What are all the movies that have been rented between the dates
-- May 25, 2005 to May 26, 2005? Please include the rental ticket number,
-- the rental date, the first and last name of the employee who rented it,
-- the title and description of the movie.

SELECT
R.RENTAL_ID "RENT TICKET",
R.RENTAL_DATE AS "DATE",
CONCAT (S.FIRST_NAME, S.LAST_NAME) AS "NAME OF THE STAFF",
F.FILM_ID,
F.TITLE AS "TITLE",
F.DESCRIPTION AS "DESCRIPTION"

FROM 
STAFF AS S
JOIN
RENTAL AS R ON R.STAFF_ID = S.STAFF_ID
JOIN 
INVENTORY AS I ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN
FILM AS F ON F.FILM_ID = I.INVENTORY_ID 

WHERE
R.RENTAL_DATE BETWEEN '2005-05-25' AND '2005-05-26'

ORDER BY 
  R.RENTAL_DATE DESC;

-- RESULTS OBTAINED
-- A total of 33 movies rented between the dates of May 25, 2005 and May 26, 2005 are shown.

-- Question # 9.
-- Which movies have special features such as deleted scenes or behind-the-scenes scenes?

SELECT 
FILM_ID,
TITLE AS "TITLE OF THE MOVIE",
SPECIAL_FEATURES AS "SPECIAL FEATURES",
DESCRIPTION AS "DESCRIPTION"

FROM FILM

WHERE 
  SPECIAL_FEATURES @> ARRAY['Behind the Scenes']
  OR SPECIAL_FEATURES @> ARRAY['Deleted Scenes'];

-- RESULTS OBTAINED
-- A total of 794 movies were found with special scenes such as deleted scenes or behind the scenes.

-- Question # 10.
-- Which customers bought from store 1? Please show the First Name,
-- Last Name of the customer, and the last date they rented something from that store.

SELECT
C.CUSTOMER_ID,
C.FIRST_NAME AS "FIRST NAME", 
C.LAST_NAME AS "SURNAME",
C.STORE_ID,
MAX(R.RENTAL_DATE) AS "LAST DATE" 

FROM RENTAL AS R
JOIN
CUSTOMER AS C ON C.CUSTOMER_ID = R.CUSTOMER_ID

WHERE
C.STORE_ID = 1
GROUP BY 
  C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.STORE_ID
ORDER BY 
  "LAST DATE" DESC;

-- RESULTS OBTAINED
-- 326 customer IDs are shown for those renting or purchasing from store 1.