/* 
====================================================================
PROC_LOAD Script: Create Stored Procedure to load data into Bronze layer
====================================================================
Scripts Purpose:
    This script creates Stored Procedures to load data into the Bronze Tables schema, 
    dropping existing tables if they already exist.
====================================================================
*/


GO
EXEC Bronze_layer.load_Bronze

CREATE OR ALTER PROCEDURE Bronze_layer.load_Bronze
AS
BEGIN

--- Creating Stored Procedure to load data into Bronze_Layer Table
PRINT '================================================';
PRINT 'Loading data into the Bronze layer...';
PRINT '================================================';

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
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
SELECT COUNT (*) FROM bronze_layer.Products;

END
