CREATE package helper AUTHID DEFINER ACCESSIBLE BY (api) IS
    PROCEDURE h1;
    END;
/

CREATE package body helper is 
    procedure h1 IS 
    emp_name employees.first_name%TYPE;

    BEGIN
        select first_name INTO emp_name 
        from hr.employees
        where employee_id =  201;

    DBMS_OUTPUT.PUT_LINE(emp_name);

    end;
end;

/

CREATE package api AUTHID current_user IS 
     PROCEDURE p1;
end;

/

CREATE package body api IS 
      procedure p1 IS 
      begin 
            helper.h1;
        END;
    END;
/


begin 
    DECLARE
    fnam varchar2(10) := 'King';
    lnam varchar2(12) := 'Cobra';
    
    function full_name (
        A varchar2,
        B varchar2
    ) return varchar2 as 
    C varchar2(20);

    begin 
     C := A || ';' || B;
     return C;

     end full_name;
    
    
    
    begin
    

      DBMS_OUTPUT.PUT_LINE('and the output is...');
     DBMS_OUTPUT.PUT_LINE(full_name(fnam,lnam));
     end;
     
     end;

/

create or replace package std_const_err_pkg IS
vtax constant NUMBER(3) := 3;
e_seq EXCEPTION;
pragma exception_init(e_seq,-2777);
e_fk EXCEPTION;
pragma exception_init(e_fk,-2292);
end;
/
declare 
    v_raise number(5);
    v_join_date DATE := SYSDATE - 10;
    v_flag BOOLEAN NOT NULL DEFAULT TRUE;
    v_char varchar2 := NULL;
    v_bonus_pct constant real(2) := 8.25;
    v_zip_code varchar2(80) := SUBSTR('Oracle corporation',24,0);
BEGIN
    update EMPLOYEES
    set salary = salary ;
end;
/

select * from EMPLOYEES; 

ROLLBACK;
/


create or replace package products_pkg AS
    type PriceList is table of NUMBER;
    Procedure print_price (p_price PriceList);
    End products_pkg;
/

create or REPLACE package body products_pkg as    
    PROCEDURE print_price (p_price PriceList) IS 
    begin 
        for i In p_price.FIRST..p_price.Last LOOP
        DBMS_OUTPUT.PUT_LINE(p_price(i));
        end loop;
    end;
    end products_pkg;
/


declare
    type PriceList is table of number;
    list1 products_pkg.PriceList := products_pkg.PriceList(500,800,1000);
    -- list2 PriceList :=  PriceList(400,600,800);
     list2 products_pkg.PriceList := products_pkg.PriceList(500,800,1000);
begin
    products_pkg.print_price(list1);
    products_pkg.print_price(list2);
end;

/

BEGIN
    for i in reverse 10..1 loop
    DBMS_OUTPUT.PUT_LINE(i);
    end loop;
    end;
/

DECLARE
    i number;
BEGIN
    i := 10;
    for i in 1..10 loop
    i:=i-1;
    DBMS_OUTPUT.PUT_LINE(i);
    end loop;
    end;
/

begin
    for i in 10..1 loop
    DBMS_OUTPUT.PUT_LINE(i);
    end loop;
    end;
/
begin
    for i in reverse 1..10 loop
    DBMS_OUTPUT.PUT_LINE(i);
    end loop;
    end;

/

declare
    price CONSTANT NUMBER(4) := 10000;
    BEGIN
        NULL;
            
    exception
        when others then 
        DBMS_OUTPUT.PUT_LINE('Incorrect price value');
    end;
/


begin
    DECLARE
        error_detected EXCEPTION;
        PRAGMA EXCEPTION_INIT(error_detected,-2001);
        price CONSTANT NUMBER(4) := 10000;
    begin
        null;
    end;

    EXCEPTION
        when error_detected then
            DBMS_OUTPUT.PUT_LINE('Incorrect price value');
        end;    
/

declare
    price CONSTANT NUMBER(4) := 10000;
    BEGIN
        NULL;
    exception
        when error_detected then 
        DBMS_OUTPUT.PUT_LINE('Incorrect price value');
    end;
/ 

BEGIN
    declare 
        price constant number(4) := 50000;
    begin
        null;
    END;        
    EXCEPTION
        when value_error then
            DBMS_OUTPUT.PUT_LINE('Incorrect price value');
        End;
    /

CREATE or REPLACE PROCEDURE proc1( v1 out number ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(v1*10);
    end;
/

DECLARE
x number := 5;
BEGIN 
    x :=proc1;
     DBMS_OUTPUT.PUT_LINE(x);
end;

/

DECLARE
    x number := 5;
    result number;
BEGIN 
    proc1(x);
    -- result := x;  
    -- DBMS_OUTPUT.PUT_LINE('Outside procedure: ' || result);
END;
/







