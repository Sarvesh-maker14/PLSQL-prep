--column of data


--composite data types --> PL/SQL records --> row of data in an table
                       --> Collections --> Associative Arrays
                                       --> Nested Tables
                                       --> VARRAYSs



--record----
/
declare 
type emptype is record 
(v_fname varchar2(25),
v_lname varchar2(25));
emprecord emptype;
begin 
    select first_name, last_name 
    into emprecord
    from EMPLOYEES
    where EMPLOYEE_ID = 100;
DBMS_OUTPUT.PUT_LINE(emprecord.v_fname||' '||emprecord.v_lname);
END;
/

declare 
emprecord EMPLOYEES%rowtype; --taking tables as a row
begin 
    select *
    into emprecord
    from EMPLOYEES
    where EMPLOYEE_ID = 100;
DBMS_OUTPUT.PUT_LINE(emprecord.first_name||' '||emprecord.last_name);
END;
/

select hire_date from EMPLOYEES;
/

declare 
    type t_rec is record
    (
        v_sal number(8),
        v_minsal number(8) := 1000,
        v_hire_date EMPLOYEES.hire_date%type,
        v_recl EMPLOYEES%rowtype
    );

    v_myrec t_rec;

    Begin
        v_myrec.v_sal := v_myrec.v_minsal + 500;
        v_myrec.v_hire_date := sysdate;

        select * 
        into v_myrec.v_recl
        from EMPLOYEES
        where EMPLOYEE_ID = 100;

        DBMS_OUTPUT.PUT_LINE(v_myrec.v_recl.last_name||' '||v_myrec.v_hire_date||' '||v_myrec.v_sal);
    end;

    /

    declare 

    emprecord EMPLOYEES%rowtype;

    begin
        select *
        into emprecord
        from EMPLOYEES
        where EMPLOYEE_ID = 100;

    emprecord.salary := emprecord.salary + 10000;
    emprecord.last_name := upper(emprecord.last_name);

    update
    EMPLOYEES
    set row = emprecord
    where EMPLOYEE_ID = emprecord.EMPLOYEE_ID;

    end;

    /


     select *
        from EMPLOYEES
        where EMPLOYEE_ID = 100;

/


declare
    v_countryid varchar2(20) := 'CA';
    v_country_record countries%ROWTYPE;

    begin
        select * 
        into v_country_record
        from countries
        where country_id = UPPER(v_countryid);

    DBMS_OUTPUT.PUT_LINE(v_country_record.country_name);
end;
/

-----------------------------------Collections----------------------------------------------------

--Associative Arrays --> Index by table 
--key value pairs 
declare
    type emptype is table of employees.last_name%type
    index by pls_integer;

    emptable emptype;


    begin
        for i in 100..110 
        loop 
            select last_name into emptable(i)
            from employees
            where EMPLOYEE_ID=i;

        end loop;
        
        -- DBMS_OUTPUT.PUT_LINE(emptable(100));

        for j in emptable.first..emptable.last 
        loop    
            DBMS_OUTPUT.PUT_LINE(emptable(j));
        end loop;


    end;

    /


declare
    type emptype is table of employees%rowtype
    index by pls_integer;

    emptable emptype;


    begin
        for i in 100..110 
        loop 
            select * into emptable(i)
            from employees
            where EMPLOYEE_ID=i;

        end loop;
        
        -- DBMS_OUTPUT.PUT_LINE(emptable(100));

        for j in emptable.first..emptable.last 
        loop    

            DBMS_OUTPUT.PUT_LINE('Prior Index'|| emptable.Prior(j));
            DBMS_OUTPUT.PUT_LINE(emptable(j).last_name);
            DBMS_OUTPUT.PUT_LINE('Prior Index'|| emptable.next(j));
        end loop;
        

    end;
/
    
 
declare 
    type email_table is table of 
    employees.email%type
    index by pls_integer;
    email_list email_table;
begin
    email_list(100) := 'SKING';
    email_list(105) := 'DAUSTIN';
    email_list(110) := 'JCHEN';
    DBMS_OUTPUT.PUT_LINE(email_list(100));
    DBMS_OUTPUT.PUT_LINE(email_list(105));
    DBMS_OUTPUT.PUT_LINE(email_list(110));
END;

/


declare
    type dept_table_type
    is
        table of departments%ROWTYPE index by varchar2(20);
        dept_table dept_table_type;


    begin
        select * 
        into dept_table(1)
        from departments
        where department_id = 10;

    
     DBMS_OUTPUT.PUT_LINE(dept_table(1).department_id);
     DBMS_OUTPUT.PUT_LINE(dept_table(1).department_name);
     DBMS_OUTPUT.PUT_LINE(dept_table(1).manager_id);

     end;
/




declare

    type dept_table_type is table of
    departments.department_name%type
    index by pls_integer;

    my_dept_table dept_table_type;

    f_loop_count number(2) :=  10;
    v_deptno number(4) := 0;


    begin
        for i in 1..f_loop_count
        loop
            v_deptno := v_deptno + 10;

            select department_name
            into my_dept_table(i)
            from departments
            where department_id = v_deptno;
        end loop;

        for i in 1..f_loop_count
        loop
            DBMS_OUTPUT.PUT_LINE(my_dept_table(i));
        end loop;
    end;
/

declare
    type dept_table_type 
    is table of departments%ROWTYPE
    index by pls_integer;

    my_dept_table dept_table_type;
    f_loop_count number(2) := 10;
    v_deptno number(4) := 0;

    begin
        for i in 1..f_loop_count
        loop
            v_deptno := v_deptno + 10;

            select *
            into my_dept_table(i)
            from departments
            where department_id = v_deptno;

        End loop;

        for i in 1..f_loop_count
        loop    
             DBMS_OUTPUT.PUT_LINE(my_dept_table(i).department_name);
        end loop;
    end;

/





----------Nested tables-------------------------------------------------------
-- sequentially indexed data

declare
    type dept_mail is table of varchar2(20);
    mails dept_mail := dept_mail('SKING','NKOCHAR','LDEHAAN','AHUNOLD');

begin
    for i in mails.first..mails.last 
    loop
    DBMS_OUTPUT.PUT_LINE(mails(i));

    end loop;
    end;
/

------------------VARRAYS------------------------------------------------------------

-- sequentially indexed data with upper limit
declare
    type dept_mail is VARRAY(5) of varchar2(20);
    mails dept_mail := dept_mail('SKING','NKOCHAR','LDEHAAN','AHUNOLD');

begin
    for i in mails.first..mails.last 
    loop
    DBMS_OUTPUT.PUT_LINE(mails(i));

    end loop;
    end;