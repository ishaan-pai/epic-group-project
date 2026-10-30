-- Assignment 5: POKEMON E-COMMERCE STORE

-- A5 Query 1: Find customers who bought graded cards in paid, shipped or delivered orders
SELECT C.CustomerID,
       C.DisplayName,
       C.Email
FROM Customer C
WHERE EXISTS (
    SELECT OL.OrderID
    FROM SalesOrder O, OrderLine OL, Listing L, GradedCardCopy G, Payment P
    WHERE O.CustomerID = C.CustomerID
      AND O.OrderID = OL.OrderID
      AND OL.ListingID = L.ListingID
      AND L.CopyID = G.CopyID
      AND O.OrderID = P.OrderID
      AND O.OrderStatus IN ('Paid', 'Shipped', 'Delivered')
)
ORDER BY C.DisplayName ASC, C.CustomerID ASC;

-- A5 Query 2: Combine payment and delivery follow up contacts, showing each customer once
SELECT C.CustomerID,
       C.DisplayName,
       C.Email
FROM Customer C, SalesOrder O
WHERE C.CustomerID = O.CustomerID
  AND O.OrderStatus = 'AwaitingPayment'
UNION
SELECT C.CustomerID,
       C.DisplayName,
       C.Email
FROM Customer C, SalesOrder O, Shipment S
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = S.OrderID
  AND O.OrderStatus = 'Shipped'
  AND S.DeliveredAt IS NULL
ORDER BY DisplayName ASC, CustomerID ASC;

-- A5 Query 3: Find orders with a recorded payment but no shipment record
SELECT O.OrderID,
       C.DisplayName,
       O.OrderStatus,
       O.PlacedAt
FROM Customer C, SalesOrder O, Payment P
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = P.OrderID
MINUS
SELECT O.OrderID,
       C.DisplayName,
       O.OrderStatus,
       O.PlacedAt
FROM Customer C, SalesOrder O, Shipment S
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = S.OrderID
ORDER BY OrderID ASC;

-- A5 Query 4: Find non cancelled orders containing at least two physical cards
SELECT O.OrderID,
       C.DisplayName,
       O.OrderStatus,
       COUNT(OL.LineNo) AS CardCount,
       SUM(OL.AgreedPrice) AS Subtotal_CAD
FROM Customer C, SalesOrder O, OrderLine OL
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = OL.OrderID
  AND O.OrderStatus <> 'Cancelled'
GROUP BY O.OrderID, C.DisplayName, O.OrderStatus
HAVING COUNT(OL.LineNo) >= 2
ORDER BY O.OrderID ASC;

-- A5 Query 5: Summarize paid card sales by set using agreed prices, excluding shipping
SELECT CS.SetID,
       CS.SetName,
       COUNT(OL.LineNo) AS CardsSold,
       SUM(OL.AgreedPrice) AS Total_Sales_CAD,
       AVG(OL.AgreedPrice) AS Average_Price_CAD
FROM CardSet CS, CardPrinting CP, CardCopy CC, Listing L,
     OrderLine OL, SalesOrder O, Payment P
WHERE CS.SetID = CP.SetID
  AND CP.PrintingID = CC.PrintingID
  AND CC.CopyID = L.CopyID
  AND L.ListingID = OL.ListingID
  AND OL.OrderID = O.OrderID
  AND O.OrderID = P.OrderID
  AND O.OrderStatus IN ('Paid', 'Shipped', 'Delivered')
GROUP BY CS.SetID, CS.SetName
ORDER BY CS.SetID ASC;
