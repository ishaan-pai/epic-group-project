
-- Customers: CustomerID 1 is excluded by the customer filter in query 7
INSERT INTO Customer (CustomerID, DisplayName, Email, JoinedAt)
VALUES (1, 'Avery Sample', 'avery@example.com', DATE '2026-08-01');
INSERT INTO Customer (CustomerID, DisplayName, Email, JoinedAt)
VALUES (2, 'Blair Sample', 'blair@example.com', DATE '2026-08-03');
INSERT INTO Customer (CustomerID, DisplayName, Email, JoinedAt)
VALUES (3, 'Casey Sample', 'casey@example.com', DATE '2026-08-05');
INSERT INTO Customer (CustomerID, DisplayName, Email, JoinedAt)
VALUES (4, 'Drew Sample', 'drew@example.com', DATE '2026-08-07');

-- Release dates deliberately differ from SetID and insertion order
INSERT INTO CardSet (SetID, SetName, ReleaseDate)
VALUES (3, 'Demo Mountain Collection', DATE '2025-01-10');
INSERT INTO CardSet (SetID, SetName, ReleaseDate)
VALUES (1, 'Demo Forest Collection', DATE '2024-04-12');
INSERT INTO CardSet (SetID, SetName, ReleaseDate)
VALUES (2, 'Demo Ocean Collection', DATE '2023-09-02');

-- Only PrintingID 1 matches every printing filter in query 3
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (1, 1, 'Demo Leaf Guardian', '001', 'English', 'Normal', 'Common');
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (2, 1, 'Demo Leaf Guardian', '001', 'English', 'Foil', 'Rare');
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (3, 1, 'Demo Leaf Guardian', '001', 'French', 'Normal', 'Common');
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (4, 1, 'Demo Woodland Scout', '002', 'English', 'Normal', 'Uncommon');
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (5, 2, 'Demo Tide Keeper', '001', 'English', 'Normal', 'Common');
INSERT INTO CardPrinting (PrintingID, SetID, CardName, CollectorNumber, CardLanguage, Variant, Rarity)
VALUES (6, 3, 'Demo Peak Watcher', '003', 'English', 'Normal', 'Rare');


-- Copies without a GradedCardCopy row are ungraded
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (1, 1, 'NearMint', 'Fictional ungraded copy currently available for sale.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (2, 1, 'NearMint', 'Fictional graded copy sold in delivered order 1.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (3, 1, 'LightlyPlayed', 'Fictional ungraded copy reserved for awaiting-payment order 5.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (4, 2, 'NearMint', 'Fictional graded foil copy sold in delivered order 1.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (5, 3, 'NearMint', 'Fictional ungraded French copy sold in shipped order 2.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (6, 4, 'NearMint', 'Fictional graded copy sold in paid order 3.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (7, 5, 'LightlyPlayed', 'Fictional ungraded copy sold in delivered order 4.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (8, 6, 'NearMint', 'Fictional ungraded copy reserved for awaiting-payment order 5.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (9, 1, 'NearMint', 'Fictional ungraded copy withdrawn after cancelled order 6.');
INSERT INTO CardCopy (CopyID, PrintingID, CardCondition, Description)
VALUES (10, 2, 'Damaged', 'Fictional ungraded damaged copy with no listing.');

-- Duplicate company names to demonstrate that DISTINCT in query 5 works
INSERT INTO GradedCardCopy (CopyID, GradingCompany, Grade, CertificationNumber)
VALUES (2, 'Demo GradeWorks', '9', 'DEMO-GW-0002');
INSERT INTO GradedCardCopy (CopyID, GradingCompany, Grade, CertificationNumber)
VALUES (4, 'Demo GradeWorks', '10', 'DEMO-GW-0004');
INSERT INTO GradedCardCopy (CopyID, GradingCompany, Grade, CertificationNumber)
VALUES (6, 'Demo CardCheck', '9.5', 'DEMO-CC-0006');

-- Copy 1 has one current Active listing and one withdrawn historical listing.
-- Reserved listings 4 and 9 belong to OTHER copies and must not match query 6.
-- Each sold copy appears in only one completed or paid order and is not relisted.
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (1, 1, 20.00, DATE '2026-09-20', 'Active');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (2, 1, 22.00, DATE '2026-09-01', 'Withdrawn');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (3, 2, 43.00, DATE '2026-09-02', 'Sold');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (4, 3, 11.00, DATE '2026-09-20', 'Reserved');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (5, 4, 28.00, DATE '2026-09-02', 'Sold');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (6, 5, 18.00, DATE '2026-09-04', 'Sold');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (7, 6, 24.00, DATE '2026-09-06', 'Sold');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (8, 7, 8.00, DATE '2026-09-07', 'Sold');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (9, 8, 35.00, DATE '2026-09-20', 'Reserved');
INSERT INTO Listing (ListingID, CopyID, AskingPrice, ListedAt, ListingStatus)
VALUES (10, 9, 14.00, DATE '2026-09-09', 'Withdrawn');

-- Orders 1, 2, and 3 match query 7; descending placement order is 3, 2, 1
-- Order 4 is excluded by customer, while orders 5 and 6 are excluded by status
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (1, 2, DATE '2026-09-10', 'Delivered', 5.00, 'Blair Sample', '102 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (2, 3, DATE '2026-09-16', 'Shipped', 4.00, 'Casey Sample', '103 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (3, 4, DATE '2026-09-19', 'Paid', 6.00, 'Drew Sample', '104 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (4, 1, DATE '2026-09-11', 'Delivered', 2.00, 'Avery Sample', '101 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (5, 2, DATE '2026-09-21', 'AwaitingPayment', 5.00, 'Blair Sample', '102 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');
INSERT INTO SalesOrder (OrderID, CustomerID, PlacedAt, OrderStatus, ShippingFee, RecipientName, Street, City, Province, PostalCode, Country)
VALUES (6, 3, DATE '2026-09-12', 'Cancelled', 3.00, 'Casey Sample', '103 Example Avenue', 'Sampleton', 'Ontario', 'A1A 1A1', 'Canada');

-- Order 1's lines are inserted in reverse order to demonstrate order by LineNo
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (1, 2, 5, 28.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (1, 1, 3, 43.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (2, 1, 6, 18.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (3, 1, 7, 24.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (4, 1, 8, 8.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (5, 1, 4, 11.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (5, 2, 9, 35.00);
INSERT INTO OrderLine (OrderID, LineNo, ListingID, AgreedPrice)
VALUES (6, 1, 10, 14.00);

-- Payment totals equal the order's agreed prices plus its shipping fee
INSERT INTO Payment (PaymentID, OrderID, PaidAt, Amount, Method, PaymentReference)
VALUES (1, 1, DATE '2026-09-11', 76.00, 'CreditCard', 'DEMO-PAY-0001');
INSERT INTO Payment (PaymentID, OrderID, PaidAt, Amount, Method, PaymentReference)
VALUES (2, 2, DATE '2026-09-17', 22.00, 'DebitCard', 'DEMO-PAY-0002');
INSERT INTO Payment (PaymentID, OrderID, PaidAt, Amount, Method, PaymentReference)
VALUES (3, 3, DATE '2026-09-20', 30.00, 'CreditCard', 'DEMO-PAY-0003');
INSERT INTO Payment (PaymentID, OrderID, PaidAt, Amount, Method, PaymentReference)
VALUES (4, 4, DATE '2026-09-12', 10.00, 'DebitCard', 'DEMO-PAY-0004');

-- Every shipment follows payment, delivered dates follow shipment dates
INSERT INTO Shipment (ShipmentID, OrderID, Carrier, TrackingNumber, ShippedAt, DeliveredAt)
VALUES (1, 1, 'Demo Parcel Service', 'DEMO-TRACK-0001', DATE '2026-09-12', DATE '2026-09-15');
INSERT INTO Shipment (ShipmentID, OrderID, Carrier, TrackingNumber, ShippedAt, DeliveredAt)
VALUES (2, 2, 'Demo Parcel Service', 'DEMO-TRACK-0002', DATE '2026-09-18', NULL);
INSERT INTO Shipment (ShipmentID, OrderID, Carrier, TrackingNumber, ShippedAt, DeliveredAt)
VALUES (3, 4, 'Demo Parcel Service', 'DEMO-TRACK-0004', DATE '2026-09-13', DATE '2026-09-16');

COMMIT;
