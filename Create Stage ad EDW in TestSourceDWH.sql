CREATE DATABASE TestSourceDWH
GO

USE TestSourceDWH
GO

CREATE SCHEMA STAGE;
GO

-- Create DimCustomer Table
CREATE TABLE
    STAGE.DimCustomer (
        CustomerId INT,
        CustomerName NVARCHAR (255) NOT NULL,
        CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId)
    );
GO

-- Create DimEmployee Table
CREATE TABLE
    STAGE.DimEmployee (
        EmployeeId INT,
        EmployeeName NVARCHAR (255) NOT NULL,
		Title VARCHAR(255),
        City VARCHAR (255),
		Country VARCHAR (255),
        CONSTRAINT PK_DimEmployee PRIMARY KEY (EmployeeId)
    );
GO

-- Create DimProduct Table
CREATE TABLE
    STAGE.DimProduct (
        ProductId INT,
        ProductName NVARCHAR (255) NOT NULL,
        ProductCategory NVARCHAR (100),
        Price MONEY,
        CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId)
    );
GO

-- Create DimDate Table
CREATE TABLE STAGE.DimDate (
    DateId INT NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    MonthName NVARCHAR(9) NOT NULL,
    Week INT NOT NULL,
    Quarter INT NOT NULL,
    DayOfWeek INT NOT NULL,
    WeekdayName NVARCHAR(9) NOT NULL,
    CONSTRAINT PK_DimDate PRIMARY KEY (DateId)
);
GO

-- Create FactSale Table
CREATE TABLE
    STAGE.FactSale (
        SaleKey INT IDENTITY (1, 1),
        CustomerId INT,
        EmployeeId INT,
        ProductId INT,
		OrderId INT,
		DateId DATE,
        Quantity INT NOT NULL,
        UnitPrice MONEY NOT NULL,
		LineTotal MONEY NOT NULL,
		OrderDate DATE NOT NUll,
        CONSTRAINT PK_FactSale PRIMARY KEY (SaleKey)
    );
GO

-- Remove Previous Primary Keys to add new ones
ALTER TABLE STAGE.DimCustomer
DROP CONSTRAINT PK_DimCustomer;

ALTER TABLE STAGE.DimEmployee
DROP CONSTRAINT PK_DimEmployee;

ALTER TABLE STAGE.DimProduct
DROP CONSTRAINT PK_DimProduct;

ALTER TABLE STAGE.DimDate
DROP CONSTRAINT PK_DimDate;

GO
-- Adding New Primary Keys
ALTER TABLE STAGE.DimCustomer ADD CustomerKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE STAGE.DimEmployee ADD EmployeeKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE STAGE.DimProduct ADD ProductKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE STAGE.DimDate ADD DateKey INT IDENTITY (1, 1) PRIMARY KEY;

-- Creating Indexes For Queries
CREATE INDEX IX_FactSale_Customer ON STAGE.FactSale (CustomerId);

CREATE INDEX IX_FactSale_Employee ON STAGE.FactSale (EmployeeId);

CREATE INDEX IX_FactSale_Product ON STAGE.FactSale (ProductId);

CREATE INDEX IX_FactSale_Date ON STAGE.FactSale (DateId);

CREATE INDEX IX_DimCustomer_Name ON STAGE.DimCustomer (CustomerName);

CREATE INDEX IX_DimEmployee_Name ON STAGE.DimEmployee (EmployeeName);

CREATE INDEX IX_DimProduct_Name ON STAGE.DimProduct (ProductName);


--Adding Date Data
DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

-- Set the start and end date range
SET @StartDate = '1996-01-01';
SET @EndDate = DATEADD(YEAR, 100, GETDATE());  -- Set end date to 100 years from today

-- Loop to insert data into DimDate table for every date in the range
WHILE @StartDate <= @EndDate
BEGIN
    -- Insert the date and its associated values into DimDate
    INSERT INTO STAGE.[DimDate] 
        ([DateId], 
         [Day], 
         [Month], 
         [MonthName], 
         [Week], 
         [Quarter], 
         [Year], 
         [DayOfWeek], 
         [WeekdayName])
    SELECT 
        CONVERT(INT, CONVERT(CHAR(8), @StartDate, 112)) AS DateId,  -- DateId as INT (YYYYMMDD)
        DATEPART(DAY, @StartDate) AS Day,  -- Day part of the date
        DATEPART(MONTH, @StartDate) AS Month,  -- Month part of the date
        DATENAME(MONTH, @StartDate) AS MonthName,  -- Month name (e.g., 'January')
        DATEPART(WEEK, @StartDate) AS Week,  -- Week number in the year
        DATEPART(QUARTER, @StartDate) AS Quarter,  -- Quarter of the year (1-4)
        DATEPART(YEAR, @StartDate) AS Year,  -- Year part of the date
        DATEPART(WEEKDAY, @StartDate) AS DayOfWeek,  -- Day of the week (1-7)
        DATENAME(WEEKDAY, @StartDate) AS WeekdayName;  -- Weekday name (e.g., 'Monday')

    -- Increment the date by 1 day
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END
GO



--INSERTING DATA INTO STAGING
-- Loading DimCustomer
INSERT INTO STAGE.DimCustomer (CustomerId, CustomerName)
SELECT C.CustomerId, CASE
		WHEN p.MiddleName Is NOT NULL THEN p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName
		ELSE p.FirstName + ' ' + p.LastName
	END
FROM
	TestSourceDB.Sales.Customer c
	INNER JOIN TestSourceDB.Person.Person p ON p.BusinessEntityID = c.PersonID;
GO


--Loading DimProduct
INSERT INTO
	STAGE.DimProduct (
		ProductId,
		ProductName,
		ProductCategory,
		Price
	)
SELECT
	p.ProductID,
	p.Name AS ProductName,
	pc.Name AS ProductCategory,
	p.ListPrice AS UnitPrice
FROM
	TestSourceDB.Production.Product p
	INNER JOIN TestSourceDB.Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
	INNER JOIN TestSourceDB.Production.ProductCategory pc ON sc.ProductCategoryID = pc.ProductCategoryID;
GO

--Loading DimEmployee
INSERT INTO 
	STAGE.DimEmployee (
		EmployeeId,
		EmployeeName,
		Title,
		City,
		Country
	)
SELECT 
    hrEmployeeTable.BusinessEntityID AS EmployeeId, 
    CONCAT(personTable.FirstName, ' ', personTable.LastName) AS EmployeeName,
	hrEmployeeTable.JobTitle AS Title,
	personAddressTable.City AS City,
	countryRegionTable.Name
FROM 
	AdventureWorks2019.HumanResources.Employee hrEmployeeTable
	INNER JOIN AdventureWorks2019.Person.Person personTable ON 
        personTable.BusinessEntityID = hrEmployeeTable.BusinessEntityID
	INNER JOIN AdventureWorks2019.Person.BusinessEntityAddress businessEntityAddressTable ON 
        hrEmployeeTable.BusinessEntityID = businessEntityAddressTable.BusinessEntityID
	INNER JOIN AdventureWorks2019.Person.Address personAddressTable ON 
        personAddressTable.AddressID = businessEntityAddressTable.AddressID
	INNER JOIN AdventureWorks2019.Person.StateProvince stateProvinceTable ON 
        personAddressTable.StateProvinceID = stateProvinceTable.StateProvinceID
	INNER JOIN AdventureWorks2019.Person.CountryRegion countryRegionTable ON 
        countryRegionTable.CountryRegionCode = stateProvinceTable.CountryRegionCode
	WHERE personTable.PersonType LIKE 'EM' OR personTable.PersonType LIKE 'SP'
GO

-- Loading Facts Table
INSERT INTO
	STAGE.FactSale(
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
	c.CustomerId AS CustomerId,
	e.EmployeeId AS EmployeeId,
	p.ProductId AS ProductId,
	sod.SalesOrderID AS OrderId,
	sod.OrderQty AS Quantity,
	sod.UnitPrice AS UnitPrice,
	sod.LineTotal AS LineTotal,
	soh.OrderDate AS OrderDate
FROM 
	TestSourceDB.Sales.SalesOrderHeader soh
	LEFT JOIN TestSourceDB.Sales.SalesOrderDetail  sod ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN STAGE.DimCustomer AS c ON c.CustomerId = soh.CustomerID
	INNER JOIN STAGE.DimEmployee AS e ON e.EmployeeId = soh.SalesPersonID
	INNER JOIN STAGE.DimProduct AS p ON p.ProductId = sod.ProductID
GO

/* EDW */

USE TestSourceDWH;

CREATE SCHEMA EDW;
GO

-- Create DimCustomer Table
CREATE TABLE
    EDW.DimCustomer (
        CustomerId INT,
        CustomerName NVARCHAR (255) NOT NULL,
        CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId)
    );
GO

-- Create DimEmployee Table
CREATE TABLE
    EDW.DimEmployee (
        EmployeeId INT,
        EmployeeName NVARCHAR (255) NOT NULL,
		Title VARCHAR(255),
        City VARCHAR (255),
		Country VARCHAR (255),
        CONSTRAINT PK_DimEmployee PRIMARY KEY (EmployeeId)
    );
GO

-- Create DimProduct Table
CREATE TABLE
    EDW.DimProduct (
        ProductId INT,
        ProductName NVARCHAR (255) NOT NULL,
        ProductCategory NVARCHAR (100),
        Price MONEY,
        CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId)
    );
GO

-- Create DimDate Table
CREATE TABLE 
    EDW.DimDate (
        DateId INT NOT NULL,
        Date DATETIME NOT NULL,
        Day INT NOT NULL,
        Month INT NOT NULL,
        Year INT NOT NULL,
        MonthName NVARCHAR(9) NOT NULL,
        Week INT NOT NULL,
        Quarter INT NOT NULL,
        DayOfWeek INT NOT NULL,
        WeekdayName NVARCHAR(9) NOT NULL,
        CONSTRAINT PK_DimDate PRIMARY KEY (DateId)
);
GO

-- Create FactSale Table
CREATE TABLE
    EDW.FactSale (
        SaleKey INT IDENTITY (1, 1) PRIMARY KEY,
        CustomerId INT,
        EmployeeId INT,
        ProductId INT,
        OrderId INT,
        DateId INT,
        Quantity INT,
        UnitPrice MONEY,
        LineTotal MONEY,
        OrderDate DATETIME
    );
GO

--Adding Date Data
DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

-- Set the start and end date range
SET @StartDate = '1996-01-01';
SET @EndDate = DATEADD(YEAR, 100, GETDATE());  -- Set end date to 100 years from today

-- Loop to insert data into DimDate table for every date in the range
WHILE @StartDate <= @EndDate
BEGIN
    -- Insert the date and its associated values into DimDate
    INSERT INTO EDW.[DimDate] 
        ([DateId],
         [Date],
         [Day], 
         [Month], 
         [MonthName], 
         [Week], 
         [Quarter], 
         [Year], 
         [DayOfWeek], 
         [WeekdayName])
    SELECT 
        CONVERT(INT, CONVERT(CHAR(8), @StartDate, 112)) AS DateId,  -- DateId as INT (YYYYMMDD)
        @StartDate AS Date,  -- Full date
        DATEPART(DAY, @StartDate) AS Day,  -- Day part of the date
        DATEPART(MONTH, @StartDate) AS Month,  -- Month part of the date
        DATENAME(MONTH, @StartDate) AS MonthName,  -- Month name (e.g., 'January')
        DATEPART(WEEK, @StartDate) AS Week,  -- Week number in the year
        DATEPART(QUARTER, @StartDate) AS Quarter,  -- Quarter of the year (1-4)
        DATEPART(YEAR, @StartDate) AS Year,  -- Year part of the date
        DATEPART(WEEKDAY, @StartDate) AS DayOfWeek,  -- Day of the week (1-7)
        DATENAME(WEEKDAY, @StartDate) AS WeekdayName;  -- Weekday name (e.g., 'Monday')

    -- Increment the date by 1 day
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END
GO


-- Insert Data into DimCustomer Table
INSERT INTO 
    EDW.DimCustomer (
        CustomerId,
        CustomerName
    )
	SELECT
		CustomerId,
		CustomerName
	FROM
		STAGE.DimCustomer
GO

        
-- Insert Data into DimEmployee Table
INSERT INTO 
	EDW.DimEmployee (
		EmployeeId,
		EmployeeName,
		Title,
		City,
		Country
	)
	SELECT
        EmployeeId,
        EmployeeName,
        Title,
        City,
        Country
    FROM 
        STAGE.DimEmployee;
GO

--Insert Data into DimProduct Table
INSERT INTO
	EDW.DimProduct (
		ProductId,
		ProductName,
		ProductCategory,
		Price
	)
	SELECT
		ProductId,
		ProductName,
		ProductCategory,
		Price
	FROM
		STAGE.DimProduct
GO

--Insert Data into FactSale Table
INSERT INTO
    EDW.FactSale (
        CustomerId,
        EmployeeId,
        ProductId,
		OrderId,
		DateId,
        Quantity,
        UnitPrice,
		LineTotal,
		OrderDate
	)
	SELECT
		c.CustomerId,
		e.EmployeeId,
		p.ProductId,
		d.DateId,
		f.OrderId,
		f.Quantity,
		f.UnitPrice,
		f.LineTotal,
		f.OrderDate
	FROM
		STAGE.FactSale as f
		INNER JOIN EDW.DimCustomer AS c ON c.CustomerId = f.CustomerID
		INNER JOIN EDW.DimEmployee AS e ON e.EmployeeId = f.EmployeeId
		INNER JOIN EDW.DimProduct AS p ON p.ProductId = f.ProductID
		INNER JOIN EDW.DimDate as d ON d.Date = f.OrderDate
GO

SELECT COUNT(*)
FROM TestSourceDB.Sales.SalesOrderDetail sod;

SELECT COUNT(*)
FROM AdventureWorks2019.Sales.SalesOrderDetail sod;

SELECT COUNT(*)
FROM TestSourceDB.Sales.SalesOrderHeader soh;

SELECT COUNT(*)
FROM AdventureWorks2019.Sales.SalesOrderHeader soh;