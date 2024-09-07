
--Anonymous Blocks
    -- Un-named plsql Blocks
    -- compiled every time
    -- not stored in the DB
    -- cannot take parameters


create or replace procedure insert_demo_proc(pid number,pname varchar2) AS
    BEGIN
        insert into DEMO
        values(pid,pname);
        exception
        when dup_val_on_index then
        DBMS_OUTPUT.PUT_LINE('you have a duplicate id');
    end insert_demo_proc;

/

show errors

/

begin 
insert_demo_proc(1,'king');
end;

/


-----------------------------------Functions---------------------------------------------------------

create or replace function get_emp (p_id number) return varchar2 AS
        v_lname VARCHAR2(25);

        BEGIN
            select last_name into v_lname from EMPLOYEES
            where EMPLOYEE_ID = p_id;
        return v_lname;
    end get_emp;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE(get_emp(100));
end;

/

select EMPLOYEE_ID,get_emp(EMPLOYEE_ID)
from EMPLOYEES;

/

----------------Parameter Modes------------------------------
--IN --> default mode 
--OUT --> value is returned to a calling environment


CREATE or replace procedure query_emp
    (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE) AS
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    select last_name,salary
    into v_name,v_salary
    from employees
    where employee_id = p_id;

    DBMS_OUTPUT.PUT_LINE(v_salary);

end query_emp;

/

EXECUTE query_emp(176);

/


CREATE or replace procedure query_emp
    (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_name OUT employees.last_name%TYPE,
    p_salary OUT employees.salary%TYPE) IS
BEGIN
    select last_name,salary
    into p_name,p_salary
    from employees
    where employee_id = p_id;

end query_emp;

/

CREATE or replace procedure display AS
    v_emp_name employees.LAST_NAME%TYPE;
    v_emp_sal employees.salary%TYPE;
BEGIN
    query_emp(171,v_emp_name,v_emp_sal);
    DBMS_OUTPUT.PUT_LINE(v_emp_name);
End display;

/

EXECUTE display;

/


CREATE or replace procedure format_phone
    (p_phone_no IN OUT VARCHAR2) IS

BEGIN
    p_phone_no := '(' || SUBSTR(p_phone_no,1,3) || ')' || SUBSTR(p_phone_no,4,3) || '-' || SUBSTR(p_phone_no,7);

end format_phone;

/

VARIABLE b_phone_no VARCHAR2(15)
EXECUTE :b_phone_no := '9755545675'
PRINT b_phone_no
EXECUTE format_phone (:b_phone_no)
PRINT b_phone_no

/

select * from jobs;

/

CREATE or replace procedure add_job (
    p_jobid jobs.job_id%TYPE,
    p_jobtitle jobs.job_title%TYPE
) IS
BEGIN
    insert into jobs (job_id,JOB_TITLE)
    values (p_jobid,p_jobtitle);
    commit;
end add_job;

/

-- EXECUTE ADD_JOB('IT_DBA','Database Administrator');
EXECUTE ADD_JOB('ST_MAN','Stock Manager');
/

select * from jobs where job_id = 'IT_DBA';

/



