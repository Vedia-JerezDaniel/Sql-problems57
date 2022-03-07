use northwind;

# one
SELECT * FROM Shippers;
# Two
SELECT CategoryName, Description from categories;
# Three
SELECT FirstName, LastName, HireDate from Employees	
where Title = "Sales Representative";
# Four
SELECT FirstName, LastName, HireDate from Employees	
where Title = "Sales Representative" and Country = 'USA';
# Five
SELECT FirstName, LastName, HireDate from Employees	
where Title = "Sales Representative";
# Six
SELECT OrderID, OrderDate from Orders	
where EmployeeID = 5;
# 7
SELECT SupplierID, ContactName, ContactTitle from Suppliers
WHERE ContactTitle <> 'Marketing Manager';
# 8
SELECT ProductID, ProductName from Products
Where ProductName LIKE '%queso%';
# 9
SELECT OrderID, CustomerID, ShipCountry from Orders
Where ShipCountry = 'France' OR ShipCountry = 'Belgium';
# 10
SELECT OrderID, CustomerID, ShipCountry from Orders
Where ShipCountry in ('Brazil','Mexico','Argentina','Venezuela');
# 11
SELECT FirstName, LastName, Title, BirthDate from Employees	
order BY BirthDate ASC;
# 12
SELECT FirstName, LastName, Title, CONVERT(BirthDate, date) as BD
from Employees	
order BY BirthDate ASC;
#13
SELECT FirstName, LastName, CONCAT(FirstName,'  ',LastName) as FullName
from Employees;	
#14
SELECT OrderID, ProductID, UnitPrice, Quantity, UnitPrice*Quantity as TotalPrice
from Orderdetails
order by OrderID AND ProductID;
#15
SELECT COUNT(CustomerID) as Totalcustomer from customers;
#16
SELECT OrderID, OrderDate from Orders
order by OrderDate LIMIT 1;
#17
SELECT ShipCountry from Orders
GROUP by (ShipCountry);
#18
SELECT ContactTitle, COUNT(ContactTitle) from customers
GROUP by (ContactTitle);
#19
SELECT ProductID, ProductName, CompanyName as Supplier 
FROM Products JOIN Suppliers
on Products.SupplierID = Suppliers.SupplierID;	
#20
select OrderID, DATE_FORMAT(OrderDate, "%M %d %Y") as Orderdate ,CompanyName
FROM Orders Join Shippers
ON Orders.ShipVia = Shippers.ShipperID
WHERE OrderID <10300;

## SECOND LEVEL
# INTERMEDIATE LEVEL

#21
select CategoryName, COUNT(ProductID) as TotalPr
FROM categories Join Products
ON categories.CategoryID = Products.CategoryID
GROUP BY(CategoryName)
ORDER BY(TotalPr) DESC;

#22
select Country, City, COUNT(CustomerID) as Total
FROM customers
GROUP BY Country, City
ORDER BY(Total) DESC;

#23
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
from Products
where UnitsInStock < ReorderLevel
ORDER BY(ProductID);

#24
SELECT ProductID, ProductName, UnitsInStock, 
UnitsOnOrder,ReorderLevel,Discontinued
from Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel AND
Discontinued = 0
ORDER BY(ProductID);
#25
SELECT CustomerID, CompanyName, Region, 
CASE
	WHEN Region IS NULL THEN 1
    ELSE 0
	END
from customers
Order by CompanyName;
#26
SELECT ShipCountry, AVG(Freight) as avgfreight 
from Orders
group by ShipCountry
Order by avgfreight desc;
#27
SELECT ShipCountry,
AVG(Freight) as avgfreight 
from Orders
where DATE_FORMAT(OrderDate, "%Y") >= 2015 and 
DATE_FORMAT(OrderDate, "%Y") < 2016
group by ShipCountry
Order by avgfreight desc;
#28
SELECT ShipCountry,
AVG(Freight) as avgfreight 
from Orders
where DATE_FORMAT(OrderDate, "%Y-%M-%d") > '2015-05-06'
group by ShipCountry
Order by avgfreight desc limit 4;
#29
select Employees.EmployeeID, LastName, Orders.OrderID, Orderdetails.Quantity, 
Products.ProductName
from Employees join Orders	
ON Employees.EmployeeID = Orders.EmployeeID
join Orderdetails
ON Orders.OrderID = Orderdetails.OrderID
join Products
ON Orderdetails.ProductID = Products.ProductID
ORDER by OrderID;
#30
select customers.CustomerID, Orders.CustomerID
from customers
left join Orders
on customers.CustomerID = Orders.CustomerID
WHERE Orders.CustomerID is NULL;
#31
select CustomerID
from Orders
WHERE Orders.EmployeeID <> 4
GROUP BY CustomerID;

# ADVANCED PROBLEMS
#32
select Orders.CustomerID, Orders.OrderID, customers.CompanyName,
sum(Orderdetails.UnitPrice * Orderdetails.Quantity) as Totalsale
from customers 
join Orders
on customers.CustomerID = Orders.CustomerID
join Orderdetails
ON Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(Orders.OrderDate, "%Y") > 2015
group by Orders.CustomerID, customers.CompanyName, Orders.OrderID
HAVING Totalsale > 10000
order by Totalsale desc;

#33
select Orders.CustomerID, Orders.OrderID, customers.CompanyName,
sum(Orderdetails.UnitPrice * Orderdetails.Quantity) as Totalsale
from customers 
join Orders
on customers.CustomerID = Orders.CustomerID
join Orderdetails
ON Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(Orders.OrderDate, "%Y") > 2015
group by Orders.OrderID, Orders.CustomerID, customers.CompanyName
HAVING Totalsale > 15000
order by Totalsale desc;

#34
select Orders.CustomerID, Orders.OrderID, customers.CompanyName,
sum(Orderdetails.UnitPrice * Orderdetails.Quantity) as Totalsale,
sum(Orderdetails.UnitPrice * Orderdetails.Quantity*(1-Orderdetails.Discount)) as 
Discountsale
from customers 
join Orders
on customers.CustomerID = Orders.CustomerID
join Orderdetails
ON Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(Orders.OrderDate, "%Y") > 2015
group by Orders.OrderID, Orders.CustomerID, customers.CompanyName
HAVING Totalsale > 10000
order by Discountsale desc;
#35
Select EmployeeID, count(OrderID),
date_format(Orders.OrderDate, "%Y %M %d") as dated
From Orders
where date_add(Orders.OrderDate, INTERVAL -1 month)# Where 
last_day(Orders.OrderDate) 
GROUP by EmployeeID, Orders.OrderDate;

# no se pudo

#36 No tiene sentido
Select
Orders.OrderID, COUNT(*) as TotalOrderDetails
From Orders
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
Group By Orders.OrderID
Order By count(*) desc limit 10;


#37
Select Orders.OrderID, Orders.CustomerID
From Orders
Group By Orders.OrderID, Orders.CustomerID
order by RAND()
limit 20;

#38
Select
Orders.OrderID, Orderdetails.Quantity
From Orders
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
where Orderdetails.Quantity >= 60
Group By Orders.OrderID, Quantity
HAVING COUNT(*) > 1
Order By OrderID;

#39 CTE Tables
with repeated_quantities AS (
    SELECT Orderdetails.OrderID
 FROM Orderdetails
 INNER JOIN Orders
 ON Orderdetails.OrderID = Orders.OrderID
    WHERE Orderdetails.Quantity >= 60
    GROUP BY
      Orderdetails.OrderID, Orderdetails.Quantity
    HAVING
      count(Orderdetails.Quantity) > 1
    ORDER BY Orderdetails.OrderID)
SELECT
  od.orderid,
  od.productid,
  od.unitprice,
  od.quantity,
  od.discount
FROM
  Orderdetails od
WHERE
  od.orderid in (SELECT orderid FROM repeated_quantities);

# 40 Avoid duplicates DERIVED TABLES
Select
Orderdetails.OrderID,ProductID,UnitPrice,Quantity,Discount
From Orderdetails
Join (Select DISTINCT OrderID From Orderdetails
      # use Distint to avoid duplicates
Where Quantity >= 60
Group By OrderID, Quantity
Having Count(*) > 1) as PotentialProblemOrders
on PotentialProblemOrders.OrderID = Orderdetails.OrderID
Order by OrderID, ProductID ;

## 41
Select
OrderID, date(OrderDate), 
date(RequiredDate) as req, date(ShippedDate) as ship from Orders
where date(RequiredDate) < date(ShippedDate);

# 42
SELECT
  o.EmployeeID,
  e.LastName,
  count(o.EmployeeID) as total_late
FROM  Orders o
INNER JOIN Employees e on o.EmployeeID = e.EmployeeID
WHERE
  o.RequiredDate <= o.ShippedDate
GROUP BY
  o.EmployeeID, e.LastName
ORDER BY
  total_late DESC;
  
# 43 REDO and Discussion
With LateOrders as (
Select EmployeeID, Count(*) as TotalOrders
From Orders
Where RequiredDate <= ShippedDate
Group By
EmployeeID)  ## 8 rows
, AllOrders as (
Select EmployeeID, Count(*) as TotalOrders
From Orders
Group By 
EmployeeID) ## 9 rows
Select Employees.EmployeeID, LastName, AllOrders.TotalOrders as Allorders,
LateOrders.TotalOrders as Lateorders
From Employees
Join AllOrders
on AllOrders.EmployeeID = Employees.EmployeeID
Join LateOrders
on LateOrders.EmployeeID = Employees.EmployeeID;

## 44 
With LateOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Where RequiredDate <= ShippedDate
Group By EmployeeID)  ## 8 rows
, AllOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Group By EmployeeID) ## 9 rows
Select Employees.EmployeeID, LastName, AllOrders.TotalOrders as Allorders,
LateOrders.TotalOrders as Lateorders
From Employees
LEFT Join AllOrders
on AllOrders.EmployeeID = Employees.EmployeeID
left Join LateOrders
on LateOrders.EmployeeID = Employees.EmployeeID;

## 45
With LateOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Where RequiredDate <= ShippedDate
Group By EmployeeID)  ## 8 rows
, AllOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Group By EmployeeID) ## 9 rows
Select Employees.EmployeeID, LastName, AllOrders.TotalOrders as Allorders,
IFNULL(LateOrders.TotalOrders,0) as Lateorders
From Employees
LEFT Join AllOrders
on AllOrders.EmployeeID = Employees.EmployeeID
left Join LateOrders
on LateOrders.EmployeeID = Employees.EmployeeID;

## 46
With LateOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Where RequiredDate <= ShippedDate
Group By EmployeeID)  ## 8 rows
, AllOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Group By EmployeeID) ## 9 rows
Select Employees.EmployeeID, LastName, AllOrders.TotalOrders as Allor,
ifnull(LateOrders.TotalOrders / AllOrders.TotalOrders,0) as lpert
From Employees
LEFT Join AllOrders
on AllOrders.EmployeeID = Employees.EmployeeID
left Join LateOrders
on LateOrders.EmployeeID = Employees.EmployeeID;

## 47
With LateOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Where RequiredDate <= ShippedDate
Group By EmployeeID)  ## 8 rows
, AllOrders as 
(Select EmployeeID, Count(*) as TotalOrders
From Orders
Group By EmployeeID) ## 9 rows
Select Employees.EmployeeID, LastName, AllOrders.TotalOrders as Allor,
round(ifnull(LateOrders.TotalOrders/AllOrders.TotalOrders,0),2) as lpert
From Employees
LEFT Join AllOrders
on AllOrders.EmployeeID = Employees.EmployeeID
left Join LateOrders
on LateOrders.EmployeeID = Employees.EmployeeID;

## 48
WITH Orders2016 as (
Select
customers.CustomerID, customers.CompanyName,SUM(Quantity * UnitPrice) as Total
From customers
Join Orders
on Orders.CustomerID = customers.CustomerID
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(OrderDate, "%Y") = '2016'
Group By customers.CustomerID, customers.CompanyName)
Select CustomerID,CompanyName,Total,
Case
when Total BETWEEN 0 and 1000 then 'Low'
when Total between 1001 and 5000 then 'Medium'
when Total between 5001 and 10000 then 'High'
when Total > 10000 then 'Very High'
End CustGroup # way to rename CASE END columns
from Orders2016
Order by CustomerID;

-- ## 49
WITH Orders2016 as (
Select
customers.CustomerID, customers.CompanyName,SUM(Quantity * UnitPrice) as Total
From customers
Join Orders
on Orders.CustomerID = customers.CustomerID
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(OrderDate, "%Y") = '2016'
Group By customers.CustomerID, customers.CompanyName)
Select CustomerID,CompanyName,Total,
Case
when Total >=0 and Total < 10000 then 'Low'
when Total between 1001 and 5000 then 'Medium'
when Total between 5001 and 10000 then 'High'
when Total > 10000 then 'Very High'
End CustGroup # way to rename CASE END columns
from Orders2016
Order by CustomerID;

--  50
WITH Orders2016 as (
Select
customers.CustomerID, customers.CompanyName,SUM(Quantity * UnitPrice) as Total
From customers
Join Orders
on Orders.CustomerID = customers.CustomerID
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(OrderDate, "%Y") = '2016'
Group By customers.CustomerID, customers.CompanyName),
Customergrup as (SELECT CustomerID,CompanyName,Total,
Case
when Total >= 0 and Total < 1000 then 'Low'
when Total >= 1000 and Total < 5000 then 'Medium'
when Total >= 5000 and Total < 10000 then 'High'
when Total > 10000 then 'Very High'
End CGroup 
from Orders2016)
select CGroup, count(*) as TotalinG, count(*)*1.0/(SELECT count(*) from Customergrup) as PercentinG 
FROM Customergrup
GROUP BY CGroup
Order by TotalinG DESC;

-- 51
WITH Orders2016 as (
Select
customers.CustomerID, customers.CompanyName,SUM(Quantity * UnitPrice) as Total
From customers
Join Orders
on Orders.CustomerID = customers.CustomerID
Join Orderdetails
on Orders.OrderID = Orderdetails.OrderID
where DATE_FORMAT(OrderDate, "%Y") = '2016'
Group By customers.CustomerID, customers.CompanyName)
Select CustomerID,CompanyName,Total,CustomerGroupName
from Orders2016
Join CustomerGroupThresholds
on Orders2016.Total between
CustomerGroupThresholds.RangeBottom and
CustomerGroupThresholds.RangeTop
Order by CustomerID;

-- 52 and 53

with countries AS (SELECT Country
  FROM Suppliers
  UNION
  SELECT Country
  FROM customers), 
suppliercountry AS (SELECT distinct Country
  FROM Suppliers), 
  customercountry AS (SELECT distinct Country
  FROM customers)
SELECT
  sp.country as suplier_country,
  cp.country as customer_country
FROM
  countries c
LEFT JOIN
  suppliercountry sp on c.country = sp.country
LEFT JOIN
  customercountry cp on c.country = cp.country;


 -- 54
with countries AS (SELECT Country FROM Suppliers
  UNION
  SELECT Country FROM customers)
SELECT
  c.country,
  coalesce(count(sp.country),0) as totalsupliers,
  coalesce(count(cp.country),0) as totalcustomers
FROM
  countries c LEFT JOIN
  Suppliers sp ON c.country = sp.country
LEFT JOIN customers cp ON c.country = cp.country
GROUP BY c.country;

-- 55
with ranked_orders AS (SELECT
    shipcountry,  customerid,  orderid, orderdate,
    rank() OVER(PARTITION BY shipcountry ORDER BY orderdate) as ranking
  FROM
    Orders)
SELECT
  shipcountry,  customerid,  orderid,  orderdate FROM
  ranked_orders
WHERE
  ranking = 1
ORDER BY
  shipcountry;

--56
SELECT
  initial_order.customerid,
  initial_order.orderid as initial_order_id,
  initial_order.orderdate as initial_order_date,
  next_order.orderid as nextorderid,
  next_order.orderdate as nextorderdate,
  (next_order.orderdate - initial_order.orderdate) as daysbetween
FROM
  Orders initial_order
INNER JOIN
  Orders next_order on initial_order.customerid = next_order.customerid
WHERE
  initial_order.orderid < next_order.orderid
  AND (next_order.orderdate - initial_order.orderdate) <= 5;

--57
WITH customer_orders AS (SELECT
    customerid, orderid as initial_order_id, orderdate as initial_order_date,
    LEAD (o.orderdate, 1) OVER ( PARTITION BY customerid ORDER BY orderdate) AS next_order_date
  FROM Orders o
  ORDER BY o.customerid, o.orderdate)
SELECT
  *, (co.next_order_date - co.initial_order_date) as daysbetween
FROM
  customer_orders co
WHERE
  (co.next_order_date - co.initial_order_date) <= 5;