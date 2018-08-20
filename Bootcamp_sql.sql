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

-----------------
--Simple SELECT Queries
--1. Write a SELECT statement that lists the customers along with their ID numbers. Include the last
--names, first names, and company names.
SELECT * FROM Sales.Customer;

--2. Write a SELECT statement that lists the name, product number, and color of each product.
SELECT [SpecialOfferID],[ProductID]
      ,[rowguid],[ModifiedDate]
  FROM [AdventureWorks2012].[Sales].[SpecialOfferProduct]

  -- Data Filtering

--  Write a query using a WHERE clause that displays all the employees listed in the
--HumanResources.Employee table who have the job title Research and Development Engineer.
--Display the business entity ID number, the login ID, and the title for each one.

SELECT BusinessEntityID, JobTitle, LoginID FROM HumanResources.Employee
WHERE JobTitle = 'Research and Development Engineer';

--2. Write a query using a WHERE clause that displays all the names in Person.Person with the middle
--name J. Display the first, last, and middle names along with the ID numbers.

SELECT FirstName, MiddleName, LastName, BusinessEntityID FROM Person.Person WHERE MiddleName = 'J';

-- working with dates
SELECT BusinessEntityID, FirstName, MiddleName, LastName, ModifiedDate
FROM Person.Person WHERE ModifiedDate BETWEEN '2005-12-01' AND '2006-12-31';

SELECT BusinessEntityID, FirstName, MiddleName, LastName, ModifiedDate
FROM Person.Person WHERE ModifiedDate NOT BETWEEN  '2005-12-01' AND '2006-12-31';

--Filtering with Wildcards
-- Write a query like the one in question 1 that displays the products with helmet in the name.
SELECT ProductID, Name FROM Production.Product WHERE Name LIKE '%helmet%';

-- Change the last query so that the products without helmet in the name are displayed.
SELECT ProductID, Name FROM Production.Product WHERE Name NOT LIKE '%helmet%';

--Write a query that displays those rows that have E or B stored in the middle name column.
SELECT BusinessEntityID, FirstName, MiddleName, LastName FROM Person.Person WHERE MiddleName LIKE '[E,B]';

--Filtering with Multiple Predicates

--Write a query displaying the data from Sales.SalesOrderHeader
--table. Retrieve only those rows where the order was placed during the month of September 2001
--and the total due exceeded $1,000.
SELECT SalesOrderID, OrderDate, TotalDue FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2005-09-01' AND '2006-09-30' AND TotalDue > 1000;

-- using the IN operator

SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate IN ('2005-09-01', '2006-09-02', '2007-09-03')
AND TotalDue > 1000;

-- using the logical operator
--Write a query displaying the sales orders where the total due exceeds $1,000. Retrieve only those
--rows where the salesperson ID is 279 or the territory ID is 6.
SELECT SalesOrderID, OrderDate, TotalDue, SalesPersonID, TerritoryID
FROM Sales.SalesOrderHeader WHERE TotalDue > 1000 AND (SalesPersonID = 279 OR TerritoryID IN(6,4));

-- working with NULLS

--Write a query displaying the ProductID, Name, and Color columns from rows in the
--Production.Product table. Display only those rows in which the color is not blue.

--Here are two possible solutions:
SELECT ProductID, Name, Color FROM Production.Product WHERE Color IS NULL OR Color <> 'Blue';

SELECT ProductID, Name, Color FROM Production.Product WHERE ISNULL(Color,'') <> 'Blue';

-- sorting data

--Write a query that returns the business entity ID and name columns from the Person.Person
--table. Sort the results by LastName, FirstName, and MiddleName.
SELECT BusinessEntityID, LastName, FirstName, MiddleName
FROM Person.Person ORDER BY LastName, FirstName, MiddleName;

-- in decreasing order
SELECT BusinessEntityID, LastName, FirstName, MiddleName
FROM Person.Person ORDER BY LastName, FirstName, MiddleName DESC;

-- JOINS

-- inner joins

-- joining HumanResources.Employee and Person.Person
SELECT JobTitle, BirthDate, FirstName, LastName
FROM HumanResources.Employee AS E
INNER JOIN Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID;


-- join Sales.SalesOrderHeader Sales.Customer Person.Person
SELECT c.CustomerID, StoreID, c.TerritoryID, FirstName, MiddleName,
LastName, SalesOrderID FROM Sales.Customer AS C INNER JOIN Person.Person AS P ON C.PersonID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS S ON S.CustomerID = C.CustomerID;

--Write a query that displays the names of the customers along with the product names that they
--have purchased. Hint: Five tables will be required to write this query!
--  Person.Person Sales.SalesOrderHeader Sales.SalesOrderDetail Sales.Customer Production.Product 
SELECT FirstName, MiddleName, LastName, Prod.Name
FROM Sales.Customer AS C INNER JOIN Person.Person AS P ON C.PersonID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS Prod ON SOD.ProductID = Prod.ProductID;

-- LEFT OUTER JOIN
--Write a query that displays all the products along with the SalesOrderID even if an order has never
--been placed for that product. Join to the Sales.SalesOrderDetail table using the ProductID
--column.
SELECT SalesOrderID, P.ProductID, P.Name
FROM Production.Product AS P
LEFT OUTER JOIN Sales.SalesOrderDetail
AS SOD ON P.ProductID = SOD.ProductID;

--Change the query written in question 1 so that only products that have not been ordered show up
--in the query.
SELECT SalesOrderID, P.ProductID, P.Name
FROM Production.Product AS P LEFT OUTER JOIN Sales.SalesOrderDetail
AS SOD ON P.ProductID = SOD.ProductID WHERE SalesOrderID IS NULL;

--The Sales.SalesOrderHeader table contains foreign keys to the Sales.CurrencyRate and
--Purchasing.ShipMethod tables. Write a query joining all three tables, making sure it contains all
--rows from Sales.SalesOrderHeader. Include the CurrencyRateID, AverageRate, SalesOrderID, and
--ShipBase columns.
SELECT CR.CurrencyRateID, CR.AverageRate, SM.ShipBase, SalesOrderID
FROM Sales.SalesOrderHeader AS SOH
LEFT OUTER JOIN Sales.CurrencyRate AS CR
ON SOH.CurrencyRateID = CR.CurrencyRateID
LEFT OUTER JOIN Purchasing.ShipMethod AS SM
ON SOH.ShipMethodID = SM.ShipMethodID;

--Writing Subqueries

--Using a subquery, display the product names and product ID numbers from the
--Production.Product table that have been ordered.
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID IN (SELECT ProductID FROM Sales.SalesOrderDetail);

--Change the query written in question 1 to display the products that have not been ordered.
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID NOT IN (
SELECT ProductID FROM Sales.SalesOrderDetail
WHERE ProductID IS NOT NULL);

--Write a UNION query that combines the ModifiedDate from Person.Person and the HireDate from
--HumanResources.Employee.
SELECT ModifiedDate
FROM Person.Person
UNION
SELECT HireDate
FROM HumanResources.Employee;


--Using Aggregate Functions
-- determine the number of customers in the Sales.Customer table.
SELECT COUNT(*) AS CountOfCustomers FROM Sales.Customer;

-- Write a query that lists the total number of products ordered. 
SELECT SUM(OrderQty) AS TotalProductsOrdered FROM Sales.SalesOrderDetail;

-- Write a query using the Production.Product table that displays the minimum, maximum, and average ListPrice.
SELECT MIN(ListPrice) AS Minimum,
MAX(ListPrice) AS Maximum,
AVG(ListPrice) AS Average
FROM Production.Product;

--Using the GROUP BY Clause
--Write a query that shows the total number of items ordered for each product. 
SELECT SUM(OrderQty) AS TotalOrdered, ProductID
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

--Write a query using the Sales.SalesOrderDetail table that displays a count of the detail lines for each SalesOrderID.
SELECT COUNT(*) AS CountOfOrders, SalesOrderID
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Write a query that displays the count of orders placed by year for each customer using the Sales.SalesOrderHeader table.
SELECT CustomerID, COUNT(*) AS CountOfSales, YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, YEAR(OrderDate);

--Using the HAVING Clause

--Write a query that returns a count of detail lines in the Sales.SalesOrderDetail table by
--SalesOrderID. Include only those sales that have more than three detail lines.
SELECT COUNT(*) AS CountOfDetailLines, SalesOrderID
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING COUNT(*) > 3;

--Write a query that groups the products by ProductModelID along with a count. Display the rows
--that have a count that equals 1.
SELECT ProductModelID, COUNT(*) AS CountOfProducts
FROM Production.Product
GROUP BY ProductModelID
HAVING COUNT(*) = 1;

--Write a query that groups the products by ProductModelID along with a count. Display the rows
--that have a count that equals 1.
SELECT ProductModelID, COUNT(*) AS CountOfProducts
FROM Production.Product
GROUP BY ProductModelID
HAVING COUNT(*) = 1;


--Write a query using the Sales.SalesOrderDetail table to come up with a count of unique
--ProductID values that have been ordered.
SELECT COUNT(DISTINCT ProductID) AS CountOFProductID
FROM Sales.SalesOrderDetail;

--Write a query using the Sales.SalesOrderHeader table that returns the count of unique
--TerritoryID values per customer.
SELECT COUNT(DISTINCT TerritoryID) AS CountOfTerritoryID, CustomerID
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;
