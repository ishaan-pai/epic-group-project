-- Drop the project's views first, then child tables before their parent tables
-- Run only when removing an existing complete project schema
DROP VIEW PaidOrderReceipts;
DROP VIEW CustomerOrderItems;
DROP VIEW ActiveCardCatalogue;

DROP TABLE Shipment;
DROP TABLE Payment;
DROP TABLE OrderLine;
DROP TABLE SalesOrder;
DROP TABLE Listing;
DROP TABLE GradedCardCopy;
DROP TABLE CardCopy;
DROP TABLE CardPrinting;
DROP TABLE CardSet;
DROP TABLE Customer;
