CREATE Schema AdventureWorksDWH_DAI;

Go

-- Create DimCustomer Table
CREATE TABLE
    AdventureWorksDWH_DAI.DimCustomer (
        CustomerId INT,
        CustomerName NVARCHAR (255) NOT NULL,
        CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId)
    );

-- Create DimEmployee Table
CREATE TABLE
    AdventureWorksDWH_DAI.DimEmployee (
        EmployeeId INT,
        EmployeeName NVARCHAR (255) NOT NULL,
        Store NVARCHAR (255),
        Region NVARCHAR (100),
        CONSTRAINT PK_DimEmployee PRIMARY KEY (EmployeeId)
    );

GO
-- Create DimProduct Table
CREATE TABLE
    AdventureWorksDWH_DAI.DimProduct (
        ProductId INT,
        ProductName NVARCHAR (255) NOT NULL,
        ProductCategory NVARCHAR (100),
        Price MONEY,
        CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId)
    );

GO

Drop table AdventureWorksDWH_DAI.DimDate

-- Create DimDate Table
CREATE TABLE AdventureWorksDWH_DAI.DimDate (
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
    AdventureWorksDWH_DAI.FactSale (
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
ALTER TABLE AdventureWorksDWH_DAI.DimCustomer
DROP CONSTRAINT PK_DimCustomer;

ALTER TABLE AdventureWorksDWH_DAI.DimEmployee
DROP CONSTRAINT PK_DimEmployee;

ALTER TABLE AdventureWorksDWH_DAI.DimProduct
DROP CONSTRAINT PK_DimProduct;

ALTER TABLE AdventureWorksDWH_DAI.DimDate
DROP CONSTRAINT PK_DimDate;

GO
-- Adding New Primary Keys
ALTER TABLE AdventureWorksDWH_DAI.DimCustomer ADD CustomerKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE AdventureWorksDWH_DAI.DimEmployee ADD EmployeeKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE AdventureWorksDWH_DAI.DimProduct ADD ProductKey INT IDENTITY (1, 1) PRIMARY KEY;

ALTER TABLE AdventureWorksDWH_DAI.DimDate ADD DateKey INT IDENTITY (1, 1) PRIMARY KEY;

-- Creating Indexes For Queries
CREATE INDEX IX_FactSale_Customer ON AdventureWorksDWH_DAI.FactSale (CustomerId);

CREATE INDEX IX_FactSale_Employee ON AdventureWorksDWH_DAI.FactSale (EmployeeId);

CREATE INDEX IX_FactSale_Product ON AdventureWorksDWH_DAI.FactSale (ProductId);

CREATE INDEX IX_FactSale_Date ON AdventureWorksDWH_DAI.FactSale (DateId);

CREATE INDEX IX_DimCustomer_Name ON AdventureWorksDWH_DAI.DimCustomer (CustomerName);

CREATE INDEX IX_DimEmployee_Name ON AdventureWorksDWH_DAI.DimEmployee (EmployeeName);

CREATE INDEX IX_DimProduct_Name ON AdventureWorksDWH_DAI.DimProduct (ProductName);


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
    INSERT INTO AdventureWorksDWH_DAI.[DimDate] 
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