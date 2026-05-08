/* 
====================================================================
DDL Script: Create Bronze Tables
====================================================================
Scripts Purpose:
    This script creates table in the 'bronze' schema, dropping existing
    tables if they already exist.
RUN this script to re-define the DDL structure of 'bronze' Tables
====================================================================
*/


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





	
