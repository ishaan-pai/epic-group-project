create table customer (
   customerid  number(10) not null,
   displayname varchar2(100) not null,
   email       varchar2(254) not null,
   joinedat    date not null,
   constraint customer_pk primary key ( customerid ),
   constraint customer_email_uq unique ( email )
);

select *
  from customer;

create table cardset (
   setid       number(10) not null,
   setname     varchar2(120) not null,
   releasedate date not null,
   constraint cardset_pk primary key ( setid )
);

select setid,
       'Release Date is: ',
       releasedate
  from cardset;

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

select *
  from cardprinting
 where setid = 1
   and collectornumber = '001'
   and cardlanguage = 'English'
   and variant = 'Normal';

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

select *
  from cardcopy
 where printingid = 1
   and cardcondition = 'NearMint'
 order by copyid asc;

create table gradedcardcopy (
   copyid              number(10) not null,
   gradingcompany      varchar2(60) not null,
   grade               varchar2(20) not null,
   certificationnumber varchar2(80) not null,
   constraint gradedcardcopy_pk primary key ( copyid ),
   constraint gradedcardcopy_copy_fk foreign key ( copyid )
      references cardcopy ( copyid )
);

select distinct copyid as grade
  from gradedcardcopy
 where copyid = 1
 order by grade asc;

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

select *
  from listing
 where ( copyid = 1
   and listingstatus = 'Active' )
    or listingstatus = 'Reserved'
 order by askingprice asc;

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

select *
  from salesorder
 where customerid <> 1
   and orderstatus in ( 'Paid',
                        'Shipped',
                        'Delivered' )
 order by placedat desc;

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

select *
  from orderline
 where orderid = 1
 order by lineno asc;

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

select *
  from payment
 where orderid = 1
 order by paidat asc;

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

select *
  from shipment
 where orderid = 1
 order by shippedat asc;