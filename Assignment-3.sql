CREATE TABLE Customer (
    CustomerID  NUMBER(10)    NOT NULL,
    DisplayName VARCHAR2(100) NOT NULL,
    Email       VARCHAR2(254) NOT NULL,
    JoinedAt    DATE          NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (CustomerID),
    CONSTRAINT customer_email_uq UNIQUE (Email)
);

CREATE TABLE CardSet (
    SetID       NUMBER(10)    NOT NULL,
    SetName     VARCHAR2(120) NOT NULL,
    ReleaseDate DATE          NOT NULL,
    CONSTRAINT cardset_pk PRIMARY KEY (SetID)
);

CREATE TABLE CardPrinting (
    PrintingID     NUMBER(10)    NOT NULL,
    SetID          NUMBER(10)    NOT NULL,
    CardName       VARCHAR2(120) NOT NULL,
    CollectorNumber VARCHAR2(20) NOT NULL,
    CardLanguage   VARCHAR2(30)  NOT NULL,
    Variant        VARCHAR2(60)  NOT NULL,
    Rarity         VARCHAR2(40)  NOT NULL,
    CONSTRAINT cardprinting_pk PRIMARY KEY (PrintingID),
    CONSTRAINT cardprinting_set_fk
        FOREIGN KEY (SetID) REFERENCES CardSet (SetID),
    CONSTRAINT cardprinting_version_uq
        UNIQUE (SetID, CollectorNumber, CardLanguage, Variant)
);

CREATE TABLE CardCopy (
    CopyID              NUMBER(10)     NOT NULL,
    PrintingID          NUMBER(10)     NOT NULL,
    CardCondition       VARCHAR2(20)   NOT NULL,
    Description         VARCHAR2(1000) NOT NULL,
    GradingCompany      VARCHAR2(60),
    Grade               VARCHAR2(20),
    CertificationNumber VARCHAR2(80),
    CONSTRAINT cardcopy_pk PRIMARY KEY (CopyID),
    CONSTRAINT cardcopy_printing_fk
        FOREIGN KEY (PrintingID) REFERENCES CardPrinting (PrintingID),
    CONSTRAINT cardcopy_condition_ck
        CHECK (CardCondition IN
            ('NearMint', 'LightlyPlayed', 'ModeratelyPlayed',
             'HeavilyPlayed', 'Damaged')),
    CONSTRAINT cardcopy_grading_ck
        CHECK (
            (GradingCompany IS NULL AND Grade IS NULL
             AND CertificationNumber IS NULL)
            OR
            (GradingCompany IS NOT NULL AND Grade IS NOT NULL
             AND CertificationNumber IS NOT NULL)
        )
);

CREATE TABLE Listing (
    ListingID     NUMBER(10)    NOT NULL,
    CopyID        NUMBER(10)    NOT NULL,
    AskingPrice   NUMBER(10,2)  NOT NULL,
    ListedAt      DATE          NOT NULL,
    ListingStatus VARCHAR2(12) DEFAULT 'Active' NOT NULL,
    CONSTRAINT listing_pk PRIMARY KEY (ListingID),
    CONSTRAINT listing_copy_fk
        FOREIGN KEY (CopyID) REFERENCES CardCopy (CopyID),
    CONSTRAINT listing_price_ck CHECK (AskingPrice > 0),
    CONSTRAINT listing_status_ck
        CHECK (ListingStatus IN ('Active', 'Reserved', 'Sold', 'Withdrawn'))
);

CREATE TABLE SalesOrder (
    OrderID       NUMBER(10)     NOT NULL,
    CustomerID    NUMBER(10)     NOT NULL,
    PlacedAt      DATE           NOT NULL,
    OrderStatus   VARCHAR2(20) DEFAULT 'AwaitingPayment' NOT NULL,
    ShippingFee   NUMBER(10,2)   NOT NULL,
    RecipientName VARCHAR2(120)  NOT NULL,
    Street        VARCHAR2(200)  NOT NULL,
    City          VARCHAR2(100)  NOT NULL,
    Province      VARCHAR2(100),
    PostalCode    VARCHAR2(20)   NOT NULL,
    Country       VARCHAR2(100)  NOT NULL,
    CONSTRAINT salesorder_pk PRIMARY KEY (OrderID),
    CONSTRAINT salesorder_customer_fk
        FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
    CONSTRAINT salesorder_shipping_ck CHECK (ShippingFee >= 0),
    CONSTRAINT salesorder_status_ck
        CHECK (OrderStatus IN
            ('AwaitingPayment', 'Paid', 'Shipped', 'Delivered', 'Cancelled'))
);

-- 7. Weak entity: LineNo identifies a line only within its owning order.
-- Each line represents one physical copy, so Quantity is not needed.
-- ListingID is not globally UNIQUE: cancelled order lines are retained.
CREATE TABLE OrderLine (
    OrderID     NUMBER(10)   NOT NULL,
    LineNo      NUMBER(10)   NOT NULL,
    ListingID   NUMBER(10)   NOT NULL,
    AgreedPrice NUMBER(10,2) NOT NULL,
    CONSTRAINT orderline_pk PRIMARY KEY (OrderID, LineNo),
    CONSTRAINT orderline_order_fk
        FOREIGN KEY (OrderID) REFERENCES SalesOrder (OrderID),
    CONSTRAINT orderline_listing_fk
        FOREIGN KEY (ListingID) REFERENCES Listing (ListingID),
    CONSTRAINT orderline_listing_uq UNIQUE (OrderID, ListingID),
    CONSTRAINT orderline_number_ck CHECK (LineNo > 0),
    CONSTRAINT orderline_price_ck CHECK (AgreedPrice > 0)
);

CREATE TABLE Payment (
    PaymentID        NUMBER(10)    NOT NULL,
    OrderID          NUMBER(10)    NOT NULL,
    PaidAt           DATE          NOT NULL,
    Amount           NUMBER(10,2)  NOT NULL,
    Method           VARCHAR2(30)  NOT NULL,
    PaymentReference VARCHAR2(100) NOT NULL,
    CONSTRAINT payment_pk PRIMARY KEY (PaymentID),
    CONSTRAINT payment_order_fk
        FOREIGN KEY (OrderID) REFERENCES SalesOrder (OrderID),
    CONSTRAINT payment_order_uq UNIQUE (OrderID),
    CONSTRAINT payment_amount_ck CHECK (Amount > 0)
);

CREATE TABLE Shipment (
    ShipmentID     NUMBER(10)    NOT NULL,
    OrderID        NUMBER(10)    NOT NULL,
    Carrier        VARCHAR2(60)  NOT NULL,
    TrackingNumber VARCHAR2(100) NOT NULL,
    ShippedAt      DATE          NOT NULL,
    DeliveredAt    DATE,
    CONSTRAINT shipment_pk PRIMARY KEY (ShipmentID),
    CONSTRAINT shipment_order_fk
        FOREIGN KEY (OrderID) REFERENCES SalesOrder (OrderID),
    CONSTRAINT shipment_order_uq UNIQUE (OrderID),
    CONSTRAINT shipment_dates_ck
        CHECK (DeliveredAt IS NULL OR DeliveredAt >= ShippedAt)
);

