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