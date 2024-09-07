--returns an value 






----------Guidelines for functions-----------------------------------

--function called from select statement cannot contain DML statements
--function called from update or delete statement on table T cannot query or conatin DML on same table T
--function called from sql statements cannot end transactions --> COMMIT or ROLLBACK

create or replace function get_sal
    (p_id employees.employee_id%TYPE) return number IS

    v_sal employees.salary%TYPE := 0;

    begin
        SELECT salary
        into v_sal
        from employees
        where employee_id = p_id;

    return v_sal;

    end get_sal;
/

execute DBMS_OUTPUT.PUT_LINE(get_sal(100));

/


select job_id , get_sal(employee_id)
from EMPLOYEES
where DEPARTMENT_ID = 60;

/


CREATE or replace function tax(
    p_id IN employees.employee_id%type
) RETURN number IS
    v_sal employees.SALARY%TYPE;

    begin
        select salary into v_sal
        from EMPLOYEES
        where EMPLOYEE_ID = p_id;
    
    return(v_sal * 0.08);
end tax;

/

select employee_id,last_name,salary,tax(employee_id)
from EMPLOYEES
where DEPARTMENT_ID = 100;

/

-------------------------------Privileges for calling a function-------------------------
--be the owner of the function
--execute privilege
--parallel_enable --> option specification


-----------------Controlling side effect-------------------------------------------
CREATE or replace function dml_call_sql(p_sal NUMBER)
    return number is 

    BEGIN
        insert into employees(EMPLOYEE_ID,LAST_NAME,email,hire_date,job_id,salary)
                    values(1,'Frost','jfrost@commpany.com',sysdate,'SA_MAN',p_sal);
        return (p_sal + 100);
    end;
/

update EMPLOYEES
set salary = dml_call_sql(2000) -->HR.EMPLOYEES is mutating, trigger/function may not see it
where employee_id = 170;

/

-----------------------------------------------------------------------------------------------
--viewing functions using data dictionary views 

select text from user_source where type = 'FUNCTION' order by line;
/



create or replace function get_job 
    (
        p_jobid IN jobs.job_id%type
    )

    return jobs.job_title%type IS

    v_title jobs.job_title%type;

    BEGIN
        select job_title
        into v_title
        from jobs
        where job_id = p_jobid;

        return v_title;

    end;

    /

select job_id , get_job(job_id) from jobs;

/
select * from employees;

/


create or replace function get_annual_comp(
    p_sal IN employees.salary%type,
    p_comm IN employees.commission_pct%type
)
    return number is
    BEGIN
        return (NVL(p_sal,0)*12 + (NVL(p_comm,0)*nvl(p_sal,0)*12));
    
    end get_annual_comp;
/


select EMPLOYEE_ID , last_name , get_annual_comp(salary,commission_pct) "Annual Compensation" from employees;

/

CREATE or replace function valid_dept (
    p_deptid IN departments.department_id%type
)

    return boolean IS

    v_dummy PLS_INTEGER;

    begin
    select 1 into v_dummy
    from DEPARTMENTS
    where DEPARTMENT_ID = p_deptid;

    return true;
    exception
    when no_data_found
    then
        return false;
    end valid_dept;

    /