-- using operators
-- Write a query that displays in the “AddressLine1 (City PostalCode)” format from the Person.Address table.
SELECT AddressLine1 + ':'+ ' (' + City + ' ' + PostalCode + ')' FROM Person.Address;

-- replacing NULL

-- Write a query using the Production.Product table displaying the product ID, color, and name columns. If the color column contains a NULL value, replace the color with No Color.
SELECT ProductID, ISNULL(Color,'No Color') AS Color, Name FROM Production.Product;

--Write a query using the Production.Product table displaying a description with the “ProductID:
--Name” format. Hint: You will need to use a function to write this query.
-- Here are two possible answers:
SELECT CAST(ProductID AS VARCHAR) + ': ' + Name AS IDName FROM Production.Product;
SELECT CONVERT(VARCHAR, ProductID) + ': ' + Name AS IDName FROM Production.Product;

--Write a query using the Sales.SpecialOffer table that multiplies the MaxQty column by the
--DiscountPCT column. If the MaxQty value is null, replace it with the value 10. Include the
--SpecialOfferID and Description columns in the results.
SELECT SpecialOfferID, Description, ISNULL(MaxQty,10) * DiscountPct AS Discount FROM Sales.SpecialOffer;

--Using Date Functions
--Write a query that calculates the number of days between the date an order was placed and the
--date that it was shipped using the Sales.SalesOrderHeader table. Include the SalesOrderID,
--OrderDate, and ShipDate columns.
SELECT SalesOrderID, OrderDate, ShipDate, DATEDIFF(d,OrderDate,ShipDate) AS NumberOfDays
FROM Sales.SalesOrderHeader;

--Write a query that displays only the date, not the time, for the order date and ship date in the
--Sales.SalesOrderHeader table.
SELECT CONVERT(VARCHAR,OrderDate,1) AS OrderDate,CONVERT(VARCHAR, ShipDate,1) AS ShipDate
FROM Sales.SalesOrderHeader;

--Write a query that adds six months to each order date in the Sales.SalesOrderHeader table.
--Include the SalesOrderID and OrderDate columns.
SELECT SalesOrderID, OrderDate, DATEADD(m,6,OrderDate) Plus6Months 
FROM Sales.SalesOrderHeader;

--Write a query that displays the year of each order date and the numeric month of each order date
--in separate columns in the results. Include the SalesOrderID and OrderDate columns.

--Here are two possible solutions:
SELECT SalesOrderID, OrderDate, YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth FROM Sales.SalesOrderHeader;

SELECT SalesOrderID, OrderDate, DATEPART(yyyy,OrderDate) AS OrderYear,
DATEPART(m,OrderDate) AS OrderMonth FROM Sales.SalesOrderHeader;
-- display the month name
SELECT SalesOrderID, OrderDate, DATEPART(yyyy,OrderDate) AS OrderYear,
DATENAME(m,OrderDate) AS OrderMonth FROM Sales.SalesOrderHeader;

-- using case function
--Also include a CASE statement that displays “Even” when the BusinessEntityID value is an even
--number or “Odd” when it is odd. Hint: Use the modulo operator.
SELECT BusinessEntityID,
CASE BusinessEntityID % 2 WHEN 0 THEN 'Even' ELSE 'Odd' END
FROM HumanResources.Employee;

--Write a query using the Sales.SalesOrderDetail table to display a value (“Under 10” or “10–19” or
--“20–29” or “30–39” or “40 and over”) based on the OrderQty value by using the CASE function.
--Include the SalesOrderID and OrderQty columns in the results.
SELECT SalesOrderID, OrderQty,
CASE WHEN OrderQty BETWEEN 0 AND 9 THEN 'Under 10'
WHEN OrderQty BETWEEN 10 AND 19 THEN '10-19'
WHEN OrderQty BETWEEN 20 AND 29 THEN '20-29'
WHEN OrderQty BETWEEN 30 AND 39 THEN '30-39'
ELSE '40 and over' end AS range
FROM Sales.SalesOrderDetail;

-- using the functions in where and orderby clause
SELECT SalesOrderID, (OrderDate)
FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) in( 2005,2006);

SELECT SalesOrderID, OrderDate,MONTH(OrderDate) AS Month, YEAR(OrderDate)as Year FROM Sales.SalesOrderHeader
ORDER BY MONTH(OrderDate), YEAR(OrderDate) desc;


