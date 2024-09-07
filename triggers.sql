--DML statements triggers --> delete , insert, update
--DDL statements --> create , alter , drop
--database events --> servererror , logon ,logoff , startup , shutdown


--simple dml triggers
        --before
        --after
        --instead of

--compound trigger

--system triggers
    --ddl event trigger
    --database event trigger



--commit and rollback are  not allowed in an trigger


create table salary_log (who_did_it varchar2(25),
                        when_did_it TIMESTAMP,
                        old_alary number,
                        new_salary number,
                        emp_affected number);

/

--:old --> old value 
--:new --> new value 

create or replace trigger saltrig 
after insert or update of salary on employees
for each row 
    begin 
        insert into salary_log
        values (user,sysdate,:old.salary,:new.salary,:new.employee_id);
        end;

/

update employees set salary=24000 where employee_id=100;

/

select * from salary_log;
commit;

/

-----------------------trigger execution time--------------------------------------------------------------

--before --> execute the trigger body before the DML event on the table 

create or replace trigger secure_emp
before insert on employees
    begin

        if(to_char(sysdate,'DY') IN ('SAT','SUN'))
           or
           (to_char(sysdate,'HH24:MI') NOT BETWEEN '08:00' AND '18:00')
        then
            raise_application_error(-20500,' You may insert '||' into employess table only during '||' normal business hours ');
            end if;
            end;
/

insert into employees(employee_id,last_name,first_name,email,hire_date,job_id,salary,department_id)
values (300,'Smith','Rob','RSMITH',sysdate,'IT_PROG',4500,60);

/
 




--after -->execute the trigger body after the DML event on the table

--Instead of --> used for views 





    -------------------Multiple Triggers of the same type---------------------------
     --precedes
     --follows

     --to execute trigger2 after trigger1 ---

     create or replace trigger2 on employees before update
     follows trigger1...

     /


    --------------------------Call statements in triggers--------------------------------------

    create or replace procedure log_execution is 
    begin
        dbms_output.put_line('log_execution: Employee Inserted');
    end;
    /

    create or replace trigger log_employee
    before insert on employees
    call log_execution --

    /


