DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id;

EXEC sp_executesql @sql;

DECLARE @sql2 NVARCHAR(MAX) = N'';

SELECT @sql2 += 'DROP INDEX [' + i.name + '] ON [' + s.name + '].[' + t.name + '];' + CHAR(13)
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.is_primary_key = 0 AND i.is_unique_constraint = 0 AND i.name IS NOT NULL;

EXEC sp_executesql @sql2;


INSERT INTO Sales.SalesOrderHeader([RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate]
)

SELECT [RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

-- Insert into SalesOrderDetail
  INSERT INTO Sales.SalesOrderDetail
      (
      [SalesOrderID]
      ,[CarrierTrackingNumber]
      ,[OrderQty]
      ,[ProductID]
      ,[SpecialOfferID]
      ,[UnitPrice]
      ,[UnitPriceDiscount]
      ,[rowguid]
      ,[ModifiedDate]
      )
SELECT [SalesOrderID]
      , [CarrierTrackingNumber]
      , [OrderQty]
      , [ProductID]
      , [SpecialOfferID]
      , [UnitPrice]
      , [UnitPriceDiscount]
      , [rowguid]
      , [ModifiedDate]
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail]
WHERE SalesOrderID IN(
	SELECT DISTINCT SalesOrderID
	FROM [Sales].[SalesOrderHeader]
	)

SET identity_insert [Production].[Product] ON
-- Insert into product
INSERT INTO [Production].[Product]
           ([ProductID]
		   ,[Name]
           ,[ProductNumber]
           ,[MakeFlag]
           ,[FinishedGoodsFlag]
           ,[Color]
           ,[SafetyStockLevel]
           ,[ReorderPoint]
           ,[StandardCost]
           ,[ListPrice]
           ,[Size]
           ,[SizeUnitMeasureCode]
           ,[WeightUnitMeasureCode]
           ,[Weight]
           ,[DaysToManufacture]
           ,[ProductLine]
           ,[Class]
           ,[Style]
           ,[ProductSubcategoryID]
           ,[ProductModelID]
           ,[SellStartDate]
           ,[SellEndDate]
           ,[DiscontinuedDate]
           ,[rowguid]
           ,[ModifiedDate])
SELECT [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]
  FROM AdventureWorks2019.[Production].[Product]
  WHERE ProductID IN (
	SELECT DISTINCT ProductID
	FROM [Sales].[SalesOrderHeader]
)

SET identity_insert [Production].[Product] OFF


-- Insert categories
SET identity_insert [Production].[ProductCategory] ON

INSERT INTO [Production].[ProductCategory]
           ([ProductCategoryID]
		   ,[Name]
           ,[rowguid]
           ,[ModifiedDate])
SELECT [ProductCategoryID]
      ,[Name]
      ,[rowguid]
      ,[ModifiedDate]
  FROM AdventureWorks2019.[Production].[ProductCategory]
WHERE ProductCategoryID IN (
	SELECT DISTINCT ProductCategoryID
	FROM [Production].[Product]
)

SET identity_insert [Production].[ProductCategory] OFF

-- Insert into employees

INSERT INTO [HumanResources].[Employee]
           ([BusinessEntityID]
           ,[NationalIDNumber]
           ,[LoginID]
           ,[OrganizationNode]
           ,[JobTitle]
           ,[BirthDate]
           ,[MaritalStatus]
           ,[Gender]
           ,[HireDate]
           ,[SalariedFlag]
           ,[VacationHours]
           ,[SickLeaveHours]
           ,[CurrentFlag]
           ,[rowguid]
           ,[ModifiedDate])
SELECT [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
  FROM AdventureWorks2019.[HumanResources].[Employee]
WHERE BusinessEntityID IN (
	SELECT DISTINCT SalesPersonID
	FROM [Sales].[SalesOrderHeader]
)

-- Insert employees 2.0

INSERT INTO [Sales].[SalesPerson]
           ([BusinessEntityID]
           ,[TerritoryID]
           ,[SalesQuota]
           ,[Bonus]
           ,[CommissionPct]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[rowguid]
           ,[ModifiedDate])
SELECT [BusinessEntityID]
      ,[TerritoryID]
      ,[SalesQuota]
      ,[Bonus]
      ,[CommissionPct]
      ,[SalesYTD]
      ,[SalesLastYear]
      ,[rowguid]
      ,[ModifiedDate]
  FROM AdventureWorks2019.[Sales].[SalesPerson]
  WHERE BusinessEntityID IN (
	SELECT DISTINCT BusinessEntityID
	FROM Sales.SalesOrderHeader
  )
 


-- Insert into customers
  SET identity_insert [Sales].[Customer] ON

INSERT INTO [Sales].[Customer]
           ([CustomerID]
		   ,[PersonID]
           ,[StoreID]
           ,[TerritoryID]
           ,[rowguid]
           ,[ModifiedDate])
SELECT [CustomerID]
      ,[PersonID]
      ,[StoreID]
      ,[TerritoryID]
      ,[rowguid]
      ,[ModifiedDate]
  FROM AdventureWorks2019.[Sales].[Customer]
  WHERE CustomerID IN (
	SELECT DISTINCT CustomerID
	FROM [Sales].[SalesOrderHeader]
  )

  SET identity_insert [Sales].[Customer] OFF

USE AdventureWorksDWH
GO

CREATE SCHEMA ETL
GO

CREATE TABLE ETL.[LogUpdate](
	[Table] [nvarchar](50) NULL,
    [LastUpdate] INT NULL,
) on [PRIMARY]
GO

INSERT INTO ETL.[LogUpdate] ([Table], [LastUpdate]) VALUES ('DimProduct', 19980506)
GO
INSERT INTO ETL.[LogUpdate] ([Table], [LastUpdate]) VALUES ('DimCustomer', 19980506)
GO
INSERT INTO ETL.[LogUpdate] ([Table], [LastUpdate]) VALUES ('DimEmployee', 19980506)
GO
INSERT INTO ETL.[LogUpdate] ([Table], [LastUpdate]) VALUES ('FactSale', 19980506)
GO

ALTER TABLE EDW.DimProduct DROP COLUMN ValidFrom, ValodTo;

ALTER TABLE EDW.[DimProduct] ADD ValidFrom INT, ValidTo INT
GO

ALTER TABLE EDW.[DimCustomer] ADD ValidFrom INT, ValidTo INT
GO

ALTER TABLE EDW.[DimEmployee] ADD ValidFrom INT, ValidTo INT
GO


UPDATE EDW.[DimProduct] SET ValidFrom = 20100430, ValidTo = 20991231
GO
UPDATE EDW.[DimCustomer] SET ValidFrom = 20100430, ValidTo = 20991231
GO
UPDATE EDW.[DimEmployee] SET ValidFrom = 20100430, ValidTo = 20991231
GO


SELECT MIN(ModifiedDate)
FROM AdventureWorks2019.Sales.Customer
GO

DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(@LastLoadDate)
		FROM ETL.LogUpdate
		WHERE [Table] = 'DimCustomer'
	)

DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)

DECLARE @FutureDate INT
    SET @FutureDate = 20991231

INSERT INTO EDW.DimCustomer
           (
                CustomerId,
                CustomerName,
                ValidFrom,
                ValidTo
           )

SELECT CustomerId,
       CustomerName,
       @NewLoadDate,
       @FutureDate

FROM STAGE.DimCustomer
    WHERE CustomerId IN (
        SELECT CustomerId FROM STAGE.DimCustomer EXCEPT 
        SELECT CustomerId FROM EDW.DimCustomer 
        WHERE ValidTo = 20991231
    )
GO

DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(@LastLoadDate)
		FROM ETL.LogUpdate
		WHERE [Table] = 'DimEmployee'
	)

DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)

DECLARE @FutureDate INT
    SET @FutureDate = 20991231

INSERT INTO EDW.DimEmployee
           (
              EmployeeId,
			  EmployeeName,
			  City,
			  Country,
			  Title,
			  ValidFrom,
			  ValidTo
           )

SELECT	EmployeeId,
		EmployeeName,
		City,
		Country,
		Title,
		@NewLoadDate,
		@FutureDate

FROM STAGE.DimEmployee
    WHERE EmployeeId IN (
        SELECT EmployeeId FROM STAGE.DimEmployee EXCEPT 
        SELECT EmployeeId FROM EDW.DimEmployee
        WHERE ValidTo = 20991231
    )
GO


DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(@LastLoadDate)
		FROM ETL.LogUpdate
		WHERE [Table] = 'DimProduct'
	)

DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)

DECLARE @FutureDate INT
    SET @FutureDate = 20991231

INSERT INTO EDW.DimProduct
           (
              ProductId,
			  ProductName,
			  ProductCategory,
			  Price,
			  ValidFrom,
			  ValidTo
           )

SELECT	ProductId,
			  ProductName,
			  ProductCategory,
			  Price,
		@NewLoadDate,
		@FutureDate

FROM STAGE.DimProduct
    WHERE ProductId IN (
        SELECT ProductId FROM STAGE.DimProduct EXCEPT 
        SELECT ProductId FROM EDW.DimProduct
        WHERE ValidTo = 20991231
    )
GO


--Incremental Load Fact Table
DECLARE @LastLoadDate DATETIME
	SET @LastLoadDate = (SELECT [Date]
		FROM AdventureWorksDWH.EDW.DimDate
		WHERE DateId IN(SELECT MAX(@LastLoadDate) 
		FROM ETL.LogUpdate WHERE [Table] = 'FactSale')
	)
GO

DECLARE @LastLoadDate DATETIME
	SET @LastLoadDate = (SELECT [Date]
		FROM EDW.DimDate
		WHERE DateId = 19980506
	)

DELETE FROM STAGE.FactSale

INSERT INTO STAGE.FactSale
	(
		CustomerId,
		EmployeeId,
		ProductId,
		OrderId,
		Quantity,
		UnitPrice,
		LineTotal,
		OrderDate
	)
SELECT 
	DC.CustomerId,
	ISNULL (DE.EmployeeId, 1) AS EmployeeId,
	DP.ProductId,
	sod.SalesOrderID AS OrderId,
	sod.OrderQty,
	sod.UnitPrice,
	sod.LineTotal,
	soh.OrderDate

FROM AdventureWorks2019.Sales.SalesOrderHeader soh
	LEFT JOIN AdventureWorks2019.Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
	LEFT JOIN AdventureWorksDWH.STAGE.DimCustomer DC ON DC.CustomerId = soh.CustomerID
	LEFT JOIN AdventureWorksDWH.STAGE.DimEmployee DE ON DE.EmployeeId = soh.SalesPersonID
	INNER JOIN AdventureWorksDWH.STAGE.DimProduct DP ON DP.ProductId = sod.ProductID
	WHERE soh.OrderDate > (@LastLoadDate)
GO

INSERT INTO EDW.FactSale
	(
		CustomerId,
		EmployeeId,
		ProductId,
		DateId,
		OrderId,
		Quantity,
		UnitPrice,
		LineTotal,
		OrderDate
	)
	SELECT
	EDWCustomer.CustomerId,
	EDWEmployee.EmployeeId,
	EDWProduct.ProductId,
	EDWDate.DateId,
	StageFactSale.OrderId,
	StageFactSale.Quantity,
	StageFactSale.UnitPrice,
	StageFactSale.LineTotal,
	StageFactSale.OrderDate

	FROM STAGE.FactSale AS StageFactSale

	LEFT JOIN EDW.DimCustomer AS EDWCustomer
	ON EDWCustomer.CustomerId = StageFactSale.CustomerId

	LEFT JOIN EDW.DimEmployee AS EDWEmployee
	ON EDWEmployee.EmployeeId = StageFactSale.EmployeeId

	LEFT JOIN EDW.DimProduct AS EDWProduct
	ON EDWProduct.ProductId = StageFactSale.ProductId

	LEFT JOIN EDW.DimDate AS EDWDate
	ON EDWDate.Date = StageFactSale.OrderDate

	WHERE EDWProduct.ValidTo = 20991231
		AND EDWCustomer.ValidTo = 20991231
		AND EDWEmployee.ValidTo = 20991231
GO

DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(LastUpdate) FROM ETL.LogUpdate WHERE [Table] = 'DimCustomer')
DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate INT
    SET @FutureDate = 20991231

SELECT CustomerId, CustomerName 
INTO #temp 
FROM STAGE.DimCustomer AS S
WHERE NOT EXISTS (
    SELECT 1 
    FROM EDW.DimCustomer AS E
    WHERE S.CustomerId = E.CustomerId
      AND S.CustomerName = E.CustomerName
      AND E.ValidTo = 20991231
)

Drop table if EXISTS #temp

Select * from #temp


INSERT INTO EDW.DimCustomer 
	(
		CustomerId,
		CustomerName,
		ValidTo,
		ValidFrom
	)
	SELECT 
		CustomerId,
		CustomerName,
		@NewLoadDate,
		@FutureDate
	FROM #temp

UPDATE EDW.DimCustomer SET ValidTo = @NewLoadDate-1
	WHERE CustomerId IN (SELECT CustomerId FROM #temp) AND EDW.DimCustomer.ValidFrom < @NewLoadDate
GO

DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(LastUpdate) FROM ETL.LogUpdate WHERE [Table] = 'DimEmployee')
DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate INT
    SET @FutureDate = 20991231

SELECT EmployeeId, EmployeeName, Title, City, Country
	INTO #temp 
	FROM STAGE.DimEmployee S
	WHERE NOT EXISTS (
		SELECT 1 
		FROM EDW.DimEmployee AS E
		WHERE S.EmployeeId = E.EmployeeId
		  AND S.EmployeeName= E.EmployeeName
		  AND S.City = E.City
		  AND S.Country = E.Country
		  ANd S.Title = E.Title 
		  AND E.ValidTo = 20991231
)

INSERT INTO EDW.DimEmployee 
	(
		EmployeeId,
		EmployeeName,
		Title,
		City,
		Country,
		ValidTo,
		ValidFrom
	)
	SELECT 
		EmployeeId,
		EmployeeName,
		Title,
		City,
		Country,
		@NewLoadDate,
		@FutureDate
	FROM #temp

UPDATE EDW.DimEmployee SET ValidTo = @NewLoadDate-1
	WHERE EmployeeId IN (SELECT EmployeeId FROM #temp) AND EDW.DimEmployee.ValidFrom < @NewLoadDate
GO

Drop table if EXISTS #temp

DECLARE @LastLoadDate INT
	SET @LastLoadDate = (SELECT MAX(LastUpdate) FROM ETL.LogUpdate WHERE [Table] = 'DimProduct')
DECLARE @NewLoadDate INT
    SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate INT
    SET @FutureDate = 20991231

SELECT ProductId, ProductName, ProductCategory,Price
	INTO #temp 
	FROM STAGE.DimProduct S
	WHERE NOT EXISTS (
		SELECT 1 
		FROM EDW.DimProduct E
		WHERE S.ProductId = E.ProductId
		  AND S.ProductName= E.ProductName
		  AND S.ProductCategory = E.ProductCategory
		  AND S.Price = E.Price 
		  AND E.ValidTo = 20991231
)

INSERT INTO EDW.DimProduct
	(
		ProductId,
		ProductName,
		ProductCategory,
		Price,
		ValidTo,
		ValidFrom
	)
	SELECT 
		ProductId,
		ProductName,
		ProductCategory,
		Price,
		@NewLoadDate,
		@FutureDate
	FROM #temp

UPDATE EDW.DimProduct SET ValidTo = @NewLoadDate-1
	WHERE ProductId IN (SELECT ProductId FROM #temp) AND EDW.DimProduct.ValidFrom < @NewLoadDate
GO