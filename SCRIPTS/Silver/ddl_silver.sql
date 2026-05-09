/*
===============================================================================
DDL Script: Create Silver Tables (Cleaned & Standardized)
===============================================================================
Script Purpose:
    This script creates cleaned and standardized tables in the 'silver' schema.
    It applies data quality rules, standardization, and light enrichment 
    based on recurring data issues identified (e.g., gender, sales amounts, 
    order dates, etc.).
    
    This script should be executed after the Bronze tables have been loaded.
===============================================================================
*/


-- Silver table for customers
IF OBJECT_ID ('silver_layer.customers', 'U') IS NOT NULL 	
DROP TABLE silver_layer.customers;

CREATE TABLE silver_layer.customers (
	CustomerID INT ,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Country NVARCHAR(50),
	Score INT
	);
GO

-- Silver Table for Employees
IF OBJECT_ID ('silver_layer.Employees', 'U') IS NOT NULL 	
DROP TABLE silver_layer.Employees;

CREATE TABLE silver_layer.Employees (
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


-- Silver Table for Orders
IF OBJECT_ID ('silver_layer.', 'U') IS NOT NULL 	
DROP TABLE silver_layer.Orders;

CREATE TABLE silver_layer.Orders (
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
	Sales INT,
	CreationTime DATETIME
	);
GO

-- Silver Table for OrdersArchive
IF OBJECT_ID ('silver_layer.OrdersArchive', 'U') IS NOT NULL 	
DROP TABLE silver_layer.customers;

CREATE TABLE silver_layer.OrdersArchive (
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
	Sales INT,
	CreationTime DATETIME
);
GO

-- silver Table for Products
IF OBJECT_ID ('silver_layer.Products', 'U') IS NOT NULL 	
DROP TABLE silver_layer.Products;

CREATE TABLE silver_layer.Products (
	ProductID INT,
	Products NVARCHAR(50),
	Category NVARCHAR(50),
	Price INT
	);
GO
