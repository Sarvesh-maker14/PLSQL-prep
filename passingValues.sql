--"actual parameter" and "formal parameter"

--------------------pass by value--------------------------------------------------------

--In pass by value the formal parameter and the actual parameter will point to different
--memory location and will copy their values

--if exception raise in any of the procedure the copying will not take place

--formal parameter

    CREATE or REPLACE 
    procedure proc_p1(
        param_value IN OUT VARCHAR2  --formal parameter
    ) AS

    lv_temp NUMBER;
    begin
        param_value := 'B';
        lv_temp := 1/0;

    end;
    /

    DECLARE
        lv_var VARCHAR2(1);
    BEGIN
        lv_var := 'A';
        BEGIN
        proc_p1(lv_var); --Actual parameter  (the actual parameter will hold the values from the formal parameter)
        --lv_var will point to the same memory location as param_value
        exception when others then 
            NULL;
        end;
        DBMS_OUTPUT.PUT_LINE(lv_var);

    end;
    /

---------------------pass by reference NOCOPY-------------------------------------------------------

--In pass by reference the formal parameter and the actual parameter will point to same
--memory location and will override the memory location value

--copying will take place even if error occurs 

  CREATE or REPLACE 
    procedure proc_p2(
        param_value IN OUT NOCOPY VARCHAR2  --formal parameter
    ) AS
    begin
        param_value := 'B';
    end;

    /

     DECLARE
        lv_var VARCHAR2(1);
    BEGIN
        lv_var := 'A';
         BEGIN
        proc_p2(lv_var); --Actual parameter  (the actual parameter will hold the values from the formal parameter)
         exception when others then 
            NULL;
        end;
        DBMS_OUTPUT.PUT_LINE(lv_var);

    end;

    /

    CREATE or REPLACE PACKAGE demo_package AS
        type nest_tab_type is table of varchar2(4000);

        lv_nest_tab_var nest_tab_type := nest_tab_type();

        procedure p_copy (
            param_value IN OUT nest_tab_type
        );

        procedure p_nocopy (
            param_value IN OUT NOCOPY nest_tab_type
        );

    END;
/


----------------------------------Parallel enabled--------------------------------



CREATE OR REPLACE FUNCTION calculate_square (p_number NUMBER)
   RETURN NUMBER
   DETERMINISTIC --function returns the same result for the same input
   PARALLEL_ENABLE --enables the function to be used in parallel query operations 
IS
BEGIN
   RETURN p_number * p_number;
END calculate_square;
/

CREATE OR REPLACE FUNCTION calculate_square_no_parallel (p_number NUMBER)
   RETURN NUMBER
   DETERMINISTIC
IS
BEGIN
   RETURN p_number * p_number;
END calculate_square_no_parallel;
/


CREATE TABLE numbers (
   num NUMBER
)
/

INSERT INTO numbers (num)
SELECT LEVEL
FROM DUAL
CONNECT BY LEVEL <= 1000000;  -- Inserting 1,000,000 rows

/

SELECT * from numbers;

/


SET TIMING ON

SELECT /*+ PARALLEL(n, 4) */
       n.num,
       calculate_square_no_parallel(n.num) AS squared_value
FROM   numbers n;
/

SELECT /*+ PARALLEL(n, 4) */
       n.num,
       calculate_square(n.num) AS squared_value
FROM   numbers n;

/
CREATE TABLE PRODUCTS (
    PDT_NAME VARCHAR2(10)
)

/


select * from products;

/
INSERT INTO PRODUCTS (PDT_NAME) VALUES ('Wheat');
INSERT INTO PRODUCTS (PDT_NAME) VALUES ('Rice');
INSERT INTO PRODUCTS (PDT_NAME) VALUES ('Sugar');
INSERT INTO PRODUCTS (PDT_NAME) VALUES ('Salt');
INSERT INTO PRODUCTS (PDT_NAME) VALUES ('Corn');
/

DECLARE 
    Type pdt_rec is record (
        pdt_id NUMBER,
        ptd_name varchar2(10)

    );

    PROCEDURE display_rec (
        p_rec IN pdt_rec DEFAULT pdt_rec(1,NULL)) AS 

        Begin 
            DBMS_OUTPUT.PUT_LINE(p_rec.pdt_id);
        END;

        begin 
            display_rec;
        end;
    
    /


    declare 
        TYPE pdt_nt_tab IS TABLE of VARCHAR2(10);
        pdt_names pdt_nt_tab; -- uninitialized collection
           -- pdt_names pdt_nt_tab := pdt_nt_tab();  
    begin 
        pdt_names.EXTEND;
        pdt_names(1) := 'wheat';
        DBMS_OUTPUT.PUT_LINE(pdt_names(1));
    END;
    /


    DECLARE 
     CURSOR c_product IS
        select pdt_name from products;

        type c_list is table of products.PDT_NAME%TYPE
        index by BINARY_INTEGER;

        product_list c_list;
        BEGIN
        product_list(1) := 'wheat';
        DBMS_OUTPUT.PUT_LINE(product_list(1));

        END;
    /

    DECLARE 
        type pdt_tab is table of number 
        index by PLS_INTEGER;

        -- l_pdt pdt_tab := pdt_tab(1,2,3); -associatve array 
        l_pdt pdt_tab;

        BEGIN

    -- l_pdt(1) := 1;
    -- l_pdt(2) := 2;
    -- l_pdt(3) := 3;
            DBMS_OUTPUT.PUT_LINE(l_pdt.COUNT);
        END;
    /

    declare 
        type pdt_var is VARRAY(3) of VARCHAR2(6);
        pdt_list pdt_var := pdt_var();
    begin 
        pdt_list.extend;
        pdt_list(1) := 'A';
        DBMS_OUTPUT.PUT_LINE(pdt_list(1));
    END;
    /

    DECLARE
        type databuf_arr IS TABLE of clob Index by BINARY_INTEGER;
        pdatabuf databuf_arr;

        begin 

           -- pdatabuf(1) := NULL;
            dbms_lob.CREATETEMPORARY(pdatabuf(1),TRUE,dbms_lob.session);
        end;
    /


    DECLARE TYPE databuf_arr IS TABLE OF CLOB INDEX BY BINARY_INTEGER; 
    pdatabuf databuf_arr; 
    
    PROCEDURE mytemplob (x OUT CLOB) IS 
    
    BEGIN 
        DBMS_LOB.CREATETEMPORARY (x, TRUE, DBMS_LOB.SESSION); 
    END; 
    
    BEGIN 
        mytemplob(pdatabuf (1)); 
    END; 
    
    /

SELECT   a.creation_date, 
         a.item_number,
         a.description,
         effb1.attribute_char1 "ITEM_TYPE", 
         ps.vendor_name,
         effb1.attribute_char3 "SUPPLIER_SITE" ,
         pss.inactive_date,
         pss.VENDOR_SITE_ID "Supplier site",
         pss.PARTY_SITE_NAME "Site Name",

FROM     egp_system_items_vl a,
         ego_item_eff_b effb1,
         poz_suppliers_v ps,
         poz_supplier_sites_v pss
WHERE    1=1
AND      a.inventory_item_id = effb1.inventory_item_id(+)
AND      a.organization_id = effb1.organization_id(+)
AND      effb1.context_code(+) = 'Org Attributes'
AND      a.organization_code='12619'
AND      pss.vendor_site_code=effb1.attribute_char3
AND      pss.vendor_id=ps.vendor_id
ORDER BY a.item_number;


-- Columns that are not highlighted in yellow:
-- Business Unit
-- Supplier Number
-- Supplier Name
-- Supplier Site
-- Site Name
-- Site Status
-- Inactive Date
-- Item Organization
-- Item Number
-- Item Description
-- UOM
-- Item Type
-- Mfg Name
-- Mfg Part No
-- Existing Columns in Your Query:
-- Supplier Number
-- Supplier Name
-- Supplier Site
-- Inactive Date
-- Item Organization
-- Item Number
-- Item Description
-- Item Type

SELECT 
    a.creation_date,
    htl.name "Business Unit",
    ps.vendor_number "Supplier Number",
    ps.vendor_name "Supplier Name",
    pss.vendor_site_code "Supplier Site",
    pss.party_site_name "Site Name",
    DECODE(pss.inactive_date, NULL, 'Active', 'Inactive') "Site Status",
    pss.inactive_date "Inactive Date",
    a.organization_code "Item Organization",
    a.item_number "Item Number",
    a.description "Item Description",
    a.primary_uom_code "UOM",
    effb1.attribute_char1 "Item Type", 
    effb1.attribute_char4 "Mfg Name",
    effb1.attribute_char5 "Mfg Part No"
FROM 
    egp_system_items_vl a,
    ego_item_eff_b effb1,
    poz_suppliers_v ps,
    poz_supplier_sites_v pss,
    HR_ORGANIZATION_UNITS_F_TL htl
WHERE 
    a.inventory_item_id = effb1.inventory_item_id(+)
    AND a.organization_id = effb1.organization_id(+)
    AND effb1.context_code(+) = 'Org Attributes'
    AND pss.vendor_id = ps.vendor_id
    AND pss.vendor_site_code = effb1.attribute_char3
    AND a.organization_id = htl.organization_id(+)
    AND a.organization_code = '12619'
    AND htl.language = 'US' 
    AND htl.name = NVL(:p_business_unit, htl.name)
    AND ps.vendor_name = NVL(:p_supplier_name, ps.vendor_name)
    AND ps.vendor_number = NVL(:p_supplier_number, ps.vendor_number)
    AND pss.vendor_site_code = NVL(:p_supplier_site, pss.vendor_site_code)
    AND DECODE(pss.inactive_date, NULL, 'Active', 'Inactive') = NVL(:p_site_status, DECODE(pss.inactive_date, NULL, 'Active', 'Inactive'))
ORDER BY 
    a.item_number;

    /

    SET SERVEROUTPUT ON;
    /

    begin 
        for i in 10..1 loop
        DBMS_OUTPUT.PUT_LINE(i);
        end loop;
    end;

    /

    declare 
        i number;
    begin 
        i := 10;
        for i in 1..10 loop
        i := i -1;
        DBMS_OUTPUT.PUT_LINE(i);
        END LOOP;
    END; 

    /

    begin 
        for i in REVERSE 10..1 loop
        DBMS_OUTPUT.PUT_LINE(i);
        end loop;
    end;

    /
    
    begin 
        for i in REVERSE 1..10 loop
        DBMS_OUTPUT.PUT_LINE(i);
        end loop;
    end;

    /

    select department_id , count(*)
    from employees
    where department_id <> 90 
    having count(*) >= 3
   group by department_id;

    /

    select department_id , count(*)
    from employees
    having department_id <> 90
    and count(*) >= 3
    group by department_id;

   /


   select department_id , count(*)
    from employees
    where department_id <> 90 
   group by department_id
   having count(*) >= 3;

   /
    CREATE TABLE PRODUCTS1 (
    PRODUCT_ID   NUMBER(10)    PRIMARY KEY,       -- Unique identifier for each product
    PDT_NAME     VARCHAR2(100) NOT NULL,          -- Name of the product
    CATEGORY     VARCHAR2(50),                    -- Product category
    PRICE        NUMBER(10, 2),                   -- Price of the product with 2 decimal places
    QUANTITY     NUMBER(10),                      -- Available quantity of the product
    SUPPLIER_ID  NUMBER(10),                      -- Foreign key reference to the supplier
    CREATED_AT   DATE         DEFAULT SYSDATE,    -- Date when the product was added
    UPDATED_AT   DATE         DEFAULT SYSDATE     -- Date when the product was last updated
);

/
-- Insert sample data into the PRODUCTS table

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (1, 'Laptop', 'Electronics', 75000.00, 50, 101);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (2, 'Smartphone', 'Electronics', 25000.00, 200, 102);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (3, 'Desk Chair', 'Furniture', 5000.00, 150, 103);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (4, 'Book', 'Stationery', 350.00, 500, 104);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (5, 'Pen', 'Stationery', 10.00, 1000, 105);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (6, 'Dining Table', 'Furniture', 12000.00, 30, 103);

INSERT INTO PRODUCTS1 (PRODUCT_ID, PDT_NAME, CATEGORY, PRICE, QUANTITY, SUPPLIER_ID)
VALUES (7, 'Headphones', 'Electronics', 1500.00, 300, 102);

-- Commit the transaction to save the changes
COMMIT;






   /

    select * from products1;
/
   cursor c1 is 
            select * from products1 
            for update of price;

   /

   Update products1 
    set price = price *  1.05
    where current of c1;

  /

  DECLARE
    -- Declare the cursor to select all rows from products1 for update
    CURSOR c1 IS 
        SELECT * 
        FROM products1 
        FOR UPDATE OF price;

BEGIN
    -- Open the cursor and iterate through each row
    FOR r IN c1 LOOP
        -- Update the price of the current row pointed by the cursor
        UPDATE products1 
        SET price = price * 1.05
        WHERE CURRENT OF c1;
    END LOOP;

    -- Commit the transaction to save changes
    COMMIT;
END;

  /

  DECLARE
    CURSOR c1 IS 
        SELECT * 
        FROM products1 
        FOR UPDATE OF price;
BEGIN
    OPEN c1;
    -- You could update rows without using WHERE CURRENT OF
    UPDATE products1`
    SET price = price * 1.05 
    WHERE product_id = 1;
    COMMIT;
END;

/





    