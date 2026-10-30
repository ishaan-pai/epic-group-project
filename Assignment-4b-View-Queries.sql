-- View 1 results: Available cards ordered by name, price and listing ID
SELECT ListingID,
       CopyID,
       CardName,
       SetName,
       CollectorNumber,
       CardLanguage,
       Variant,
       CardCondition,
       Asking_Price_CAD
FROM ActiveCardCatalogue
ORDER BY CardName ASC, Asking_Price_CAD ASC, ListingID ASC;

-- View 2 results: ordered items, with status shown to distinguish order history
SELECT OrderID,
       DisplayName,
       OrderStatus,
       LineNo,
       CopyID,
       CardName,
       CardLanguage,
       Variant,
       CardCondition,
       Agreed_Price_CAD
FROM CustomerOrderItems
ORDER BY OrderID ASC, LineNo ASC;

-- View 3 results: Payment receipts, most recent payment first
SELECT PaymentID,
       OrderID,
       DisplayName,
       OrderStatus,
       PaidAt,
       Amount_CAD,
       Method,
       PaymentReference
FROM PaidOrderReceipts
ORDER BY PaidAt DESC, PaymentID ASC;
