select * from icx_parameters; --frontend URL
select * from fnd_product_groups; --12.2.11
select * from V$version;


------------------------------------------------------------------------------------o2c cycle------------------------------------------------------------------------------------
--item creation
--onhand qty
--add item to the pricelist

--mtl_system_items_tl --> tl --> translate language -->for china,etc
select * from mtl_system_items_b where segement1 = '';--getting item details from backend 
--who columns for tracking --cretation_date,last_update_date,last_updated_by,created_by

select * from  org_organization_definitions where organization_id = 525; --> to get organization details


--item creation
--inherit attributes from existing template --> tools --> copy from template--> finished goods
--organization assignment --> to the warehouse 
-- add item to the pricelist --> Pricing manager global --> price list --> pricelist setup --> add the item  (to disable --> go to profile options --> QP system source code )

--backordered --> if we do not have sufficient quantity --> backordered

-- Order Entry  header --> Entered Lines --> Entered 
-- Booked       header --> booked  Lines --> Awaiting,Shipping 
-- Pick Release header --> booked  Lines --> Picked
-- Pick Slip Report
-- Shipping Exception table
-- Auto Pack Report

--Shipping 
        --Interface Trip stop 
        --Deduct onhand qty
        --upadate sales order line shipped qty
--Invoice
--Reciepts

--WorkFlow Back Ground Process
    --invoice creation ar_invoice_api_pub
    --Auto invoice master program (order --> invoice interface) --> keeps the details into interface tables --> ra_inteface_lines_all,ra_interface_distributions_all,ra_interface_errors_all
    --Auto invoice import program (invoice interface --> invoice base)--> ra_customer_trx_all,ra_customer_trx_lines_all
    
    select customer_trx_id,a.* from ra_customer_trx_all a where interface_header_attribute1 ='4814171';
    select interface_line_attribute9,a.* from ra_customer_trx_lines_all a where sales_order = '4814171' and CUSTOMER_TRX_ID = 5350504;

--after creation of the invoice --> order status --> close


--Transfer to gl

--oe_order_pub --> API


--------------------------------------------------------Delivery-----------------------------------------------------------------------------------------------------
--wsh-->warehouse 

select booked_flag,open_flag,flow_status_code,a.* from oe_order_headers_all a where order_number = 4814214;--4814214--9064055
select * from oe_order_lines_all where header_id = 2749544;

select distinct(flow_status_code) from oe_order_headers_all;

select open_flag,booked_flag,a.* from oe_order_headers_all a where flow_status_code = 'CLOSED';

select * from wsh_delivery_details where source_header_id =  3971043;
select * from wsh_delivery_details where released_status = 'B' and inventory_item_id = 4604471; --B --> Backorder --> to solve this increase the on-hand quantities

select distinct(released_status) from wsh_delivery_details;

--B	Backordered	Line failed due to insufficient quantity available
--C	Shipped	Line has been shipped
--D	Cancelled	Line is Cancelled
--N	Not Ready For Release	Line is not ready to be pick released
--R	Ready to Release	Line is ready to be pick released
--S	Released to Warehouse	Line has been released to Inventory to be manually transacted
--X	Not Applicable	Line is not eligible for Pick Release.
--Y	Staged	Line has been picked and staged by Inventory

select SUM(transaction_quantity) from mtl_onhand_quantities where inventory_item_id = 4604471;

--booking an order --> dont have the stock --> quantity on hand failed to provide resrevation 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Enter Order in OM (Customer, Order type, Pricelist, shipping details, etc)
--Enter the Items details and sourcing details in Order Line
--Check for the availability and Book the Order
--Schedule and Reserve the Order
--Pick Release the Order (Reports here: Pick Selection List Generation, Pick Slip Report, Shipping Exception Report)
--Ship confirm the order in Shipping transaction form (Reports here: Bill Of Ladding, Packing Slip Report, Commercial Invoice, Vehicle Load Sheet Details, Interface Trip Stop)
--Line Status become Interfaced in Shipping Transaction form
--Sales Order Line status will be Shipped
--Run Workflow Background Concurrent request to close the workflow which in turn will close the order line.
--This will trigger Autoinvoice Master program (inturn it will run Autoinvoice Import Program)
--Then will trigger Prepayment Matching Program
--Invoice (Transaction#) can be found in Account Receivables
--After getting the Cash from customer, Create the Receipt.
--After creation of the receipt, match the receipt with the invoice transaction
--Once the receipt is matched, then the data can be transferred to General Ledger by running General ledger Transfer Program.
--Then Journal can be Imported in GL by Import Journals
--Then Journals can be posted to GL by Post Journals.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Drop shipment flow

--(1)creating a drop ship item -->(List price,Buyer) --> item attributes --> Purchasing --> profile options --> OM:Population of buyer code from drop ship lines (who ever creating the sales order can go any buy the goods)
                           --> we can give default buyer
                           select * from oe_drop_ship_sources;

--(2)Order Entry --> create a sales order --> Shippping tab --> Source Type --> External
            
            
            --> (3)Booking  --> SKIP(Pick Release (We dont have quantity avaliable) --> Ask supplier to deliver direct goods to customer (we dont want to loose the customer))
                          --> (4)Requisition(Purchasing Document) --> workflow backgroud process --> OM --> po requisition interface tables (po_requisition_interface_all , po_req_dist_interface_all) using Requisition Import Program 
                                                                      select interface_source_code,a.* from  po_requisitions_interface_all a where interface_source_code = 'ORDER ENTRY'  order by last_update_date desc;
                                                                       select distinct(interface_source_code) from  po_requisitions_interface_all a  ;
                                                                       --(po_requisitions_headers_all) (po_requisition_lines_all) (po_req_distributions_all)
                                                                       
                                                                  --> (5)Approved(po_action_history) --> (6)Purchase Order --> creating po using the requisition number 
                                                                                                         -- (po_headers_all),po_lines_all,po_lines_locations_all,po_distributions_all
                                                                                                         -- Approved -- po_action_history_all
                                                                                                         
                                                                                                        -- inprocess --> needs manager approval
                                                                                                            
                                                                                                            
                                                                                                            --> (7)receipt(Awating for receipt) 
                                                                                                                select * from mtl_system_items_b where inventory_item_id = 4984250;
                                                                                                                --rcv_shipment_headers,rcv_shipment_lines,rcv_transactions
                                                                                                                
                                                                                                                --Three programs will be initiated
                                                                                                                --Recieving Transaction Processor
                                                                                                                --ADS (Pay On Reciept AutoInvoice)
                                                                                                                --Payables Open Interface Import --> create ap_invoice automatically
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            --> (8)AP invoice (we have to pay to supplier) --> AR invoice(our org to customer)
                                                                                                            --ap_invoices_all,ap_invoices_lines_all,ap_invoice_distributions_all
                          
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--internal sales order
--transfering goods from one warehouse to another


--Setups 
-- 1.item creation 
   --organizational assignment  
   -- item setups --> Order Management --> Internal Ordered (flag)
-- 2.item cost
-- 3.item onhand qty 
     --to assign -- onhand qty --> Inventory --> Transactions --> Miscellaneous Transactions --> type --> Miscellaneous reciepts 
-- 4.internal customer 
-- 5.Shipping network
    --Inventory --> Organization --> Shipping Networks (WarehouseA --> WarehouseB) --> shipping route direct
-- 6.interLocation Transit time 
    --Inventory --> Setup --> InterLocation Transist Time --> Courier service 
-- 7.order type and source
    --Internal Requisition Order type --> Standard
    --Purchasing --> 
                    --(1) internal Requisition
                    --(2) Approve
                    --(3) Create Internal Order  (Program) --> put the data into OM interface tables  (oe_headers_iface_all)
                    select * from po_requisitions_headers_all where segment1 = 'requisition_number';
                    select * from oe_headers_iface_all where orig_sys_document_ref = 'requisition_header_id';
                    --(4) order Import --> Move the data from the order interface tables to base tables
                    -- order booked and awating shipping 
                    --(5)Shipping (Release  sales order for shipping)--> Based on Rule --> standard
                                  --> ship confirm rule --> Auto ship
                                  --> Auto pack delivery --> Yes
                        --Interface Trip stop 
                        --Deduct onhand qty
                        --upadate sales order line shipped qty

-----------------------------------------------------------------------------------------------------------------------------------------------------
--Back to Back order 

-- Supplier --> our organization --> customer 

-- 1.item creation 
   --organizational assignment  
   -- item setups --> Order Management --> Assemble to Order (flag)

   --General planning --> buy
   --under Work in Progress --> Build in WIP (flag)

   --Periods 
   --Inventory --> Accounting_Close_Cycle--> Inventory Accounting Period

   --Purchasing -- setups -- financials - accounting - control purchasing periods 
   --Purchasing Super User  --> setup --> Financials-->Accounting--> open and close periods
-- Payables Manager   --> Accounting --> control Payables Periods -->
-- LEV US Receivables Superuser  --> Control ->Accounting ->Open/Close  Periods.
-- General Ledger Super User --> Setup --> open/close


--2 .Order Entry -->  
    -- a) order book          header - entered        lines - entered
    -- b) order booking       header - booked         lines - supply eligible
    -- c)Progress Order       header - booked         Lines - External Req requested

--3 Requisition Import Program -- CTO --> will get requisition Number (tools --> Scheduling --> reservation Details --> Supply tab --> Header Number)
                --header - booked         Lines - External Req Open


--4) Purachase order  --> to create the PO we have to use auto create 
                    --> PO is create in PO open status 



------------------------------------------------------------P2P cycle-----------------------------------------------------------------------------------------------------------------
--Procure to pay cycle 

--Roles -- Requestor 
        -- Preparer
        -- Buyer

-----------------requsition----------------------------------------
-- Requestor --> will raise the requsition (Purchasing Document)
            --> Purchasing --> Requisitions 
                                --a)Purchase Requisitions --> ✅  Distributions --> Charge Accounts 
                                --b)Internal Requisitions 

                                --Distribution Account -- charge account 

                           -- Charge Accounts --> to get the charge account details --> GL --> setup --> Accounts 
                           select * from gl_code_combinations;  
                           select CODE_COMBINATION_ID,a.* from po_req_distributions_all a;
                           --Charge account 
                                                    SELECT
                                por_view_reqs_pkg.get_account_number(requisition_line_id) acct,
                                segment1,
                                segment2,
                                segment3,
                                segment4,
                                segment5,
                                segment6,
                                gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 1, segment1),
                                gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 1, segment1)
                                || '.'
                                || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 2, segment2)
                                || '.'
                                || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 3, segment3)
                                || '.'
                                || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 4, segment4)
                                || '.'
                                || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 5, segment5)
                                || '.'
                                || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id, 6, segment6)
                            FROM
                                gl_code_combinations      gcc,
                                po_req_distributions_all  prda
                            WHERE
                                    gcc.code_combination_id = prda.code_combination_id
                                AND distribution_id = 4329748;


                           select * from gl_code_combinations_KFV; --> get concatted segements

                           --Organizations --> Purchasing Options --> to make req number standard or automatic

                           --per_all_people_f (person_id)  to get the employee details  _f (for date tracking)


                           select * from po_requisition_headers_all;
                           select * from po_requisition_lines_all;


                           select prha.segment1 requisition_number,papf.full_name preparer,papf1.full_name requestor, por_view_reqs_pkg.get_account_number(prda.requisition_line_id) acct
                            from po_requisition_headers_all prha,per_all_people_f papf,po_requisition_lines_all prla,per_all_people_f papf1,po_req_distributions_all prda
                            where papf.person_id = prha.preparer_id
                            and prha.REQUISITION_HEADER_ID = prla.REQUISITION_HEADER_ID
                            and prha.REQUISITION_HEADER_ID = 1253284
                            and papf1.person_id = prla.to_person_id
                            and prda.REQUISITION_LINE_ID =prla.REQUISITION_LINE_ID ;


---------Approval-------------------------------------------
--to check who has approved (Performed By) -->(Action History) po_action_history_all


select prha.segment1 requisition_number,pah.action_code,papf.full_name performed_by
from po_requisition_headers_all prha , po_action_history pah,per_all_people_f papf
where prha.requisition_header_id = pah.object_id
and prha.segment1 = '886073'
and pah.employee_id = papf.person_id;


--1253284
select segment1,a.* from po_requisition_headers_all a where REQUISITION_HEADER_ID =  1253284;


select distinct(ACTION_CODE) from po_action_history;


--QUESTION
--ANSWER
--FREEZE
--SUBMIT
--FINALLY CLOSE
--RELEASE HOLD
--APPROVE AND FORWARD
--CLOSE
--CANCEL
--OPEN
--RETURN
--DELEGATE
--WITHDRAW
--ACCEPT
--FORWARD
--NO ACTION
--REJECT
--HOLD
--IMPORT
--UNFREEZE
--APPROVE
--SUBMIT CHANGE

--Link between requisition and PO

-- req --> po_req_distributions_all (distribution_id)
--     --> po_distributions_all (req_distribution_id)



-- po --> po_distributions_all (req_distribution_id)

--     --> po number  is stored in po_requisition_headers_all (requisition_header_id)
--                                po_requisition_lines_all (requisition_line_id)

--     --> po_headers_all.segment1 --> po_number  (po_header_id) --> po_lines_all (po_header_id)

SELECT
    prha.segment1    requistion_number,
    pha.segment1     po_number
FROM
    po_distributions_all        pda,
    po_req_distributions_all    prda,
    po_requisition_lines_all    prla,
    po_requisition_headers_all  prha,
    po_headers_all              pha
WHERE
        prda.distribution_id = pda.req_distribution_id
    AND prla.requisition_line_id = prda.requisition_line_id
    AND prla.requisition_header_id = prha.requisition_header_id
    AND pha.po_header_id = pda.po_header_id
    AND pha.segment1 = '886073';

-- Shipments --> Status 
--Match Approval
    --2-way Matching
    -- po_qty --> 25 
    -- invoice_qty --> 25

    --3-way Matching
    --po_qty --> 25
    --invoice_qty --> 10
    --recieved_qty  --> 10

    --4-way Matching
    --po_qty --> 25
    --invoice_qty --> 10
    --recieved_qty --> 10
    --inspection --> 10

    --we can get data in po_lines_location

    SELECT
    prha.segment1    requistion_number,
    pha.segment1     po_number,
    pha.type_lookup_code TYPE_LOOKUP_CODE,
    pll.inspection_required_flag  four_way,
    pll.receipt_required_flag   three_way
FROM
    po_distributions_all        pda,
    po_line_locations_all       pll,
    po_req_distributions_all    prda,
    po_requisition_lines_all    prla,
    po_requisition_headers_all  prha,
    po_headers_all              pha
WHERE
        prda.distribution_id = pda.req_distribution_id
    AND prla.requisition_line_id = prda.requisition_line_id
    AND prla.requisition_header_id = prha.requisition_header_id
    AND pha.po_header_id = pda.po_header_id
    and pha.po_header_id = 9815163
    and pll.line_location_id = pda.line_location_id;





--Ways to create a PO
    --1.Manual
    --2.Auto Create
       ---If you want to get delivery every week --> Planned PO --> fixed date



--Reciepts----------------------------------------------
-- rcv_shipment_headers
-- rcv_shipment_lines
-- rcv_transactions


--Link between po and po receipts

--various transactions types 
    --Return to vendor,corrected,rejected,approved


--Recieving Transaction Processor
--ADS (Pay On Reciept AutoInvoice)

   select receipt_num,pha.segment1 po_number
    from rcv_shipment_headers rsh,
    rcv_shipment_lines rsl,
    po_headers_all pha 
    where rsl.shipment_header_id = rsh.shipment_header_id
    and pha.po_header_id = rsl.po_header_id
    and pha.po_header_id = 9815163;


    select aia.invoice_num,pha.segment1 po_number
    from po_distributions_all pda,ap_invoice_distributions_all aida,po_headers_all pha,ap_invoices_all aia
    where pda.po_distribution_id = aida.po_distribution_id
    and pha.po_header_id = pda.po_header_id
    and aia.invoice_id = aida.invoice_id;


            


                            

                           





    


