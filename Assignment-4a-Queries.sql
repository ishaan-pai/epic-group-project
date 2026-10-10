-- Query 1: List registered customers alphabetically by display name
SELECT CustomerID,
       DisplayName,
       Email,
       JoinedAt
FROM Customer
ORDER BY DisplayName ASC, CustomerID ASC;

-- Query 2: List card sets from the earliest release date to the latest
SELECT SetID,
       SetName,
       ReleaseDate
FROM CardSet
ORDER BY ReleaseDate ASC, SetID ASC;

-- Query 3: Find the English Normal printing numbered 001 in card set 1
SELECT PrintingID,
       SetID,
       CardName,
       CollectorNumber,
       CardLanguage,
       Variant,
       Rarity
FROM CardPrinting
WHERE SetID = 1
  AND CollectorNumber = '001'
  AND CardLanguage = 'English'
  AND Variant = 'Normal';

-- Query 4: List NearMint physical copies of printing 1, ordered by copy ID.
SELECT CopyID,
       PrintingID,
       CardCondition,
       Description
FROM CardCopy
WHERE PrintingID = 1
  AND CardCondition = 'NearMint'
ORDER BY CopyID ASC;

-- Query 5: List each grading company represented in the inventory once
SELECT DISTINCT GradingCompany
FROM GradedCardCopy
ORDER BY GradingCompany ASC;

-- Query 6: List active or reserved listings for physical copy 1, cheapest first
SELECT ListingID,
       CopyID,
       AskingPrice AS Asking_Price_CAD,
       ListedAt,
       ListingStatus
FROM Listing
WHERE CopyID = 1
  AND ListingStatus IN ('Active', 'Reserved')
ORDER BY AskingPrice ASC, ListingID ASC;

-- Query 7: List paid, shipped, or delivered orders from customers other than
-- customer 1, with the most recently placed orders first
SELECT OrderID,
       CustomerID,
       PlacedAt,
       OrderStatus,
       RecipientName,
       ShippingFee AS Shipping_Fee_CAD
FROM SalesOrder
WHERE CustomerID <> 1
  AND OrderStatus IN ('Paid', 'Shipped', 'Delivered')
ORDER BY PlacedAt DESC, OrderID ASC;

-- Query 8: List the items in order 1 in invoice line number order
SELECT OrderID,
       LineNo,
       ListingID,
       AgreedPrice AS Agreed_Price_CAD
FROM OrderLine
WHERE OrderID = 1
ORDER BY LineNo ASC;

-- Query 9: Show the successful payment recorded for order 1
SELECT PaymentID,
       OrderID,
       PaidAt,
       Amount AS Amount_CAD,
       Method,
       PaymentReference
FROM Payment
WHERE OrderID = 1;

-- Query 10: Show the shipment and delivery details recorded for order 1
SELECT ShipmentID,
       OrderID,
       Carrier,
       TrackingNumber,
       ShippedAt,
       DeliveredAt
FROM Shipment
WHERE OrderID = 1;

