-- View 1: catalogue of cards currently available for purchase
CREATE VIEW ActiveCardCatalogue AS
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
  AND L.ListingStatus = 'Active';

-- View 2: Item details for all orders, including pending and cancelled history
CREATE VIEW CustomerOrderItems AS
SELECT O.OrderID,
       C.CustomerID,
       C.DisplayName,
       O.OrderStatus,
       OL.LineNo,
       L.ListingID,
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
  AND CC.PrintingID = CP.PrintingID;

-- View 3: One receipt per recorded payment, including shipped/delivered orders too
CREATE VIEW PaidOrderReceipts AS
SELECT P.PaymentID,
       O.OrderID,
       C.DisplayName,
       O.OrderStatus,
       P.PaidAt,
       P.Amount AS Amount_CAD,
       P.Method,
       P.PaymentReference
FROM Customer C, SalesOrder O, Payment P
WHERE C.CustomerID = O.CustomerID
  AND O.OrderID = P.OrderID;
