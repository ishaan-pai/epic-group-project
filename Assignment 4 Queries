-- List registered customers alphabetically by display name
SELECT CustomerID AS Customer_ID,
       DisplayName AS Customer_Name,
       Email AS Email,
       JoinedAt AS Joined_Date
FROM Customer
ORDER BY DisplayName ASC, CustomerID ASC;

-- List card sets from the earliest release date to the latest
SELECT SetID AS Set_ID,
       SetName AS Set_Name,
       ReleaseDate AS Release_Date
FROM CardSet
ORDER BY ReleaseDate ASC, SetID ASC;

-- Find the English Normal printing numbered 001 in card set 1
SELECT PrintingID AS Printing_ID,
       SetID AS Set_ID,
       CardName AS Card_Name,
       CollectorNumber AS Collector_Number,
       CardLanguage AS Language,
       Variant AS Variant,
       Rarity AS Rarity
FROM CardPrinting
WHERE SetID = 1
  AND CollectorNumber = '001'
  AND CardLanguage = 'English'
  AND Variant = 'Normal';

-- List NearMint physical copies of printing 1, ordered by copy ID
SELECT CopyID AS Copy_ID,
       PrintingID AS Printing_ID,
       CardCondition AS Condition,
       Description AS Description
FROM CardCopy
WHERE PrintingID = 1
  AND CardCondition = 'NearMint'
ORDER BY CopyID ASC;

-- List each grading company represented in the inventory once
SELECT DISTINCT GradingCompany AS Grading_Company
FROM GradedCardCopy
ORDER BY GradingCompany ASC;

-- List active or reserved listings for physical copy 1, cheapest first
SELECT ListingID AS Listing_ID,
       CopyID AS Copy_ID,
       AskingPrice AS Asking_Price_CAD,
       ListedAt AS Listed_Date,
       ListingStatus AS Listing_Status
FROM Listing
WHERE CopyID = 1
  AND ListingStatus IN ('Active', 'Reserved')
ORDER BY AskingPrice ASC, ListingID ASC;

-- List paid, shipped, or delivered orders from customers other than
-- customer 1, with the most recently placed orders first
SELECT OrderID AS Order_ID,
       CustomerID AS Customer_ID,
       PlacedAt AS Placed_Date,
       OrderStatus AS Order_Status,
       RecipientName AS Recipient_Name,
       ShippingFee AS Shipping_Fee_CAD
FROM SalesOrder
WHERE CustomerID <> 1
  AND OrderStatus IN ('Paid', 'Shipped', 'Delivered')
ORDER BY PlacedAt DESC, OrderID ASC;

-- List the items in order 1 in invoice line number order
SELECT OrderID AS Order_ID,
       LineNo AS Line_Number,
       ListingID AS Listing_ID,
       AgreedPrice AS Agreed_Price_CAD
FROM OrderLine
WHERE OrderID = 1
ORDER BY LineNo ASC;

-- Show the successful payment recorded for order 1
SELECT PaymentID AS Payment_ID,
       OrderID AS Order_ID,
       PaidAt AS Paid_Date,
       Amount AS Amount_CAD,
       Method AS Payment_Method,
       PaymentReference AS Payment_Reference
FROM Payment
WHERE OrderID = 1;

-- Show the shipment and delivery details recorded for order 1
SELECT ShipmentID AS Shipment_ID,
       OrderID AS Order_ID,
       Carrier AS Carrier,
       TrackingNumber AS Tracking_Number,
       ShippedAt AS Shipped_Date,
       DeliveredAt AS Delivered_Date
FROM Shipment
WHERE OrderID = 1;
