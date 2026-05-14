/*
====================================================================================
DDL Scripts: Build Gold Layer Views
====================================================================================

Purpose:
This script creates the analytical views for the Gold layer of the data warehouse.

The Gold layer represents the curated business model of the warehouse and contains
the final dimension and fact structures used for reporting, dashboarding, and
advanced analytics.

These views:
	- Transform and standardize Silver layer data
	- Apply business rules and data cleansing
	- Deduplicate and enrich records
	- Integrate multiple datasets into a unified analytical model
	- Support the Star Schema architecture for BI consumption

The resulting datasets are optimized for:
	- Business intelligence reporting
	- Data analysis
	- KPI tracking
	- Decision-making processes

====================================================================================
*/

--==========================
-- Create Gold Layer Schema
--==========================
CREATE SCHEMA Gold;
GO


--=========================================================================
-- Create Customer Dimension Table for the Gold Layer
--=========================================================================
--=========================================================================
 /* Purpose: 
  The dimension stores cleansed and deduplicated customer records enriched
  with surrogate keys for analytical processing and Star Schema modeling.

  Key Features:
      - Generates surrogate keys for dimension tracking
    	- Removes duplicate customer records
    	- Retains the most recent customer information
    	- Standardizes customer attributes for reporting and analytics

Target Table:
	  Gold.customers2_dim
*/
--===========================================================================
DROP TABLE IF EXISTS Gold.customers2_dim; 
GO
SELECT 
	ROW_NUMBER() OVER (ORDER BY CustomerID) AS Customer_sk,
	CustomerID,
	FirstName,
	LastName,
	CONCAT(FirstName,'' , LastName) AS Full_Name,
	Country,
	Score
INTO Gold.customers2_dim

FROM(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY CustomerID) AS rn
	FROM silver_layer.customers	
	)t
	WHERE rn=1;
	GO

--=========================================================================
-- Create Employees Dimension Table for the Gold Layer
--=========================================================================
IF OBJECT_ID ('Gold.Employees_dim' , 'V') IS NOT NULL
  DROP VIEW Gold.Employees_dim;
GO

DROP TABLE IF EXISTS Gold.Employees_dim;
SELECT 
	ROW_NUMBER() OVER (ORDER BY EmployeeID) AS Employee_sk,
	EmployeeID,
	FirstName,
	LastName,
  TRIM(CONCAT(
        FirstName, 
        ' ', 
        NULLIF(TRIM(LastName), 'n/a')        -- Remove 'n/a' and trim spaces
    )) AS Full_name,
	Department,
	BirthDate,
	Gender,
	Salary,
	ManagerID
INTO Gold.Employees_dim

FROM (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY EmployeeID) AS rn

	FROM silver_layer.Employees
	WHERE EmployeeID IS NOT NULL
)t
WHERE rn = 1;

--=========================================================================
-- Create Products Dimension Table for the Gold Layer
--=========================================================================
IF OBJECT_ID('Gold.products2_dim', 'V') IS NOT NULL
    DROP VIEW Gold.products2_dim;

DROP TABLE IF EXISTS Gold.products2_dim;
GO

SELECT
	ROW_NUMBER() OVER (ORDER BY ProductID) AS Product_sk,
	ProductID,
	Products,
	Category,
	Price
INTO Gold.products2_dim
FROM (
	SELECT *,
			ROW_NUMBER() OVER ( PARTITION BY ProductID
								ORDER BY ProductID) AS rn
FROM silver_layer.Products
WHERE ProductID IS NOT NULL
)t
WHERE rn =1;

--==================================================================
-- Create Unified Orders Tabele By Merging Orders and OrdersArchive 
--==================================================================

--- Merging Orders and OrdersArchive into a single Fact_orders
IF OBJECT_ID('Gold.Unified_orders_facts', 'V') IS NOT NULL
    DROP VIEW Gold.Unified_orders_facts;

DROP TABLE IF EXISTS Gold.Unified_orders_facts;
GO

--- Create Unified facts table by merging Orders and OrdersArchive, ensuring no duplicates based on OrderID
SELECT 
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
INTO Gold.Unified_orders_facts
FROM (
	SELECT
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
	FROM silver_layer.Orders

	UNION ALL
	SELECT
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
	FROM silver_layer.OrdersArchive
) AS Unified_orders
WHERE OrderID IS NOT NULL;
GO

-- ==============================================
-- Create Final Fact Table with Surrogate Keys
-- ==============================================
IF OBJECT_ID('Gold.Fact_orders', 'V') IS NOT NULL
	DROP VIEW Gold.Fact_orders;
DROP TABLE IF EXISTS Gold.Fact_orders;
GO

-- Now create the Fact table
WITH Deduplicated_orders AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY OrderID
								ORDER BY OrderDate DESC) AS rn
	FROM Gold.Unified_orders_facts
)
SELECT 
		ROW_NUMBER() OVER (ORDER BY o.OrderID) AS Order_sk,
		o.OrderID,
		c.Customer_sk,
		p.Product_sk,
		e.Employee_sk,
		o.OrderDate,
		o.ShipDate,
		o.OrderStatus,
		o.ShipAddress,
		o.BillAddress,
		o.Quantity,
		o.Sales
INTO Gold.Fact_orders
FROM Deduplicated_orders o
LEFT JOIN Gold.customers2_dim c ON o.CustomerID = c.CustomerID
LEFT JOIN Gold.products2_dim p ON o.ProductID = p.ProductID
LEFT JOIN Gold.Employees_dim e ON o.SalesPersonID = e.EmployeeID
WHERE o.rn = 1;
GO

--=========================================================
-- Checks for Existence of all Tabel Created in Gold Schema
--=========================================================

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN (
	'customers2_dim',
	'Employees_dim',
	'products2_dim',
	'Unified_orders_facts',
	'Fact_orders'
);






