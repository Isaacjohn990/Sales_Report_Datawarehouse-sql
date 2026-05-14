/*
===============================================================================
Stored Procedure: Silver.load_silver
===============================================================================
Purpose:
    This stored procedure performs the full ETL load from the Bronze layer 
    into the Silver layer.

    It truncates the existing Silver tables and reloads them with cleaned, 
    transformed, and standardized data from the Bronze schema, applying all 
    necessary business rules and data quality logic.

Parameters:
    None.

Returns:
    None.

Usage:
    EXEC Silver.load_silver;
===============================================================================
*/


-- Transforming and loading data into Silver_Layer Table

-- For Customers table, we will trim the first and last names,
-- replace null values in last name with 'n/a' and replace null values in score with 0.
-- Create Silver schema if it doesn't exist

-- Create Silver schema if it doesn't exist

GO
EXEC silver_layer.load_silver

GO
CREATE OR ALTER PROCEDURE silver_layer.load_silver AS 
BEGIN

--===================================================
-- Cleaning & Standardizing customer table
--===================================================	
TRUNCATE TABLE silver_layer.customers; 

INSERT INTO silver_layer.customers (
CustomerID,
FirstName,
LastName,
Country,
Score 
)

SELECT 
CustomerID,
TRIM(FirstName),
CASE 
  WHEN LastName IS NULL OR TRIM(LastName) = '' THEN 'n/a'
  ELSE TRIM(LastName)
END AS LastName,
Country,
CASE WHEN Score IS NULL THEN 0
	 ELSE Score
END AS Score
FROM  bronze_layer.customers;

SELECT * FROM silver_layer.customers

--===================================================
-- Cleaning & Standardizing  Employees Table
--===================================================
TRUNCATE TABLE silver_layer.Employees;

INSERT INTO silver_layer.Employees (
EmployeeID,
FirstName,
LastName,
Department,
BirthDate,
Gender,
Salary,
ManagerID
)

SELECT 
EmployeeID,
TRIM(FirstName) ,
CASE 
	WHEN LastName IS NULL OR TRIM(LastName) = '' THEN 'n/a'
	ELSE TRIM(LastName)
END AS LastName,
TRIM(Department),
BirthDate,
CASE WHEN TRIM(Gender) IN ('F', 'FEMALE') THEN 'FEMALE'
	 WHEN TRIM(Gender) IN ('M', 'MALE') THEN 'MALE'
	 ELSE 'n/a'
END AS Updated_gender,
(Salary),
CASE 
    WHEN ManagerID IS NULL THEN 0  -- or -1, or keep NULL
    ELSE ManagerID
END AS ManagerID
FROM bronze_layer.Employees

--===================================================	
--- Cleaning & Standardizing Employees Table
--===================================================
TRUNCATE TABLE silver_layer.Orders;

INSERT INTO silver_layer.Orders ( 
OrderID,
ProductID,
CustomerID,
SalesPersonID,
OrderDate,
ShipDate,
OrderStatus,
ShipAddress,
BillAddress,
Quantity,
Sales 
)

SELECT
OrderID,
ProductID,
CustomerID,
SalesPersonID,
OrderDate,
ShipDate,
OrderStatus, 
CASE WHEN TRIM(ShipAddress) IS NULL OR TRIM(ShipAddress) = '' THEN 'MISSING_SHIP_ADDRESS'
	 ELSE TRIM(ShipAddress)
END AS Updated_ShipAddress,
CASE WHEN TRIM(BillAddress) IS NULL OR TRIM(BillAddress) = ''THEN 'MISSING_BILL_ADDRESS'
	 ELSE TRIM(BillAddress)
END AS Updated_BillAddress,
Quantity,
Sales
FROM bronze_layer.Orders
	
--===================================================
-- Cleaning & Standardizing OrdersArchive Table
--===================================================
TRUNCATE TABLE silver_layer.OrderArchive;

INSERT INTO silver_layer.OrdersArchive(
OrderID,
ProductID,
CustomerID,
SalesPersonID,
OrderDate,
ShipDate,
OrderStatus,
ShipAddress,
BillAddress,
Quantity,
Sales
)

SELECT 
OrderID,
ProductID,
CustomerID,
SalesPersonID,
OrderDate,
ShipDate,
OrderStatus,
ShipAddress,
CASE WHEN TRIM(BillAddress) IS NULL OR TRIM(BillAddress) = ''THEN 'MISSING_BILL_ADDRESS'
	 ELSE TRIM(BillAddress)
END AS BillAddress,
Quantity,
Sales
FROM bronze_layer.OrdersArchive

--===========================================
--- Cleaning & Standardizing Products Table
--===========================================
TRUNCATE TABLE silver_layer.Products;

INSERT INTO silver_layer.Products(
ProductID,
Products,
Category,
Price
)
SELECT
ProductID,
Products,
Category,
Price
FROM bronze_layer.Products

END



