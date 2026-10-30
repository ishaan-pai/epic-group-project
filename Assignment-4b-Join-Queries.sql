-- Query 11: Show available cards with their set, version, condition and price
SELECT L.ListingID,
       CC.CopyID,
       CP.CardName,
       CS.SetName,
       CP.CollectorNumber,
       CP.CardLanguage,
       CP.Variant,
       CC.CardCondition,
       L.AskingPrice AS Asking_Price_CAD
FROM Listing L, CardCopy CC, CardPrinting CP, CardSet CS
WHERE L.CopyID = CC.CopyID
  AND CC.PrintingID = CP.PrintingID
  AND CP.SetID = CS.SetID
  AND L.ListingStatus = 'Active'
ORDER BY CP.CardName ASC, L.AskingPrice ASC, L.ListingID ASC;

-- Query 12: Show the customer and exact physical cards purchased in order 1
SELECT O.OrderID,
       C.DisplayName,
       OL.LineNo,
       CC.CopyID,
       CP.CardName,
       CP.CardLanguage,
       CP.Variant,
       CC.CardCondition,
       OL.AgreedPrice AS Agreed_Price_CAD
FROM Customer C, SalesOrder O, OrderLine OL,
     Listing L, CardCopy CC, CardPrinting CP
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = OL.OrderID
  AND OL.ListingID = L.ListingID
  AND L.CopyID = CC.CopyID
  AND CC.PrintingID = CP.PrintingID
  AND O.OrderID = 1
ORDER BY OL.LineNo ASC;

-- Query 13: Show shipped orders that have not yet been delivered
SELECT O.OrderID,
       C.DisplayName,
       S.Carrier,
       S.TrackingNumber,
       S.ShippedAt
FROM Customer C, SalesOrder O, Shipment S
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = S.OrderID
  AND O.OrderStatus = 'Shipped'
  AND S.DeliveredAt IS NULL
ORDER BY S.ShippedAt ASC, O.OrderID ASC;
