

--if

DECLARE
    v_myage number := 24;
BEGIN
    if v_myage < 11
    THEN
        DBMS_OUTPUT.PUT_LINE('I am a child');
    ELSIF v_myage < 20 
    then
        DBMS_OUTPUT.PUT_LINE('I am young');
    else
        DBMS_OUTPUT.PUT_LINE('I am not a child');
    end if;
end;
/


-------case--------------------------

declare 
    v_grade CHAR(1) := 'A';
    v_appraisal varchar2(20);
BEGIN
    v_appraisal := CASE
        WHEN v_grade = 'A' then 'Excellent'
        when v_grade IN ('B','C') then 'Good'
        else 'No such grade'
        end;
    DBMS_OUTPUT.PUT_LINE(v_appraisal);
    end;
/

select * from EMPLOYEES;
--normal case
select last_name,job_id,salary,
case job_id
when 'AD_ASST' then salary*2
when 'AD_VP' then salary*1.5
end
from EMPLOYEES;

--searched case 
select last_name,job_id,salary,
case 
when job_id = 'AD_ASST' then salary*2
when job_id = 'AD_VP' then salary*1.5
end
from EMPLOYEES;

/


--Handling Nulls---------------------------



declare 
    v_true BOOLEAN := TRUE;
    v_false BOOLEAN := FALSE;
    v_null BOOLEAN := NULL;
    v_output_flag BOOLEAN := NULL;
BEGIN
    
    --OR 
    v_output_flag := v_true OR v_true;
    DBMS_OUTPUT.PUT_LINE(v_output_flag);
    v_output_flag := v_true OR v_false;
    DBMS_OUTPUT.PUT_LINE(v_output_flag);
    v_output_flag := v_false OR v_false;
    DBMS_OUTPUT.PUT_LINE(v_output_flag);
    v_output_flag := v_true OR v_null;
    DBMS_OUTPUT.PUT_LINE(v_output_flag);
    v_output_flag := v_false OR v_null;
    DBMS_OUTPUT.PUT_LINE(v_output_flag);



   
    end;



    /

    select * from locations;

    /
    -------------------------Loops---------------------------------------

    DECLARE
    v_countryid locations.COUNTRY_ID%TYPE := 'CA';
    v_loc_id locations.LOCATION_ID%TYPE;
    v_counter NUMBER(2) := 1;
    v_new_city locations.CITY%TYPE := 'Montreal';
    BEGIN
        select max(LOCATION_ID) 
        into v_loc_id 
        from LOCATIONS
        where COUNTRY_ID = v_countryid;

    LOOP 
        INSERT into LOCATIONS
        (LOCATION_ID,city,COUNTRY_ID)
        values((v_loc_id + v_counter),v_new_city,v_countryid);
        v_counter := v_counter + 1;
        EXIT when v_counter > 3;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_counter-1);
    end;
    /


    ---While loop---------------
    DECLARE
    v_countryid locations.COUNTRY_ID%TYPE := 'CA';
    v_loc_id locations.LOCATION_ID%TYPE;
    v_counter NUMBER(2) := 1;
    v_new_city locations.CITY%TYPE := 'Montreal';
    BEGIN
        select max(LOCATION_ID) 
        into v_loc_id 
        from LOCATIONS
        where COUNTRY_ID = v_countryid;

    WHILE v_counter <= 3
    LOOP
        INSERT into LOCATIONS
        (LOCATION_ID,city,COUNTRY_ID)
        values((v_loc_id + v_counter),v_new_city,v_countryid);
        v_counter := v_counter + 1;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_counter-1);
    end;

    /

    ---For Loop---------------------------------------

    DECLARE
    v_countryid locations.COUNTRY_ID%TYPE := 'CA';
    v_loc_id locations.LOCATION_ID%TYPE;
    v_counter NUMBER(2) := 1;
    v_new_city locations.CITY%TYPE := 'Montreal';
    BEGIN
        select max(LOCATION_ID) 
        into v_loc_id 
        from LOCATIONS
        where COUNTRY_ID = v_countryid;

    FOR i IN 1..3 
    LOOP
        INSERT into LOCATIONS
        (LOCATION_ID,city,COUNTRY_ID)
        values((v_loc_id + i),v_new_city,v_countryid);
        v_counter := i;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_counter);
    end;

    /


    declare 
    v_total NUMBER := 0;
    BEGIN
        <<BeforeTopLoop>>
        for i  in 1..5 LOOP
        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE('Outer Loop'||v_total);
            for j in 1..5 loop
                CONTINUE BeforeTopLoop when i + j > 5;
                v_total := v_total + 1;
                DBMS_OUTPUT.PUT_LINE('Inner Loop'||v_total);
            END LOOP;
        END LOOP BeforeTopLoop;
    END;

    /




















