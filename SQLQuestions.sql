--What is procedure in plsql and it's syntax and difference between procedure and function?

CREATE [OR REPLACE] PROCEDURE procedure_name [(parameter_name [type [IN | OUT | IN OUT] ...])]
IS
  -- Declaration section
BEGIN
  -- Executable section
EXCEPTION
  -- Exception section
END;


CREATE [OR REPLACE] FUNCTION function_name [(parameter_name [type [IN | OUT | IN OUT] ...])]
RETURN return_datatype
IS
  -- Declaration section
BEGIN
  -- Executable section
  RETURN value;
EXCEPTION
  -- Exception section
END;

--The main difference between a procedure and a function is that a function must return a value, 
--but a procedure does not have to. In other words, a function can be used in a SQL statement because it returns a value, but a procedure cannot.

--Q2. What is temp table and temp variable in plsql?

--temp table
CREATE GLOBAL TEMPORARY TABLE temp_table (
  column1  NUMBER,
  column2  VARCHAR2(100)
) ON COMMIT DELETE ROWS;

-- A temporary table is a special type of table that is used to store session-specific data. 
-- The data in a temporary table is private to each session; that is, each session can only see and modify its own data. 
-- The data in a temporary table exists only for the duration of the session or the transaction, depending on how the table is defined. 
-- Temporary tables are useful when you have a large amount of data that you need to manipulate within a single session, but do not need to persist beyond that session.


DECLARE
  temp_variable NUMBER;
BEGIN
  temp_variable := 100;
  DBMS_OUTPUT.PUT_LINE('Temp Variable: ' || temp_variable);
END;

--Q3. A plsql programme to print 103,99,96...3?

BEGIN
  FOR i IN REVERSE 3..103 LOOP
    IF MOD(i, 3) = 1 THEN
      DBMS_OUTPUT.PUT_LINE(i);
    END IF;
  END LOOP;
END;

--Q4. What is mutating table or mutating trigger?

CREATE OR REPLACE TRIGGER employee_biu
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  UPDATE employees SET salary = :NEW.salary * 1.10;
END;
/

--Q5. how to delete duplicate records

DELETE FROM your_table
WHERE ROWID NOT IN
(
  SELECT MIN(ROWID)
  FROM your_table
  GROUP BY column1, column2, ..., columnN
);


SELECT column1, column2, ..., columnN
FROM your_table
UNION
SELECT column1, column2, ..., columnN
FROM your_table;

--Q6. How do you find if two table having similar data?

SELECT * FROM table1
MINUS
SELECT * FROM table2;

--Q7. What is autonomous transaction?

--This is the main advantage of autonomous transactions: they allow you to perform some operations and commit them immediately, 
--regardless of whether the main transaction is committed or rolled back.

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO your_table (column1, column2) VALUES (value1, value2);
  COMMIT;
END;


DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO logs (id, log_message) VALUES (1, 'Inserting new order');
  COMMIT;
END;
/

BEGIN
  INSERT INTO orders (id, customer_name, product_name) VALUES (1, 'John Doe', 'Product 1');
  -- Let's assume that an error occurs here and the transaction is rolled back
  ROLLBACK;
END;
/

--Q12. Truncate vs delete difference?

-- Operation: DELETE is a DML (Data Manipulation Language) command, which means it operates on rows and can be used to delete specific rows from a table. 
--TRUNCATE, on the other hand, is a DDL (Data Definition Language) command, which operates on the table itself and removes all rows from a table.

-- Speed: TRUNCATE is typically faster than DELETE, because it doesn't generate individual row delete statements and doesn't log individual row deletions.

-- Rollback: DELETE operations can be rolled back, because they are logged in the transaction log. 
-- TRUNCATE operations cannot be rolled back, because they do not log individual row deletions.

-- Where Clause: DELETE can be used with a WHERE clause to delete specific rows. 
--TRUNCATE cannot be used with a WHERE clause; it removes all rows from the table.

-- Triggers: DELETE will activate any delete triggers on the table. 
--TRUNCATE will not activate triggers, because it is a DDL command and operates on the table level.

-- Space Reclamation: TRUNCATE will free the space containing the table and its data is returned to the system and can be used for other objects. 
--DELETE retains the space for use by future inserts into the same table.

--DROP: The DROP command is used to remove an entire table or database. 
--It removes the table or database along with all of its data, structure, attributes, and indexes. 
--DROP operations cannot be rolled back.


--How we can eliminate duplicates without using distinct command?

SELECT column1, column2, ..., columnN
FROM your_table
GROUP BY column1, column2, ..., columnN;

SELECT column1, column2, ..., columnN
FROM (
  SELECT your_table.*, ROW_NUMBER() OVER (PARTITION BY column1, column2, ..., columnN ORDER BY column1) AS rn
  FROM your_table
)
WHERE rn = 1;

--what is joins and its types what is the use and what is natural join with example?
SELECT * FROM orders NATURAL JOIN customers;

-- INNER JOIN: Returns records that have matching values in both tables.

-- LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table. If there is no match, the result is NULL on the right side.

-- RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table. If there is no match, the result is NULL on the left side.

-- FULL (OUTER) JOIN: Returns all records when there is a match in either the left or the right table.

-- CROSS JOIN: Returns the Cartesian product of rows from both tables.

-- NATURAL JOIN: A type of join which performs the same task as an INNER or OUTER join, but uses only the columns with the same name in both tables to perform the join.


--Display Top 5 salary

SELECT *
FROM (
  SELECT *
  FROM your_table
  ORDER BY salary DESC
)
WHERE ROWNUM <= 5;


--Write a command of copy the structure only not data of the table?

CREATE TABLE new_table AS SELECT * FROM old_table WHERE 1=0;
--WHERE 1=0 clause ensures that no rows are selected from the existing table

--Replace Only Third Character with *?
SELECT CONCAT(CONCAT(SUBSTR(your_column, 1, 2), '*'), SUBSTR(your_column, 4)) AS new_string
FROM your_table;


--Differentiate Foreign key,primary key and unique key?

-- Primary Key: A primary key is a column (or a combination of columns) in a table that uniquely identifies each row in that table. 
--The primary key constraint enforces that the column(s) must contain unique values and cannot contain NULL values. Each table can have only one primary key.

-- Foreign Key: A foreign key is a column (or a combination of columns) in one table, that is used to "point" to a row in another table. 
--The foreign key constraint enforces that the values in the foreign key column(s) must match the values in the primary key column(s) of the other table. This is used to maintain referential integrity between two tables.

-- Unique Key: A unique key is similar to a primary key in that it enforces that the column(s) must contain unique values. 
--However, unlike a primary key, a unique key column can contain NULL values, and each table can have more than one unique key.

CREATE TABLE Customers (
  CustomerID int PRIMARY KEY,
  Name varchar(255) NOT NULL,
  Email varchar(255) UNIQUE
);

CREATE TABLE Orders (
  OrderID int PRIMARY KEY,
  Product varchar(255) NOT NULL,
  CustomerID int,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--which approach will you choose to return a complete record set from a pl/sql block or a function?
--Ref Cursor: A Ref Cursor is a datatype that holds a cursor reference. 
--You can use a Ref Cursor to return a cursor from a function, which can then be fetched from to retrieve the result set. 
--This is probably the most common way to return a result set from a function in PL/SQL.

CREATE OR REPLACE FUNCTION get_employees RETURN SYS_REFCURSOR IS
  my_cursor SYS_REFCURSOR;
BEGIN
  OPEN my_cursor FOR SELECT * FROM employees;
  RETURN my_cursor;
END;

--difference between user_table, dba_tables & all_tables in oracle?

-- USER_TABLES: This view shows all tables that are owned by the current user. 
--In other words, it shows all tables that the current user has created. 
--It does not show tables owned by other users, even if the current user has access to those tables.

-- DBA_TABLES: This view shows all tables in the database, regardless of who owns them.
-- However, this view is typically only accessible to users with DBA (Database Administrator) privileges.
-- If you're not a DBA, you probably won't be able to access this view.

-- ALL_TABLES: This view shows all tables that the current user has access to. This includes tables owned by the current user, as well as tables owned by other users that the current user has been granted access to.


--what is force view?
--The term "FORCE VIEW" in Oracle SQL refers to the creation of a view even if the underlying base tables do not exist or the query in the view is not fully correct. This is done using the FORCE keyword in the CREATE VIEW statement.

CREATE FORCE VIEW my_view AS SELECT * FROM non_existent_table;

--Difference between soft parsing and hard parsing of sql?

--Hard Parsing: Hard parsing is a stage where the database processes the SQL statement fully. 
--This includes the syntax check, semantic check, and the optimization stages. 
--During hard parsing, Oracle checks the syntax of the SQL statement, validates the schema objects referenced in the statement, and creates an optimal execution plan. 
--Hard parsing is resource-intensive and can affect the performance of the database if every SQL statement is hard parsed.

--Soft Parsing: Soft parsing is a lighter operation where the database checks whether the SQL statement has been executed before and is present in the shared pool (part of the system global area, or SGA, where parsed SQL statements are stored).
--If it is, Oracle reuses the existing parsed representation and skips the resource-intensive steps of hard parsing. This improves the performance of the database.


--Write a sql to find nth highest salary?
SELECT salary
FROM (
  SELECT salary, ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
  FROM employees
) 
WHERE row_num = n;




--what is Redo log buffer

-- The Redo Log Buffer is used to hold information about changes made to the database. 
-- This includes changes to data, changes to database structures, and changes to the state of the database.
--  When a transaction is committed, the contents of the Redo Log Buffer are written to the online redo log files. 
--  This process is known as a redo log write.

--what is  bulk bind?

-- Bulk Bind is a feature in PL/SQL that allows it to process multiple SQL rows at once, rather than processing each row individually. 
--This can significantly improve the performance of SQL operations that affect many rows, such as INSERT, UPDATE, DELETE, and SELECT INTO.

-- Normally, when you execute a SQL statement inside a loop, the SQL engine needs to switch back and forth between the PL/SQL engine and the SQL engine for each iteration of the loop.
-- This context switching can be expensive in terms of performance.

-- With Bulk Bind, you can reduce the context switching by processing many rows in one operation. 
--You do this by using the BULK COLLECT clause to fetch multiple rows into a collection, and the FORALL statement to perform DML operations on multiple rows at once.


DECLARE
  TYPE employee_ids_t IS TABLE OF employees.employee_id%TYPE;
  employee_ids employee_ids_t;
BEGIN
  SELECT employee_id BULK COLLECT INTO employee_ids FROM employees;

  FORALL i IN employee_ids.FIRST .. employee_ids.LAST
    UPDATE employees SET salary = salary * 1.1 WHERE employee_id = employee_ids(i);
END;


--NO_DATA_FOUND: This exception is raised when a SELECT ... BULK COLLECT INTO statement returns no rows. 
--However, unlike a regular SELECT INTO statement, a BULK COLLECT INTO statement does not raise the NO_DATA_FOUND exception if no rows are returned. 
--Instead, it simply leaves the collection empty.

--TOO_MANY_ROWS: This exception is raised when a SELECT INTO statement returns more than one row. 
--But when using BULK COLLECT, this exception will not be raised even if the SELECT statement returns multiple rows, because BULK COLLECT is designed to handle multiple rows.


--Predefined exception , nonpredefined exception, raise, raise application error?

-- Predefined Exceptions: These are exceptions that are automatically defined by Oracle Database. 
--Each predefined exception has an error code and an associated error message. 
--For example, NO_DATA_FOUND is a predefined exception that is raised when a SELECT INTO statement returns no rows.

-- Non-Predefined Exceptions: These are exceptions that you define yourself in the declarative part of a PL/SQL block, subprogram, or package. 
--You can associate a non-predefined exception with a specific Oracle error number using the PRAGMA EXCEPTION_INIT statement.

-- RAISE Statement: The RAISE statement in PL/SQL is used to explicitly raise an exception during the execution of the PL/SQL block. 
--It stops normal execution of the block and transfers control to the exception handlers.

-- RAISE_APPLICATION_ERROR Procedure: This is a built-in procedure in Oracle PL/SQL that allows you to issue user-defined error messages from stored subprograms. 
--This procedure allows you to create your own error messages and assign specific error numbers to them, which can be useful for handling errors and debugging.


DECLARE
  employee_id employees.employee_id%TYPE := 100;
  employee_name employees.employee_name%TYPE;
  no_employee_found EXCEPTION; -- Non-predefined exception
  PRAGMA EXCEPTION_INIT(no_employee_found, -20001);
BEGIN
  SELECT employee_name INTO employee_name FROM employees WHERE employee_id = employee_id;
  
  EXCEPTION
    WHEN no_employee_found THEN
      RAISE_APPLICATION_ERROR(-20001, 'No employee found with ID ' || employee_id);
    WHEN OTHERS THEN
      RAISE; -- Re-raise the current exception
END;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Collection --> Group of values --> all the values are of the same type --> accessed through an index 

--- Associative Array --> key:value 
    -- String-indexed collection 
    --INDEX BY PLS_INTEGER or BINARY_INTEGER
--Nested tables -> can have any number of elements
--Varrays --> Ordered Collections of element 



---------------------------------------------------------------------------------------------------------------
--Return the total number of comments received for each user in the 30 or less days before 2020-02-10. Don't output users who haven't received any comment in the defined time perio
select user_id ,count(*) as number_of_comments
from fb_comments_count
where created_at >= TO_DATE('2020-02-10', 'YYYY-MM-DD') - 30
and created_at < TO_DATE('2020-02-10', 'YYYY-MM-DD')
group by user_id


--Return the total number of posts made on each calendar day of the month, aggregated across all months and years (ignoring user and year).
select TO_NUMBER(TO_CHAR(POST_DATE,'DD')) day_of_month, count(*)
from facebook_posts
group by TO_NUMBER(TO_CHAR(POST_DATE,'DD'))
order by TO_NUMBER(TO_CHAR(POST_DATE,'DD')) desc

---Find users who are both a viewer and streamer.

SELECT user_id
FROM sessions
GROUP BY user_id
HAVING COUNT(DISTINCT session_type) = 2

--Calculate the average session duration (in seconds) for each session type?
select AVG((CAST(SESSION_END as date) - CAST(SESSION_START as date))*24*60*60),SESSION_TYPE --CAST is used to convert the date to seconds
from twitch_sessions
group by SESSION_TYPE

--Calculates the difference between the highest salaries in the marketing and engineering departments. Output just the absolute difference in salaries.
SELECT 
    ABS(
        MAX(CASE WHEN d.department = 'marketing' THEN e.salary END) -
        MAX(CASE WHEN d.department = 'engineering' THEN e.salary END)
    ) AS abs_salary_diff
FROM db_employee e
JOIN db_dept d
    ON e.department_id = d.id


--We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.
select id,first_name,last_name,department_id,max(salary) current_salary
from ms_employee_salary
group by id,first_name,last_name,department_id
order by id

--Write a query that returns the user ID of all users that have created at least one ‘Refinance’ submission and at least one ‘InSchool’ submission.
SELECT user_id
FROM loans
WHERE type IN ('Refinance', 'InSchool')
GROUP BY user_id
HAVING COUNT(DISTINCT CASE WHEN type = 'Refinance' THEN 1 END) > 0
   AND COUNT(DISTINCT CASE WHEN type = 'InSchool' THEN 1 END) > 0


--Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.
select c.id,c.first_name,SUM(o.total_order_cost)
from customers c, orders o
where c.id = o.cust_id
group by c.id,c.first_name
order by c.first_name


--Find the job titles of the employees with the highest salary. If multiple employees have the same highest salary, include the job titles for all such employees.
select t.worker_title
from worker w , title t
where w.WORKER_ID = t.worker_ref_id 
and Salary = (select MAX(salary) from worker )

--Find libraries from the 2016 circulation year that have no email address provided but have their notice preference set to email. In your solution, output their home library code.
select HOME_LIBRARY_DEFINITION
from library_usage
where year_patron_registered = '2016'
and notice_preference_definition = 'email'
and provided_email_address ='0'

--Find the last time each bike was in use. Output both the bike number and the date-timestamp of the bike's last use (i.e., the date-time the bike was returned). Order the results by bikes that were most recently used.
SELECT
    bike_number,
    MAX(end_time) AS last_use_time
FROM
    dc_bikeshare_q1_2012
GROUP BY
    bike_number
ORDER BY
    last_use_time DESC


--Compare each employee's salary with the average salary of the corresponding department.Output the department, first name, and salary of employees along with the average salary of that department.
select e.department,
e.first_name,
e.salary,
AVG(e2.salary)
from employee e , employee e2
where e2.department = e.department
group by e.department,
e.first_name,
e.salary
order by e.department , e.first_name


--Find the details of each customer regardless of whether the customer made an order. Output the customer's first name, last name, and the city along with the order details.Sort records based on the customer's first name and the order details in ascending order.
select c.first_name,c.last_name,c.city,o.order_details 
from customers c , orders o --LEFT JOIN orders o ON c.id = o.cust_id
where c.id = o.cust_id(+)
order by c.first_name,c.last_name

--Find the average number of bathrooms and bedrooms for each city’s property types. Output the result along with the city name and the property type.
select AVG(bedrooms),AVG(bathrooms),city,property_type
from airbnb_search_details
group by city,property_type


--Write a query that will calculate the number of shipments per month. The unique key for one shipment is a combination of shipment_id and sub_id. Output the year_month in format YYYY-MM and the number of shipments in that month.
select COUNT(CONCAT(shipment_id,sub_id)),TO_CHAR(shipment_date,'YYYY-MM') month
from amazon_shipment
group by TO_CHAR(shipment_date,'YYYY-MM')
order by month


--Find the growth rate of active users for Dec 2020 to Jan 2021 for each account. The growth rate is defined as the number of users in January 2021 divided by the number of users in Dec 2020. Output the account_id and growth rate.
WITH cte AS (
  SELECT 
    COUNT(DISTINCT user_id) AS active_user,
    account_id,
    TO_CHAR(record_date, 'YYYY-MM') AS year_month
  FROM sf_events
  WHERE TO_CHAR(record_date, 'YYYY-MM') IN ('2020-12', '2021-01')
  GROUP BY account_id, TO_CHAR(record_date, 'YYYY-MM')
)
SELECT 
  account_id,
  ROUND(
    SUM(CASE WHEN year_month = '2021-01' THEN active_user END) /
    NULLIF(SUM(CASE WHEN year_month = '2020-12' THEN active_user END), 0),
    2
  ) AS growth_rate
FROM cte
GROUP BY account_id


--Count the number of unique users per day who logged in from both a mobile device and web. Output the date and the corresponding number of users.
With mobile_distinct_users as 
(
select distinct user_id , log_date
from mobile_logs
), web_distinct_users as
(
select distinct user_id , log_date
from web_logs
),
both_platforms as
(
select mdu.user_id , mdu.log_date
from mobile_distinct_users mdu , web_distinct_users wdu
where mdu.user_id = wdu.user_id
)
select count(distinct user_id) , log_date
from both_platforms
group by log_date


--2018 Return a list of users with status free who didn’t make any calls in Apr 2020.
select rc.USER_ID
from rc_calls rc , rc_users ru
where rc.USER_ID = ru.USER_ID
and ru.status = 'free'
AND not exists (
select 1
from rc_calls
where TO_CHAR(Call_date,'YYYY-MM') = '2020-04'
and USER_ID = rc.USER_ID
)


--2024 Write a query that returns the number of unique users per client for each month. Assume all events occur within the same year, so only month needs to be be in the output as a number from 1 to 12.
select count(distinct USER_ID),CLIENT_ID,to_number(to_char(time_id,'MM'))
from fact_events
group by CLIENT_ID,to_char(time_id,'MM')

--2039 Find the number of unique transactions and total sales for each of the product categories in 2017. Output the product categories, number of transactions, and total sales in descending order. The sales column represents the total cost the customer paid for the product so no additional calculations need to be done on the column.
--Only include product categories that have products sold.
select count(distinct transaction_id) , SUM(sales) , PRODUCT_CATEGORY
from wfm_transactions wt , wfm_products wp 
where wt.product_id = wp.product_id 
and to_char(transaction_date,'YYYY') = '2017'
group by PRODUCT_CATEGORY
having SUM(sales) > 0



--2043 Return all employees who have never had an annual review. Your output should include the employee's first name, last name, hiring date, and termination date. List the most recently hired employees first.
select ue.first_name , ue.last_name ,hire_date,Termination_date
from uber_employees ue
where not exists (
select 1 
from uber_annual_review uar
where ue.id = uar.emp_id)
order by ue.hire_date desc


select ue.first_name , ue.last_name ,ue.hire_date,Termination_date
from uber_employees ue
Left join uber_annual_review uar
ON ue.id = uar.emp_id
where uar.emp_id is Null
order by ue.hire_date desc


--2049 Uber is interested in identifying gaps in their business. Calculate the count of orders for each status of each service. Your output should include the service name, status of the order, and the number of orders.
select service_name , status_of_order,SUM(number_of_orders)
from uber_orders
group by service_name,status_of_order

--2051 Find the monthly active users for January 2021 for each account. Your output should have account_id and the monthly count for that account.
select account_id,count(user_id)
from sf_events
where to_char(Record_date,'YYYY-MM') = '2021-01'
group by account_id

--2057 Write a query to find the weight for each shipment's earliest shipment date. Output the shipment id along with the weight.
select  SHIPMENT_ID , weight
from amazon_shipment b
where SHIPMENT_DATE = (select min(SHIPMENT_DATE) from amazon_shipment a where a.SHIPMENT_ID = b.SHIPMENT_ID)

SELECT 
        SHIPMENT_ID,
        WEIGHT,
        SHIPMENT_DATE,
        ROW_NUMBER() OVER (PARTITION BY SHIPMENT_ID ORDER BY SHIPMENT_DATE) AS rn
    FROM amazon_shipment

--2058 Calculate the total weight for each shipment and add it as a new column. Your output needs to have all the existing rows and columns in addition to the  new column that shows the total weight for each shipment. One shipment can have multiple rows.
select shipment_id,
sub_id,
weight,
shipment_date,
SUM(weight) OVER (PARTITION BY SHIPMENT_ID) as total_weight
from amazon_shipment


--2061 Count the number of users who made more than 5 searches in August 2021.
SELECT COUNT(*)
FROM (
    SELECT user_id
    FROM fb_searches
    WHERE date >= '2021-08-01' AND date < '2021-09-01'
    GROUP BY user_id
    HAVING COUNT(search_id) > 5
) AS user_counts


--2062 How many searches were there in the second quarter of 2021?
SELECT COUNT(*)
FROM fb_searches
WHERE date >= '2021-04-01' AND date < '2021-07-01'

--2063 You are given a list of exchange rates from various currencies to US Dollars (USD) in different months. Show how the exchange rate of all the currencies changed in the first half of 2020. Output the currency code and the difference between values of the exchange rate between July 1, 2020 and January 1, 2020.
SELECT 
    jan.SOURCE_CURRENCY,
    jul.EXCHANGE_RATE - jan.EXCHANGE_RATE AS RATE_DIFFERENCE
FROM sf_exchange_rate jan
JOIN sf_exchange_rate jul
  ON jan.SOURCE_CURRENCY = jul.SOURCE_CURRENCY
  AND jan.date = TO_DATE('2020-01-01', 'YYYY-MM-DD')
  AND jul.date = TO_DATE('2020-07-01', 'YYYY-MM-DD')


--2067 What percentage of all products are both low fat and recyclable?
SELECT 
    ROUND(
        (COUNT(CASE WHEN is_low_fat = 'Y' AND is_recyclable = 'Y' THEN 1 END) * 100.0) 
        / COUNT(*), 
    2) AS percentage_both_lowfat_recyclable
FROM 
    facebook_products


--2069 The marketing manager wants you to evaluate how well the previously ran advertising campaigns are working.Particularly, they are interested in the promotion IDs from the online_promotions table.Find the percentage of orders with promotion IDs from the online_promotions table applied
SELECT 
  ROUND(
    (COUNT(CASE WHEN o.promotion_id IN (SELECT promotion_id FROM online_promotions) THEN 1 END) * 100.0) 
    / COUNT(*), 
  2) AS percentage_orders_with_valid_promotion
FROM 
  online_orders o



-- 2072 For each platform (e.g. Windows, iPhone, iPad etc.), calculate the number of users. Consider unique users and not individual sessions. Output the name of the platform with the corresponding number of users.
select count(distinct USER_ID),PLATFORM
from user_sessions
group by PLATFORM

--2083 -- Count how many claims submitted in December 2021 are still pending. A claim is pending when it has neither an acceptance nor rejection date.
select count(*)
from cvs_claims
where to_char(Date_submitted,'YYYY-MM') = '2021-12'
and date_accepted is null 
and date_rejected is null 

-- 2091 For each video game player, find the latest date when they logged in.
select player_id,MAX(login_date)
from players_logins
group by player_id

-- 2100 Given the education levels and salaries of a group of individuals, find what is the average salary for each level of education.
select education , avg(salary)
from google_salaries
group by education 


-- 2107 Write a query to return all Customers (cust_id) who are violating primary key constraints in the Customer Dimension (dim_customer) i.e. those Customers who are present more than once in the Customer Dimension.
--For example if cust_id 'C123' is present thrice then the query should return two columns, value in first should be 'C123', while value in second should be 3
select cust_id,count(*)
from dim_customer
group by cust_id
having count(*) > 1



-- 2109 Write a query to get a list of products that have not had any sales. Output the ID and market name of these products.
select dp.PROD_SKU_ID
from dim_product dp
where not exists (
select 1 from fct_customer_sales fcs where  dp.PROD_SKU_ID = fcs.PROD_SKU_ID )

SELECT 
  dp.prod_sku_id, 
  dp.market_name
FROM 
  dim_product dp
LEFT JOIN 
  fct_customer_sales fcs 
ON 
  dp.prod_sku_id = fcs.prod_sku_id
WHERE 
  fcs.prod_sku_id IS NULL



  
