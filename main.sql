-- *****************************************************************************
-- * Assignment-3.sql                                                          *
-- *****************************************************************************
create table customer (
   customerid  number(10) not null,
   displayname varchar2(100) not null,
   email       varchar2(254) not null,
   joinedat    date not null,
   constraint customer_pk primary key ( customerid ),
   constraint customer_email_uq unique ( email )
);

create table cardset (
   setid       number(10) not null,
   setname     varchar2(120) not null,
   releasedate date not null,
   constraint cardset_pk primary key ( setid )
);

create table cardprinting (
   printingid      number(10) not null,
   setid           number(10) not null,
   cardname        varchar2(120) not null,
   collectornumber varchar2(20) not null,
   cardlanguage    varchar2(30) not null,
   variant         varchar2(60) not null,
   rarity          varchar2(40) not null,
   constraint cardprinting_pk primary key ( printingid ),
   constraint cardprinting_set_fk foreign key ( setid )
      references cardset ( setid ),
   constraint cardprinting_version_uq unique ( setid,
                                               collectornumber,
                                               cardlanguage,
                                               variant )
);

create table cardcopy (
   copyid        number(10) not null,
   printingid    number(10) not null,
   cardcondition varchar2(20) not null,
   description   varchar2(1000) not null,
   constraint cardcopy_pk primary key ( copyid ),
   constraint cardcopy_printing_fk foreign key ( printingid )
      references cardprinting ( printingid ),
   constraint cardcopy_condition_ck
      check ( cardcondition in ( 'NearMint',
                                 'LightlyPlayed',
                                 'ModeratelyPlayed',
                                 'HeavilyPlayed',
                                 'Damaged' ) )
);

create table gradedcardcopy (
   copyid              number(10) not null,
   gradingcompany      varchar2(60) not null,
   grade               varchar2(20) not null,
   certificationnumber varchar2(80) not null,
   constraint gradedcardcopy_pk primary key ( copyid ),
   constraint gradedcardcopy_copy_fk foreign key ( copyid )
      references cardcopy ( copyid )
);

create table listing (
   listingid     number(10) not null,
   copyid        number(10) not null,
   askingprice   number(10,2) not null,
   listedat      date not null,
   listingstatus varchar2(12) default 'Active' not null,
   constraint listing_pk primary key ( listingid ),
   constraint listing_copy_fk foreign key ( copyid )
      references cardcopy ( copyid ),
   constraint listing_price_ck check ( askingprice > 0 ),
   constraint listing_status_ck
      check ( listingstatus in ( 'Active',
                                 'Reserved',
                                 'Sold',
                                 'Withdrawn' ) )
);

create table salesorder (
   orderid       number(10) not null,
   customerid    number(10) not null,
   placedat      date not null,
   orderstatus   varchar2(20) default 'AwaitingPayment' not null,
   shippingfee   number(10,2) not null,
   recipientname varchar2(120) not null,
   street        varchar2(200) not null,
   city          varchar2(100) not null,
   province      varchar2(100),
   postalcode    varchar2(20) not null,
   country       varchar2(100) not null,
   constraint salesorder_pk primary key ( orderid ),
   constraint salesorder_customer_fk foreign key ( customerid )
      references customer ( customerid ),
   constraint salesorder_shipping_ck check ( shippingfee >= 0 ),
   constraint salesorder_status_ck
      check ( orderstatus in ( 'AwaitingPayment',
                               'Paid',
                               'Shipped',
                               'Delivered',
                               'Cancelled' ) )
);

-- Weak entity
-- Each line represents one physical copy, so quantity is not needed
-- ListingID is not globally unique because cancelled order lines are retained
create table orderline (
   orderid     number(10) not null,
   lineno      number(10) not null,
   listingid   number(10) not null,
   agreedprice number(10,2) not null,
   constraint orderline_pk primary key ( orderid,
                                         lineno ),
   constraint orderline_order_fk foreign key ( orderid )
      references salesorder ( orderid ),
   constraint orderline_listing_fk foreign key ( listingid )
      references listing ( listingid ),
   constraint orderline_listing_uq unique ( orderid,
                                            listingid ),
   constraint orderline_number_ck check ( lineno > 0 ),
   constraint orderline_price_ck check ( agreedprice > 0 )
);

create table payment (
   paymentid        number(10) not null,
   orderid          number(10) not null,
   paidat           date not null,
   amount           number(10,2) not null,
   method           varchar2(30) not null,
   paymentreference varchar2(100) not null,
   constraint payment_pk primary key ( paymentid ),
   constraint payment_order_fk foreign key ( orderid )
      references salesorder ( orderid ),
   constraint payment_order_uq unique ( orderid ),
   constraint payment_amount_ck check ( amount > 0 )
);

create table shipment (
   shipmentid     number(10) not null,
   orderid        number(10) not null,
   carrier        varchar2(60) not null,
   trackingnumber varchar2(100) not null,
   shippedat      date not null,
   deliveredat    date,
   constraint shipment_pk primary key ( shipmentid ),
   constraint shipment_order_fk foreign key ( orderid )
      references salesorder ( orderid ),
   constraint shipment_order_uq unique ( orderid ),
   constraint shipment_dates_ck
      check ( deliveredat is null
          or deliveredat >= shippedat )
);

-- *****************************************************************************
-- * Assignment-4-Sample-Data.sql                                              *
-- *****************************************************************************
-- Customers: CustomerID 1 is excluded by the customer filter in query 7
insert into customer (
   customerid,
   displayname,
   email,
   joinedat
) values
   ( 1,
     'Avery Sample',
     'avery@example.com',
     date '2026-08-01' );
insert into customer (
   customerid,
   displayname,
   email,
   joinedat
) values
   ( 2,
     'Blair Sample',
     'blair@example.com',
     date '2026-08-03' );
insert into customer (
   customerid,
   displayname,
   email,
   joinedat
) values
   ( 3,
     'Casey Sample',
     'casey@example.com',
     date '2026-08-05' );
insert into customer (
   customerid,
   displayname,
   email,
   joinedat
) values
   ( 4,
     'Drew Sample',
     'drew@example.com',
     date '2026-08-07' );

-- Release dates deliberately differ from SetID and insertion order
insert into cardset (
   setid,
   setname,
   releasedate
) values
   ( 3,
     'Demo Mountain Collection',
     date '2025-01-10' );
insert into cardset (
   setid,
   setname,
   releasedate
) values
   ( 1,
     'Demo Forest Collection',
     date '2024-04-12' );
insert into cardset (
   setid,
   setname,
   releasedate
) values
   ( 2,
     'Demo Ocean Collection',
     date '2023-09-02' );

-- Only PrintingID 1 matches every printing filter in query 3
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 1,
     1,
     'Demo Leaf Guardian',
     '001',
     'English',
     'Normal',
     'Common' );
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 2,
     1,
     'Demo Leaf Guardian',
     '001',
     'English',
     'Foil',
     'Rare' );
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 3,
     1,
     'Demo Leaf Guardian',
     '001',
     'French',
     'Normal',
     'Common' );
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 4,
     1,
     'Demo Woodland Scout',
     '002',
     'English',
     'Normal',
     'Uncommon' );
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 5,
     2,
     'Demo Tide Keeper',
     '001',
     'English',
     'Normal',
     'Common' );
insert into cardprinting (
   printingid,
   setid,
   cardname,
   collectornumber,
   cardlanguage,
   variant,
   rarity
) values
   ( 6,
     3,
     'Demo Peak Watcher',
     '003',
     'English',
     'Normal',
     'Rare' );


-- Copies without a GradedCardCopy row are ungraded
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 1,
     1,
     'NearMint',
     'Fictional ungraded copy currently available for sale.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 2,
     1,
     'NearMint',
     'Fictional graded copy sold in delivered order 1.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 3,
     1,
     'LightlyPlayed',
     'Fictional ungraded copy reserved for awaiting-payment order 5.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 4,
     2,
     'NearMint',
     'Fictional graded foil copy sold in delivered order 1.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 5,
     3,
     'NearMint',
     'Fictional ungraded French copy sold in shipped order 2.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 6,
     4,
     'NearMint',
     'Fictional graded copy sold in paid order 3.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 7,
     5,
     'LightlyPlayed',
     'Fictional ungraded copy sold in delivered order 4.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 8,
     6,
     'NearMint',
     'Fictional ungraded copy reserved for awaiting-payment order 5.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 9,
     1,
     'NearMint',
     'Fictional ungraded copy withdrawn after cancelled order 6.' );
insert into cardcopy (
   copyid,
   printingid,
   cardcondition,
   description
) values
   ( 10,
     2,
     'Damaged',
     'Fictional ungraded damaged copy with no listing.' );

-- Duplicate company names to demonstrate that DISTINCT in query 5 works
insert into gradedcardcopy (
   copyid,
   gradingcompany,
   grade,
   certificationnumber
) values
   ( 2,
     'Demo GradeWorks',
     '9',
     'DEMO-GW-0002' );
insert into gradedcardcopy (
   copyid,
   gradingcompany,
   grade,
   certificationnumber
) values
   ( 4,
     'Demo GradeWorks',
     '10',
     'DEMO-GW-0004' );
insert into gradedcardcopy (
   copyid,
   gradingcompany,
   grade,
   certificationnumber
) values
   ( 6,
     'Demo CardCheck',
     '9.5',
     'DEMO-CC-0006' );

-- Copy 1 has one current Active listing and one withdrawn historical listing.
-- Reserved listings 4 and 9 belong to OTHER copies and must not match query 6.
-- Each sold copy appears in only one completed or paid order and is not relisted.
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 1,
     1,
     20.00,
     date '2026-09-20',
     'Active' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 2,
     1,
     22.00,
     date '2026-09-01',
     'Withdrawn' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 3,
     2,
     43.00,
     date '2026-09-02',
     'Sold' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 4,
     3,
     11.00,
     date '2026-09-20',
     'Reserved' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 5,
     4,
     28.00,
     date '2026-09-02',
     'Sold' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 6,
     5,
     18.00,
     date '2026-09-04',
     'Sold' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 7,
     6,
     24.00,
     date '2026-09-06',
     'Sold' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 8,
     7,
     8.00,
     date '2026-09-07',
     'Sold' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 9,
     8,
     35.00,
     date '2026-09-20',
     'Reserved' );
insert into listing (
   listingid,
   copyid,
   askingprice,
   listedat,
   listingstatus
) values
   ( 10,
     9,
     14.00,
     date '2026-09-09',
     'Withdrawn' );

-- Orders 1, 2, and 3 match query 7; descending placement order is 3, 2, 1
-- Order 4 is excluded by customer, while orders 5 and 6 are excluded by status
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 1,
     2,
     date '2026-09-10',
     'Delivered',
     5.00,
     'Blair Sample',
     '102 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 2,
     3,
     date '2026-09-16',
     'Shipped',
     4.00,
     'Casey Sample',
     '103 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 3,
     4,
     date '2026-09-19',
     'Paid',
     6.00,
     'Drew Sample',
     '104 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 4,
     1,
     date '2026-09-11',
     'Delivered',
     2.00,
     'Avery Sample',
     '101 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 5,
     2,
     date '2026-09-21',
     'AwaitingPayment',
     5.00,
     'Blair Sample',
     '102 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );
insert into salesorder (
   orderid,
   customerid,
   placedat,
   orderstatus,
   shippingfee,
   recipientname,
   street,
   city,
   province,
   postalcode,
   country
) values
   ( 6,
     3,
     date '2026-09-12',
     'Cancelled',
     3.00,
     'Casey Sample',
     '103 Example Avenue',
     'Sampleton',
     'Ontario',
     'A1A 1A1',
     'Canada' );

-- Order 1's lines are inserted in reverse order to demonstrate order by LineNo
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 1,
     2,
     5,
     28.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 1,
     1,
     3,
     43.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 2,
     1,
     6,
     18.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 3,
     1,
     7,
     24.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 4,
     1,
     8,
     8.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 5,
     1,
     4,
     11.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 5,
     2,
     9,
     35.00 );
insert into orderline (
   orderid,
   lineno,
   listingid,
   agreedprice
) values
   ( 6,
     1,
     10,
     14.00 );

-- Payment totals equal the order's agreed prices plus its shipping fee
insert into payment (
   paymentid,
   orderid,
   paidat,
   amount,
   method,
   paymentreference
) values
   ( 1,
     1,
     date '2026-09-11',
     76.00,
     'CreditCard',
     'DEMO-PAY-0001' );
insert into payment (
   paymentid,
   orderid,
   paidat,
   amount,
   method,
   paymentreference
) values
   ( 2,
     2,
     date '2026-09-17',
     22.00,
     'DebitCard',
     'DEMO-PAY-0002' );
insert into payment (
   paymentid,
   orderid,
   paidat,
   amount,
   method,
   paymentreference
) values
   ( 3,
     3,
     date '2026-09-20',
     30.00,
     'CreditCard',
     'DEMO-PAY-0003' );
insert into payment (
   paymentid,
   orderid,
   paidat,
   amount,
   method,
   paymentreference
) values
   ( 4,
     4,
     date '2026-09-12',
     10.00,
     'DebitCard',
     'DEMO-PAY-0004' );

-- Every shipment follows payment, delivered dates follow shipment dates
insert into shipment (
   shipmentid,
   orderid,
   carrier,
   trackingnumber,
   shippedat,
   deliveredat
) values
   ( 1,
     1,
     'Demo Parcel Service',
     'DEMO-TRACK-0001',
     date '2026-09-12',
     date '2026-09-15' );
insert into shipment (
   shipmentid,
   orderid,
   carrier,
   trackingnumber,
   shippedat,
   deliveredat
) values
   ( 2,
     2,
     'Demo Parcel Service',
     'DEMO-TRACK-0002',
     date '2026-09-18',
     null );
insert into shipment (
   shipmentid,
   orderid,
   carrier,
   trackingnumber,
   shippedat,
   deliveredat
) values
   ( 3,
     4,
     'Demo Parcel Service',
     'DEMO-TRACK-0004',
     date '2026-09-13',
     date '2026-09-16' );

commit;

-- *****************************************************************************
-- * Assignment-4a-Queries.sql                                                 *
-- *****************************************************************************
-- List registered customers alphabetically by display name
select customerid as customer_id,
       displayname as customer_name,
       email as email,
       joinedat as joined_date
  from customer
 order by displayname asc,
          customerid asc;

-- List card sets from the earliest release date to the latest
select setid as set_id,
       setname as set_name,
       releasedate as release_date
  from cardset
 order by releasedate asc,
          setid asc;

-- Find the English Normal printing numbered 001 in card set 1
select printingid as printing_id,
       setid as set_id,
       cardname as card_name,
       collectornumber as collector_number,
       cardlanguage as language,
       variant as variant,
       rarity as rarity
  from cardprinting
 where setid = 1
   and collectornumber = '001'
   and cardlanguage = 'English'
   and variant = 'Normal';

-- List NearMint physical copies of printing 1, ordered by copy ID
select copyid as copy_id,
       printingid as printing_id,
       cardcondition as condition,
       description as description
  from cardcopy
 where printingid = 1
   and cardcondition = 'NearMint'
 order by copyid asc;

-- List each grading company represented in the inventory once
select distinct gradingcompany as grading_company
  from gradedcardcopy
 order by gradingcompany asc;

-- List active or reserved listings for physical copy 1, cheapest first
select listingid as listing_id,
       copyid as copy_id,
       askingprice as asking_price_cad,
       listedat as listed_date,
       listingstatus as listing_status
  from listing
 where copyid = 1
   and listingstatus in ( 'Active',
                          'Reserved' )
 order by askingprice asc,
          listingid asc;

-- List paid, shipped, or delivered orders from customers other than
-- customer 1, with the most recently placed orders first
select orderid as order_id,
       customerid as customer_id,
       placedat as placed_date,
       orderstatus as order_status,
       recipientname as recipient_name,
       shippingfee as shipping_fee_cad
  from salesorder
 where customerid <> 1
   and orderstatus in ( 'Paid',
                        'Shipped',
                        'Delivered' )
 order by placedat desc,
          orderid asc;

-- List the items in order 1 in invoice line number order
select orderid as order_id,
       lineno as line_number,
       listingid as listing_id,
       agreedprice as agreed_price_cad
  from orderline
 where orderid = 1
 order by lineno asc;

-- Show the successful payment recorded for order 1
select paymentid as payment_id,
       orderid as order_id,
       paidat as paid_date,
       amount as amount_cad,
       method as payment_method,
       paymentreference as payment_reference
  from payment
 where orderid = 1;

-- Show the shipment and delivery details recorded for order 1
select shipmentid as shipment_id,
       orderid as order_id,
       carrier as carrier,
       trackingnumber as tracking_number,
       shippedat as shipped_date,
       deliveredat as delivered_date
  from shipment
 where orderid = 1;

-- *****************************************************************************
-- * Assignment-4b-Views.sql                                                   *
-- *****************************************************************************
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