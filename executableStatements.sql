--Lexical Units --> building blocks of any pl/sql block
                --Identifiers --> v_name , c_percent
                --Delimiters:;,+,-
                --Literals:John,428
                --Comments:--./* */


DECLARE
v_sal number := max(1); --function or pseudo-column 'MAX' may be used inside a SQL statement only
--cannot use group by functions with plsql objects
begin
null;
end;



-------------------------------SQL functions in PL/SQL---------------------------------------------------

--get the number of months --> v_tenure = MONTHS_BETWEEN(CURRENT_DATE,v_hiredate)


-----------Using Sequences in PL/SQL block---------------------
--initial Value ---Increment---> Final Value

CREATE SEQUENCE emp_sequence
INCREMENT by 1
START WITH 1
NOMAXVALUE;

/
DECLARE
v_new_id NUMBER;
BEGIN
v_new_id := emp_sequence.NEXTVAL;
DBMS_OUTPUT.PUT_LINE(v_new_id);
DBMS_OUTPUT.PUT_LINE(emp_sequence.NEXTVAL);
END;
/

-------------------------Nested Blocks---------------------------------------------------
DECLARE
    v_outer_variable VARCHAR2(20) := 'global variable';
    BEGIN
        DECLARE
        v_inner_varibale VARCHAR2(20) := 'inner variable';
        --v_outer_variable VARCHAR2(20) := 'global 1 variable';
        BEGIN
            DBMS_OUTPUT.PUT_LINE(v_inner_varibale);
            DBMS_OUTPUT.PUT_LINE(v_outer_variable || ' nested');
        end;
        DBMS_OUTPUT.PUT_LINE(v_outer_variable);
    end;
/


--using <<outer>>

begin <<outer>>
DECLARE
    v_sal number(7,2) := 60000;
    v_comm number(7,2) := v_sal*0.20;
    v_message VARCHAR2(255) := 'eligible for commission';
BEGIN
    DECLARE
    v_sal number(7,2) := 50000;
    v_comm number(7,2) := 0;
    v_total_comp number(7,2) := v_sal + v_comm;
    BEGIN
        v_message := 'nested'||v_message;
        outer.v_comm := v_sal*0.30;
    end;
    v_message := 'salesman'||v_message;
    end;
    end outer;
    /


    DECLARE
    v_weight number(3) := 600;
    v_message varchar2(255) := 'Product 10012';
    Begin
        Declare
        v_weight number(3) := 1;
        v_message varchar2(255) := 'Product 10011';
        v_new_locn VARCHAR2(50) := 'Europe';
    BEGIN
        v_weight := v_weight + 1;
        v_new_locn := 'Western ' || v_new_locn;
        DBMS_OUTPUT.PUT_LINE(v_weight);
         DBMS_OUTPUT.PUT_LINE(v_new_locn);
    End;
    v_weight := v_weight + 1;
    v_message := v_message || 'is in stock';
   -- v_new_locn := 'Western ' || v_new_locn;
   DBMS_OUTPUT.PUT_LINE(v_weight || ' v_weight outer');
    DBMS_OUTPUT.PUT_LINE(v_message || ' v_message outer');
end;
/


---SQL Statements in PL/SQL -----------
--DDL statements --> not included in PL/SQL Blocks
--DML statements --> included in PL/SQL Blocks

--SELECT into clause is required --> Queries must return only one row

BEGIN
    insert into EMPLOYEES
    (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,email,HIRE_DATE,JOB_ID,SALARY)
    VALUES
    (EMPLOYEES_SEQ.nextval,'Ruth','Cores','RCORES',CURRENT_DATE,'AD_ASST',4000);
end;
/