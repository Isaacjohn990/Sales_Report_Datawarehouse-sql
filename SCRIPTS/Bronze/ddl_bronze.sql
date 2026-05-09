/* 
====================================================================
DDL Script: Create Bronze Tables
====================================================================
Scripts Purpose:
    This script creates table in the 'bronze' schema, dropping existing
    tables if they already exist.
RUN this script to re-define the DDL structure of 'bronze' Tables
=====================================================================

*/
--- Creating Stored Procedure to load data into Bronze_Layer Table
EXEC  Bronze_layer.load_Bronze

CREATE OR ALTER PROCEDURE Bronze_layer.load_Bronze
AS
BEGIN

PRINT '-------------------------------------------------';
PRINT 'loading Data into tables';
PRINT '-------------------------------------------------';

-- For Customers Table
TRUNCATE TABLE bronze_layer.customers; 

BULK INSERT bronze_layer.customers
FROM "C:\Users\USER\Documents\New dataset - sql-warehouse\Customers.csv"
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

SELECT COUNT (*) FROM bronze_layer.customers;

-- For Employees Table
TRUNCATE TABLE bronze_layer.Employees;

BULK INSERT bronze_layer.Employees
FROM "C:\Users\USER\Documents\New dataset - sql-warehouse\Employees.csv"
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

SELECT COUNT (*) FROM bronze_layer.Employees;

-- For Orders Table
TRUNCATE TABLE bronze_layer.Orders;

BULK INSERT bronze_layer.Orders
FROM "C:\Users\USER\Documents\New dataset - sql-warehouse\Orders.csv"
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
SELECT COUNT (*) FROM bronze_layer.Orders;

-- For OrdersArchive Table
TRUNCATE TABLE bronze_layer.OrdersArchive

BULK INSERT bronze_layer.OrdersArchive
FROM "C:\Users\USER\Documents\New dataset - sql-warehouse\OrdersArchive.csv"
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

SELECT COUNT (*) FROM bronze_layer.OrdersArchive;

-- For Products Table
TRUNCATE TABLE bronze_layer.Products;

BULK INSERT bronze_layer.Products
FROM "C:\Users\USER\Documents\New dataset - sql-warehouse\Products.csv"
WI====================================================



--- Creating Table for Bronze Layer

IF OBJECT_ID ('Bronze_layer.customers', 'U') IS NOT NULL 	
DROP TABLE Bronze_layer.customers;

CREATE TABLE bronze_layer.customers (
	CustomerID INT ,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Country NVARCHAR(50),
	Score INT
	);
GO

IF OBJECT_ID ('Bronze_layer.Employees', 'U') IS NOT NULL 	
DROP TABLE Bronze_layer.Employees;

CREATE TABLE bronze_layer.Employees (
	EmployeeID INT ,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Department NVARCHAR(50),
	BirthDate DATE,
	Gender NVARCHAR(10),
	Salary INT,
	ManagerID INT
	);

GO

IF OBJECT_ID ('Bronze_layer.', 'U') IS NOT NULL 	
DROP TABLE Bronze_layer.Orders;

CREATE TABLE bronze_layer.Orders (
	OrderID INT,
	ProductID INT,
	CustomerID INT,
	SalesPersonID INT,
	OrderDate DATE,
	ShipDate DATE,
	OrderStatus NVARCHAR(50),
	ShipAddress NVARCHAR(50),
	BillAddress NVARCHAR(50),
	Quantity INT,
	Sales INT
	);
GO

IF OBJECT_ID ('Bronze_layer.OrdersArchive', 'U') IS NOT NULL 	
DROP TABLE Bronze_layer.customers;

CREATE TABLE bronze_layer.OrdersArchive (
	OrderID INT,
	ProductID INT,
	CustomerID INT,
	SalesPersonID INT,
	OrderDate DATE,
	ShipDate DATE,
	OrderStatus NVARCHAR(50),
	ShipAddress NVARCHAR(50),
	BillAddress NVARCHAR(50),
	Quantity INT,
	Sales INT
);
GO

IF OBJECT_ID ('Bronze_layer.Products', 'U') IS NOT NULL 	
DROP TABLE Bronze_layer.Products;

CREATE TABLE bronze_layer.Products (
	ProductID INT,
	Products NVARCHAR(50),
	Category NVARCHAR(50),
	Price INT
	);
GO





	
