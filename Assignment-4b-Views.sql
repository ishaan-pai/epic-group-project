create view potential_customer as
   select c.customerid,
          c.displayname,
          c.email,
          c.joinedat
     from customer c
    where joinedat >= date '2026-08-01'
      and joinedat <= date '2026-12-31'
with read only;
drop view potential_customer;

select *
  from potential_customer;