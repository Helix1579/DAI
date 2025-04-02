USE [AdventureWorksDWH]

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
        Store NVARCHAR (255),
        Region NVARCHAR (100),
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
        DateId INT,
        Quantity INT NOT NULL,
        Price MONEY NOT NULL,
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
INSERT INTO [AdventureWorksDWH].STAGE.DimCustomer (CustomerId, CustomerName)
SELECT C.CustomerId,CASE
		WHEN p.MiddleName Is NOT NULL THEN p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName
		ELSE p.FirstName + ' ' + p.LastName
	END
FROM
	[AdventureWorks2019].Sales.Customer c
	INNER JOIN [AdventureWorks2019].Person.Person p ON p.BusinessEntityID = c.PersonID;

GO


--Loading DimProduct
INSERT INTO
	AdventureWorksDWH.STAGE.DimProduct (
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
	AdventureWorks2019.Production.Product p
	INNER JOIN AdventureWorks2019.Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
	INNER JOIN AdventureWorks2019.Production.ProductCategory pc ON sc.ProductCategoryID = pc.ProductCategoryID;
GO

DROP TABLE [AdventureWorksDWH].STAGE.FactSale

--Loading DimEmployee
INSERT INTO AdventureWorksDWH.STAGE.DimEmployee (
    EmployeeId,
    EmployeeName,
    Store,
    Region
)
SELECT 
    p.BusinessEntityID AS EmployeeId, 
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    s.Name AS Store,
    st.Name AS Region
FROM AdventureWorks2019.Person.Person p
LEFT JOIN AdventureWorks2019.Sales.SalesPerson sp ON p.BusinessEntityID = sp.BusinessEntityID
LEFT JOIN AdventureWorks2019.Sales.Store s ON sp.BusinessEntityID = s.SalesPersonID
LEFT JOIN AdventureWorks2019.Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN AdventureWorks2019.Person.StateProvince st ON a.StateProvinceID = st.StateProvinceID;

GO

-- Loading Facts Table

INSERT INTO AdventureWorksDWH.STAGE.FactSale (
    CustomerId,
    EmployeeId,
    ProductId,
    DateId,
    Quantity,
    Price
)
SELECT
    c.CustomerId,
    ISNULL(e.EmployeeId, 0) AS EmployeeId,  -- Handling cases where there's no employee
    p.ProductId,
    d.DateId,
    sod.OrderQty AS Quantity,
    sod.UnitPrice AS Price
FROM AdventureWorks2019.Sales.SalesOrderDetail sod
LEFT JOIN AdventureWorks2019.Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
LEFT JOIN AdventureWorksDWH.STAGE.DimCustomer c ON soh.CustomerID = c.CustomerId
LEFT JOIN AdventureWorksDWH.STAGE.DimEmployee e ON soh.SalesPersonID = e.EmployeeId
LEFT JOIN AdventureWorksDWH.STAGE.DimProduct p ON sod.ProductID = p.ProductId
LEFT JOIN AdventureWorksDWH.STAGE.DimDate d ON d.DateId = 
    YEAR(soh.OrderDate) * 10000 + MONTH(soh.OrderDate) * 100 + DAY(soh.OrderDate);
