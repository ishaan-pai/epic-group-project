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