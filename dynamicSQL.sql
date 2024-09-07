--' EXECUTE immediate' --> Native dynamic sql (NDS)

--syntax is checked at run time rather than compile time

select * from demo;

/
insert into demo values(2,'Mickey');
commit;
/
CREATE or replace procedure delete_demo(ptable VARCHAR2) IS
BEGIN
    delete from ptable; --> table name checked at compile time
end;
/

CREATE or replace procedure delete_demo(ptable VARCHAR2) IS
BEGIN
    EXECUTE immediate 'delete from '||ptable; --> table name checked at run time
end;

/

select * from demo;

/

EXECUTE delete_demo('demo');

/


CREATE or replace procedure create_table(
    p_table_name varchar2,p_col_specs varchar2
)
    IS
    begin
        EXECUTE IMMEDIATE 'create table '|| p_table_name || '('||p_col_specs||')';
    end;
/

BEGIN
    create_table('demo2','id NUMBER(4) PRIMARY KEY,name VARCHAR2(40)');
end;

/

CREATE procedure add_row(
    p_table_name varchar2, p_id number, p_name varchar2
)
    IS

    BEGIN
        EXECUTE IMMEDIATE 'INSERT INTO '|| p_table_name ||' Values (:1,:2)' USING p_id,p_name;
    end;
/

---single row query----------------------------------------------

CREATE function get_emp_new(p_emp_id NUMBER)
return employees%ROWTYPE IS
    v_stmt varchar2(200);
    v_emprec employees%ROWTYPE;

    BEGIN
        v_stmt := 'select * from employees '||'where employee_id = :p_emp_id';
        execute IMMEDIATE v_stmt into v_emprec using p_emp_id;
    return v_emprec;

end;

/

DECLARE
    v_emprec employees%ROWTYPE := get_emp_new(100);
begin
    DBMS_OUTPUT.PUT_LINE(v_emprec.last_name);
end;
/


---using bulk collect and open for clause --------------------------------


DECLARE
    type EmpCurTyp is ref cursor;
    type NumList is table of number;
    type NameList is Table of varchar2(25);
    emp_cv EmpCurTyp;
    empids NumList;
    enames NameList;
    sals NumList;

    begin
        open emp_cv for 'select employee_id, last_name from employees';
        fetch emp_cv bulk collect into empids,enames;
        CLOSE emp_cv;

        DBMS_OUTPUT.PUT_LINE(empids.count);
        end;
/




---------------------------Execution Flow of SQL statements----------------------------------------

--parse --> bind --> execute --> fetch


---Dynamic sql implementation
    --NDS
    --DBMS_SQL package

CREATE or replace function delete_all_rows 
    (p_table_name varchar2) return number is
    v_cur_id integer;
    v_rows_del number;

begin 
    v_cur_id := DBMS_SQL.OPEN_CURSOR;

    DBMS_SQL.PARSE(v_cur_id,'Delete from '|| p_table_name, DBMS_SQL.NATIVE);
    v_rows_del := DBMS_SQL.execute(v_cur_id);
    DBMS_SQL.close_cursor(v_cur_id);
    return v_rows_del;
    end;
/

create table temp_emp as select * from EMPLOYEES;

begin 
    dbms_output.PUT_LINE(delete_all_rows('temp_emp'));
end;
/

