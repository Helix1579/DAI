USE [AdventureWorksDWH]
GO

CREATE SCHEMA EDW;
GO

CREATE TABLE
    AdventureWorksDWH.EDW.DimCustomer (
        CustomerId INT,
        CustomerName NVARCHAR (255) NOT NULL,
        CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId)
    );
GO

-- Create DimEmployee Table
CREATE TABLE
    AdventureWorksDWH.EDW.DimEmployee (
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
    AdventureWorksDWH.EDW.DimProduct (
        ProductId INT,
        ProductName NVARCHAR (255) NOT NULL,
        ProductCategory NVARCHAR (100),
        Price MONEY,
        CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId)
    );

GO

-- Create DimDate Table
CREATE TABLE AdventureWorksDWH.EDW.DimDate (
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

CREATE TABLE
    AdventureWorksDWH.EDW.FactSale (
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

-- Create FactSale Table
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
    AdventureWorksDWH.EDW.DimCustomer (
        CustomerId,
        CustomerName
    )
	SELECT
		CustomerId,
		CustomerName
	FROM
		AdventureWorksDWH.STAGE.DimCustomer
GO
        

INSERT INTO 
	AdventureWorksDWH.EDW.DimEmployee (
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
        AdventureWorksDWH.STAGE.DimEmployee;
GO

INSERT INTO
	AdventureWorksDWH.EDW.DimProduct (
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
		AdventureWorksDWH.STAGE.DimProduct
GO

INSERT INTO
    AdventureWorksDWH.EDW.FactSale (
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
		AdventureWorksDWH.STAGE.FactSale as f
		INNER JOIN AdventureWorksDWH.EDW.DimCustomer AS c ON c.CustomerId = f.CustomerID
		INNER JOIN AdventureWorksDWH.EDW.DimEmployee AS e ON e.EmployeeId = f.EmployeeId
		INNER JOIN AdventureWorksDWH.EDW.DimProduct AS p ON p.ProductId = f.ProductID
		INNER JOIN AdventureWorksDWH.EDW.DimDate as d ON d.Date = f.OrderDate
GO