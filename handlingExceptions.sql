

-- predefined --> names are predefined
    -- NO_DATA_FOUND
    -- too_many_rows
    -- invalid_cursor
    -- zero_divide
    -- dup_val_on_index

-- non predefined --> names are not predefined --> error code and message are defined

-- user defined --> oracle does not recognize as an error

select * FROM demo;

/

BEGIN
    INSERT into DEMO
    VALUES(2,'King');
    INSERT into DEMO
    values(3,'De Haan');
    INSERT into DEMO
    VALUES(1,'Kocchar');

    EXCEPTION
        when dup_val_on_index THEN --> oracle predefined exception handler 20
        DBMS_OUTPUT.PUT_LINE('Hey you have a duplicate ID');
end;

/

Declare 
    v_lname varchar2(15);
    BEGIN
        select last_name into v_lname
        from EMPLOYEES
        where FIRST_NAME = 'John';

        DBMS_OUTPUT.PUT_LINE(v_lname);

    EXCEPTION
        when too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('select statement retrieved multiple rows use a cursor');
    end;
/



-----------------------Trapping Internally Predefined Exceptions ----------------------------------------


--declare            -->         Associate              --> Reference
--Name of the exception   Use pragma_exception_init         Exception section

declare 
    e_oops exception;
    PRAGMA exception_init(e_oops,-01400);

BEGIN
    insert into DEPARTMENTS
    values(900,null,null,null);

    EXCEPTION 
        when e_oops THEN
        DBMS_OUTPUT.PUT_LINE('No Nulls for deptname');

        --sql code
         DBMS_OUTPUT.PUT_LINE(sqlcode);
         DBMS_OUTPUT.PUT_LINE(sqlerrm);


    end;

    /


---User defined exception----------------------------------------------------------

--we can use -20000 to -20999

BEGIN
    delete from EMPLOYEES where EMPLOYEE_ID = 99;

    if sql%notfound then RAISE_APPLICATION_ERROR(-20999, 'Nobody with that id!');
    end if;

end;

/
DECLARE

    e_no_id exception;

BEGIN
    delete from EMPLOYEES where EMPLOYEE_ID = 99;

    if sql%notfound then raise e_no_id;
    end if;

    exception 
    when e_no_id THEN
    DBMS_OUTPUT.PUT_LINE('Nobody with that id');

end;

/


