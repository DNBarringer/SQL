set echo on
set linesize 132
set pagesize 66
spool C:\cprg250\practicemidterm.txt

//Q1
select customer_no
from cp_rental
where actual_date_returned > date_due;

//Q2
select film_title, actors,
case
    when star_rating = '**' then '2'
    when star_rating = '***' then '3'
    when star_rating = '****' then '4'
    when star_rating = '*****' then '5'
    else '1' end AS "rating"
from cp_title
where runtime < 150 and "rating" > 3;

select Name
from cp_customer
where customer_no NOT IN (select customer_no from cp_rental);

select name, "Count"
from cp_customer c, (select customer_no, count(dvd_number) "Count"
                    from cp_rental
                    group by customer_no) test
where c.customer_no = test.customer_no
and test."Count" > (select AVG("Count")
                    from (select customer_no, count(dvd_number) "Count"
                    from cp_rental
                    group by customer_no));



select customer_no, count(dvd_number) "Count"
from cp_rental
group by customer_no;

select AVG("Count")
from (select customer_no, count(dvd_number) "Count"
from cp_rental
group by customer_no);



select distinct category_description "Category", film_title "Film", "Count"
from cp_category ct, cp_title t, (select title_code, count(title_code) "Count"
                                    from cp_dvd
                                    group by title_code) test
where ct.category_code = t.category_code
and test.title_code = t.title_code
group by cube(category_description,film_title),"Count"
order by 1;


select film_title, category_description
from cp_title t, cp_category c
where t.category_code = c.category_code;

select film_title, category_code
from cp_title;

select title_code "Title", count(title_code) "Count"
from cp_dvd
group by title_code;

//part a
select category_description, Sum("Count")
from cp_category c, cp_title t, (select title_code "Title", count(title_code) "Count"
                    from cp_dvd
                    group by title_code) test
where c.category_code = t.category_code
and t.title_code = test."Title"
group by category_description
order by 1;

//part b
select film_title, count(t.title_code)
from cp_title t, cp_dvd d
where t.title_code = d.title_code
group by film_title
order by 1;

//part c
select count(title_code)
from cp_dvd;