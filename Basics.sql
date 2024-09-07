--Variables---
--Labeled Storage locations --


-- DECLARE
-- v_sal NUMBER(8,2); 
-- BEGIN
--     select salary into v_sal
--     from EMPLOYEES
--     where EMPLOYEE_ID = 132;

--     DBMS_OUTPUT.PUT_LINE('Sal' || v_sal || ' of Emp');

--     UPDATE EMPLOYEES
--     set salary = v_sal + 100
--     where EMPLOYEE_ID = 100;
-- end;



-- select * from EMPLOYEES where EMPLOYEE_ID = 100;


--declaring and initializing pl/sql variables 

-- Declare   
--     v_name VARCHAR2(20);
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE(v_name || ' 1st');
--     v_name := 'John';
--      DBMS_OUTPUT.PUT_LINE(v_name || ' 2nd');
-- END;






------Types of Variables-------------------------------
--Scalar
--Refrence 
--Large Object (LOB)
--Composite
--Non-PL/SQL variables --> Bind variables 


--Data Types for Strings------------------------------- 
--CHAR
--NCHAR
--VARCHAR
--NVARCHAR
--CLOB
--NCLOB


----Delimiters in String Literals---------------------

-- DECLARE
--     v_event varchar2(15);
-- BEGIN
--     v_event := q'[Ma'am]';
--     DBMS_OUTPUT.PUT_LINE(v_event || ' ');
-- end;


--Implicit Conversion

-- Select 1 + '2' from dual;




--Declaring varibles with  %Type Attribute 
--table.column%name 
--employees.last_name%TYPE 


DECLARE
--v_name VARCHAR2(1); --character string buffer too small
v_name EMPLOYEES.FIRST_NAME%TYPE;
v_lname v_name%type;
BEGIN
    select FIRST_NAME,LAST_NAME into v_name,v_lname
    from EMPLOYEES
    where EMPLOYEE_ID = 132;

    

    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_lname);

end;





--LOB datatype
--CLOB --> character large Object
--BLOB --> Binary Large Object
--Binary File (BFILE) --> stored in OS of the server not in DB
--National language character large object(NCLOB)


--------Composite Data Types: Record and Collections---------------------------------
--123  Atlanta 788  --> Record

--PLS_Integer index      VARCHAR2
--    1                        A
--    2                        B
--    3                        C
--    4                        D



-------------------------------------Bind Varibales ---------------------------------------------------------------------------
Declare 
v_sal number;
BEGIN
    Select salary into v_sal from EMPLOYEES where EMPLOYEE_ID = :p_emp_id;
    DBMS_OUTPUT.PUT_LINE(v_sal);
End;


--

VARIABLE b_sal number;

Begin
select salary into :b_sal
from EMPLOYEES
where EMPLOYEE_ID = 100;
end;
/
PRINT b_sal

--


