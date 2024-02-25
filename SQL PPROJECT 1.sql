Create  Database Customers_Orders_Products 
use Customers_Orders_Products 

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100))

  INSERT INTO Customers (CustomerID, Name, Email) VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');

  CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT)

  INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity) VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);


  CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2))
  INSERT INTO Products (ProductID, ProductName, Price) VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

  --TASK 1--
  --Q1--
  SELECT * FROM Customers

  --Q2--
  SELECT NAME , EMAIL FROM Customers WHERE NAME LIKE 'J%'

  --Q3--
  SELECT OrderID, ProductName, Quantity FROM Orders

  --Q4--
  SELECT SUM(QUANTITY) AS 'TOTAL QUANTITY OF PRODUCTS ORDERED' FROM Orders

  --Q5--
  SELECT NAME FROM Customers
  INNER JOIN Orders
  ON Customers.CustomerID = Orders.CustomerID 

  --Q6--
  SELECT ProductName, PRICE FROM Products WHERE PRICE >10

  --Q7--
SELECT Customers.Name ,ORDERS.ORDERID, ORDERS.ORDERDATE FROM Customers
 LEFT JOIN ORDERS
 ON Customers.CUSTOMERID=ORDERS.CustomerID
 WHERE ORDERS.ORDERDATE>= '2023-07-05'

  --Q8--
select AVG(price) 'average price of all rpoducts' from Products 

--Q9--
SELECT NAME, Orders.Quantity FROM Customers
FULL OUTER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID 

--Q10----
CREATE  VIEW PROD_NOT_ORDERED
AS
SELECT PRODUCTS.ProductName ,  Orders.CustomerID  FROM Products
FULL JOIN Orders
ON Products.ProductName = Orders.ProductName 
WHERE ORDERS.PRODUCTNAME NOT IN (Products.PRODUCTNAME)

SELECT * FROM PROD_NOT_ORDERED WHERE  CustomerID IS NULL

---TASK 2---

--Q1--
SELECT TOP 5 QUANTITY , customers.name FROM Orders
left join Customers
on orders.CustomerID = customers.CustomerID
order by quantity desc


--Q2--
SELECT AVG(PRICE), ProductName FROM Products
GROUP BY Products.ProductName

--Q3--
SELECT NAME, Orders.ProductName FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.CustomerID IS NULL

--Q4--
SELECT Customers.Name, Orders.OrderID, Orders.ProductName, Orders.Quantity FROM Orders
LEFT JOIN Customers
ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Name LIKE 'M%'

--Q5--
SELECT Products.ProductName ,SUM(Orders.Quantity*Products.Price) 'TOTAL REVENUE'FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY Products.ProductName 

--Q6--
SELECT Customers.Name, SUM(Orders.Quantity*Products.Price) 'TOTAL REVENUE' FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY Customers.Name

--Q7---
SELECT Customers.CustomerID ,Customers.Name 
FROM Customers
WHERE NOT EXISTS(
	SELECT Products.ProductID 
	FROM Products
	WHERE NOT EXISTS(
	  SELECT 1

	  FROM Orders
	  WHERE ORDERS.CustomerID=Customers.CustomerID AND 
	  Orders.ProductName=Products.ProductName
	
	)

)

--Q8--------------------------------------------------DOUBT
SELECT CustomerID , OrderDate FROM Orders
GROUP BY CustomerID
HAVING COUNT (DISTINCT OrderDate)= 2

--Q9--
SELECT TOP 3 AVG(QUANTITY) 'HIGHEST AVERAGE QUANTITY' , ProductName FROM Orders
GROUP BY ProductName
ORDER BY AVG(Quantity) DESC

--Q10--------------------------------------------------------------DOUBT
SELECT AVG(QUANTITY) 'TOTAL AVERAGE', PRODUCTNAME FROM Orders
WHERE 'TOTAL AVERAGE' < QUANTITY 
GROUP BY ProductName


---TASK3----
--Q1-----------------------------DOUBT
SELECT * FROM Orders
FULL JOIN Products
ON Orders.ProductName=Products.ProductName
WHERE 

--Q2--
SELECT Products.ProductName FROM Products
RIGHT JOIN Orders
ON Orders.ProductName=Products.ProductName
WHERE Products.ProductName = Orders.ProductName

--Q3--
CREATE PROC MONTH_WISE_REVENUE
@ORDERDATE DATE
AS 
BEGIN
SELECT SUM(Orders.Quantity*Products.Price) 'TOTAL REVENUE' FROM Orders
INNER JOIN Products
ON Orders.ProductName=Products.ProductName
WHERE MONTH(orders.ORDERDATE) = MONTH( @ORDERDATE)
END

EXEC MONTH_WISE_REVENUE MONTH '07'

--Q4--
SELECT * FROM (SELECT ORDERS.PRODUCTNAME,COUNT(ORDERS.PRODUCTNAME) 'PURCHASE_FREQUENCY' FROM ORDERS
INNER JOIN Customers
ON ORDERS.CustomerID =Customers.CUSTOMERID
WHERE (SELECT COUNT(PRODUCTNAME) FROM Orders) > (SELECT COUNT(CUSTOMERID)*0.5 FROM CUSTOMERS)
GROUP BY Orders.ProductName)A WHERE PURCHASE_FREQUENCY > (SELECT COUNT(CUSTOMERID)*0.5 FROM CUSTOMERS)	

--Q5--
SELECT* FROM (SELECT TOP 5 ORDERS.Quantity*Products.Price 'AMT SPENT' , ORDERS.CustomerID FROM Orders
INNER JOIN Products
ON Orders.ProductName= Products.ProductName)A
ORDER BY [AMT SPENT] DESC

--Q6--
select ORDERID,CustomerID,PRODUCTNAME,QUANTITY,SUM(QUANTITY) OVER(ORDER BY CUSTOMERID) AS RUNNING_TOTAL FROM ORDERS

--Q7--
SELECT TOP 3 * FROM ORDERS
ORDER BY OrderDate DESC

--Q8--
SELECT CUSTOMERID, (ORDERS.Quantity * Products.Price) 'TOTAL REVENUE',OrderDate FROM Orders
INNER JOIN Products
ON Orders.ProductName=Products.ProductName
order by OrderDate desc

--Q9----------------------------------DOUBT
select ProductName FROM ORDERS
GROUP BY ProductName
HAVING COUNT(DISTINCT(PRODUCTNAME))>1 

--Q10--
SELECT CUSTOMERID, AVG(ORDERS.Quantity*Products.Price) 'AVERAGE' FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY CustomerID

--Q11----------------------------------DOUBT
SELECT CustomerID FROM ORDERS
WHERE YEAR (ORDERDATE)=2023
GROUP BY  CustomerID
HAVING COUNT(DISTINCT MONTH(ORDERDATE))= 07

--Q12--------------------------------------------DOUBT
select ProductName FROM ORDERS
GROUP BY ProductName
HAVING COUNT(DISTINCT(PRODUCTNAME))>1 


