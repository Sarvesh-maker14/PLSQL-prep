--Cursor --> pointer to the private memory area that store information about processing a specific 
--select or dml statement

--Implicit --> managed by pl/sql
--Explicit --> Managed by programmer


----Implicit Cursor Attributes----------------------------------------------
--SQL%FOUND --> (Boolean) --> if sql statement affected atleast 1 row 
--SQL%NOTFOUND --> (Boolean) --> if sql statement affected not even 1 row 
--SQL%ROWCOUNT --> (INT) --> number of rows affected by the sql statement 

select * from EMPLOYEES;

/

declare 
    v_rows_deleted varchar2(30);
    v_empno employees.EMPLOYEE_ID%type := 165;
BEGIN
    delete from employees
    where EMPLOYEE_ID = v_empno;
    v_rows_deleted := (SQL%ROWCOUNT|| ' row deleted.');
    DBMS_OUTPUT.PUT_LINE(v_rows_deleted);
END;
/


DECLARE
    v_max_deptno number;
    v_dept_name departments.DEPARTMENT_NAME%TYPE := 'Education';
    v_dept_id number;
BEGIN
    select max(department_id)
    into v_max_deptno
    from departments;
    DBMS_OUTPUT.PUT_LINE(v_max_deptno);

    v_dept_id := v_max_deptno + 10;

    DBMS_OUTPUT.PUT_LINE(v_dept_id);

    Insert into DEPARTMENTS(department_id,DEPARTMENTS.DEPARTMENT_NAME,DEPARTMENTS.LOCATION_ID)
    values (v_dept_id,v_dept_name,NULL);
     DBMS_OUTPUT.PUT_LINE('Rows affected' || SQL%ROWCOUNT);


END;

/

---Explicit cursor---------------------------------
-- declare --> open --> fetch --> close

DECLARE
    CURSOR empcursor (pdept number) IS
    SELECT * 
    from employees
    where department_id = pdept;

emprecord employees%ROWTYPE;

BEGIN
    open empcursor(10);

    

    LOOP

    fetch empcursor
    into emprecord;

    EXIT when empcursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(emprecord.last_name);

    END LOOP;

    if empcursor%isopen
    then close empcursor;
    end if;

end;

/


declare 
    cursor c_emp_cursor
    is 
        select EMPLOYEE_ID,LAST_NAME
        from EMPLOYEES
        where department_id = 30;

        v_empno employees.EMPLOYEE_ID%TYPE;
        v_lname employees.LAST_NAME%TYPE;

    BEGIN

        OPEN c_emp_cursor;

        LOOP

        fetch c_emp_cursor into v_empno,v_lname;
        exit when c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empno ||' '||v_lname);
        end loop;
    end;
/


DECLARE
    CURSOR empcursor (pdept number) IS
    SELECT last_name , salary
    from employees
    where department_id = pdept;

emprecord employees%ROWTYPE;

BEGIN


    for emprecord in empcursor(10)
        LOOP
            DBMS_OUTPUT.PUT_LINE(emprecord.last_name);
        End loop;

end;




---cursor attributes 

--%isopen --> true if cursor is open 
--%notfound --> true if recent fetch does not return a row 
--%found --> true if recent fetch returns a row 
--%rowcount --> returns the number of row that has been fetched


/

declare
    cursor c_emp_cursor is

        select employee_id, last_name
        from employees;

        v_emp_record c_emp_cursor%rowtype;

BEGIN
        open c_emp_cursor;

        loop
            fetch c_emp_cursor
            into v_emp_record;

            exit when c_emp_cursor%rowcount > 10 OR c_emp_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(v_emp_record.employee_id);

            end loop;

            close c_emp_cursor;
        end;

/


--cursor for loop using subqueries-----------------------------------------------------------------

begin 
    for emp_record in (
        select employee_id,last_name
        from employees
        where department_id = 30
    )
    loop
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id);
    end loop;
end;

/


----FOR UPDATE clause----------------------------------------------------------------------

--use explicit locking to deny access to other session for the duration of a transaction
--lock the rows before an update or a delete


declare 
    cursor c_emp_cursor
    is 
        select EMPLOYEE_ID,LAST_NAME
        from EMPLOYEES
        where department_id = 30 
        for update wait 10;-- wait 10 seconds 

        v_empno employees.EMPLOYEE_ID%TYPE;
        v_lname employees.LAST_NAME%TYPE;

    BEGIN

        OPEN c_emp_cursor;

        LOOP

        fetch c_emp_cursor into v_empno,v_lname;
        exit when c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empno ||' '||v_lname);
        end loop;
    end;
/


update EMPLOYEES set salary = 10000 where employees.EMPLOYEE_ID = 100; 
/



--When current of clause ---------------------
--use cursor to update or delete the current rows

DECLARE  
        cursor c_emp_cursor IS
        select employee_id , SALARY
        from EMPLOYEES
        where employees.DEPARTMENT_ID = 30 for update;

        BEGIN   
            for emp_record in c_emp_cursor 
                LOOP
                    DBMS_OUTPUT.PUT_LINE(emp_record.employee_id);

                    update EMPLOYEES
                    set salary = 5000
                    where current of c_emp_cursor;
                end loop;
            end;
/


select * from EMPLOYEES where DEPARTMENT_ID = 30;

/


------------------------------------------------------------------------------------------------

declare 

v_deptno number := 10;

cursor c_emp_cursor IS

        select last_name , salary , manager_id
        from employees
        where department_id = v_deptno;

Begin 

    for emp_record in c_emp_cursor
    LOOP
        if emp_record.salary < 5000 and (emp_record.manager_id = 101 OR emp_record.manager_id = 124)
        THEN
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || 'Due for a raise');
        else 
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || 'Not Due for a raise');
        END IF;
    END LOOP;
END;

/

DECLARE
    cursor c_dept_cursor IS
            select department_id,department_name 
            from DEPARTMENTS
            where department_id < 100
            ORDER by DEPARTMENT_ID;

    cursor c_emp_cursor(v_deptno NUMBER) IS
            select last_name , job_id , hire_date , SALARY
            from EMPLOYEES
            where department_id = v_deptno 
            and employee_id < 120;

    v_current_deptno departments.DEPARTMENT_ID%TYPE;
    v_current_dname departments.DEPARTMENT_NAME%TYPE;
    v_ename employees.LAST_NAME%TYPE;
    v_job employees.JOB_ID%TYPE;
    v_hiredate employees.HIRE_DATE%TYPE;
    v_sal employees.SALARY%TYPE;

begin 
    open c_dept_cursor;
        loop
            fetch c_dept_cursor into v_current_deptno,v_current_dname;

            exit when c_dept_cursor%NOTFOUND;

             DBMS_OUTPUT.PUT_LINE(v_current_deptno);
             DBMS_OUTPUT.PUT_LINE(v_current_dname);


             if c_emp_cursor%isopen then
                close c_emp_cursor;

            end if;

            open c_emp_cursor(v_current_deptno);
                loop
                    fetch c_emp_cursor into v_ename,v_job,v_hiredate,v_sal;
                    Exit when c_emp_cursor%NOTFOUND;
                     DBMS_OUTPUT.PUT_LINE(v_ename||' '||v_job||' '||v_hiredate||' '||v_sal);
                End loop;
            close c_emp_cursor;
        end loop;
        close c_dept_cursor;
    end;

/

-------------------------Top n salaries------------------------------------------------------------

CREATE table top_salaries (SALARY NUMBER(8,2));

/



DECLARE
    v_num number(3) := 5;
    v_sal employees.salary%TYPE;

    cursor c_emp_cursor IS
        select salary 
        from EMPLOYEES
        order by salary desc;

 begin
    open c_emp_cursor;

    fetch c_emp_cursor into v_sal;

    WHILE c_emp_cursor%ROWCOUNT <= v_num AND c_emp_cursor%FOUND
    LOOP 
        insert into top_salaries (salary)
            values (v_sal);

        fetch c_emp_cursor into v_sal;
    END LOOP;

    close c_emp_cursor;
END;

/

select * from top_salaries;




