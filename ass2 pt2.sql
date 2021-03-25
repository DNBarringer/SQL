set pagesize 66
set linesize 80

spool C:\cprg250s\ass2pt2.txt

CLEAR COMPUTE
CLEAR COLUMNS
CLEAR BREAKS
TTITLE off
TTITLE CENTER 'Transaction Report' RIGHT 'Page:' skip 1
COLUMN "fl" FORMAT A20 HEADING 'Name'
COLUMN "Cust #" FORMAT A15 HEADING 'Cust#'
COLUMN transaction_date FORMAT A10 HEADING 'Date'
COLUMN transaction_number HEADING 'Trans #'

COMPUTE SUM label 'Acct Ttl' of "Total" on "Cust #";
COMPUTE SUM label 'Cust Ttl' of "Total" on "fl";
COMPUTE SUM label 'Grand Total' of "Total" on report;

break on "fl" on "Cust #" skip 2 on report


select surname || ', ' || first_name "fl", customer_number || '-' || account_type "Cust #", transaction_date, transaction_number,
to_char(sum(CASE
WHEN transaction_type = 'D' THEN -transaction_amount
ELSE transaction_amount END),'$9,999.00') "Total"
from wgb_customer natural join wgb_account natural join wgb_transaction
group by surname, first_name, customer_number, account_type, transaction_date, transaction_number
order by transaction_number;

spool off;