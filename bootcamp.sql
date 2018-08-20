CREATE TABLE [dbo].[demoProduct](
[ProductID] [INT] NOT NULL PRIMARY KEY,
[Name] [dbo].[Name] NOT NULL,
[Color] [NVARCHAR](15) NULL,
[StandardCost] [MONEY] NOT NULL,
[ListPrice] [MONEY] NOT NULL,
[Size] [NVARCHAR](5) NULL,
[Weight] [DECIMAL](8, 2) NULL,
);

CREATE TABLE [dbo].[demoSalesOrderHeader](
[SalesOrderID] [INT] NOT NULL PRIMARY KEY,
[SalesID] [INT] NOT NULL IDENTITY,
[OrderDate] [DATETIME] NOT NULL,
[CustomerID] [INT] NOT NULL,
[SubTotal] [MONEY] NOT NULL,
[TaxAmt] [MONEY] NOT NULL,
[Freight] [MONEY] NOT NULL,
[DateEntered] [DATETIME],
[TotalDue] AS (ISNULL(([SubTotal]+[TaxAmt])+[Freight],(0))),
[RV] ROWVERSION NOT NULL);

INSERT INTO dbo.demoProduct(ProductID, Name, Color,StandardCost, ListPrice, Size, Weight)
VALUES (680,'HL Road Frame - Black, 58','Black',1059.31,1431.50,'58',1016.04);

INSERT INTO dbo.demoProduct(ProductID, Name, Color,StandardCost, ListPrice, Size, Weight)
VALUES (706,'HL Road Frame - Red, 58','Red',1059.31, 1431.50,'58',1016.04);

INSERT INTO dbo.demoProduct(ProductID, Name, Color,
StandardCost, ListPrice, Size, Weight)
VALUES 
(711,'Sport-100 Helmet, Blue','Blue',13.0863,34.99,NULL,NULL),
(712,'AWC Logo Cap','Multi',6.9223,8.99,NULL,NULL),
(713,'Long-Sleeve Logo Jersey,S','Multi',38.4923,49.99,'S',NULL),
(714,'Long-Sleeve Logo Jersey,M','Multi',38.4923,49.99,'M',NULL),
(715,'Long-Sleeve Logo Jersey,L','Multi',38.4923,49.99,'L',NULL);

CREATE TABLE dbo.testCustomer (
CustomerID INT NOT NULL IDENTITY PRIMARY KEY,
FirstName VARCHAR(25), LastName VARCHAR(25),
Age INT, Active CHAR(1) DEFAULT 'Y',
CONSTRAINT ch_testCustomer_Age CHECK (Age < 120),
CONSTRAINT ch_testCustomer_Active CHECK (Active IN ('Y','N'))
);

CREATE TABLE dbo.testOrder (CustomerID INT NOT NULL,
OrderID INT NOT NULL IDENTITY PRIMARY KEY,
OrderDate DATETIME DEFAULT GETDATE(),
RW ROWVERSION,
CONSTRAINT fk_testOrders FOREIGN KEY (CustomerID)
REFERENCES dbo.testCustomer(CustomerID)
);

CREATE TABLE dbo.testOrderDetail(
OrderID INT NOT NULL, ItemID INT NOT NULL,
Price Money NOT NULL, Qty INT NOT NULL,
LineItemTotal AS (Price * Qty),
CONSTRAINT pk_testOrderDetail PRIMARY KEY (OrderID, ItemID),
CONSTRAINT fk_testOrderDetail FOREIGN KEY (OrderID)
REFERENCES dbo.testOrder(OrderID)
);