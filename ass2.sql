spool C:\cprg250s\ass2.txt

set echo on
set pagesize 66
set linesize 132
CLEAR COLUMNS
CLEAR BREAKS
 

--Q1
select first_name "First", surname "Last", "a".customer_number "Cust #", "# of Accts", 
CASE "# of Accts"
    WHEN 1 THEN 'Entry Level'
    WHEN 2 THEN 'Growing'
    WHEN 3 THEN 'Growing'
    ELSE 'Mature' END "Level"
from wgb_customer "c", (select customer_number, count(account_type) "# of Accts"
    from wgb_account
    group by customer_number) "a"
WHERE ("c".customer_number = "a".customer_number)
ORDER BY "Last";




--Q2
select first_name, surname, "# of Txns", ROW_NUMBER() OVER(ORDER BY "# of Txns" DESC) AS "Position"
from wgb_customer
JOIN (select customer_number, count(transaction_number) "# of Txns"
    from wgb_transaction
    group by customer_number)
USING (customer_number)
FETCH NEXT 2 rows ONLY;

 --Q3
select account_description "Acct Type", first_name "First", surname "Last", customer_number "Cust #", to_char("max", '$99,999.00') "Highest Balance"
FROM WGB_ACCOUNT_TYPE
NATURAL JOIN wgb_account "a"
NATURAL JOIN wgb_customer
NATURAL JOIN (select account_type, max(balance) "max"
    from wgb_account "account"
    group by account_type) "test"
where "a".balance = "test"."max"
ORDER BY 1;


--Q4

select first_name "First", surname "Last", account_type "Act Type", to_char(sum(
    CASE 
        WHEN transaction_type = 'D' THEN -transaction_amount
        ELSE transaction_amount END),'$9,999.00') "Total"
from wgb_transaction t JOIN wgb_customer c ON t.customer_number = c.customer_number
group by rollup ((first_name,surname), account_type)
order by 1;

spool off;