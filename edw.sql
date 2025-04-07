USE [AdventureWorksDWH]

CREATE SCHEMA EDW;
GO

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
CREATE TABLE EDW.DimDate (
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
    EDW.FactSale (
        SaleKey INT IDENTITY (1, 1),
        CustomerId INT NOT NULL,
        EmployeeId INT NOT NULL,
        ProductId INT NOT NULL,
		OrderId INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice MONEY NOT NULL,
		LineTotal MONEY NOT NULL,
		DateId INT NOT NULL,
        CONSTRAINT PK_FactSale PRIMARY KEY (SaleKey),
        CONSTRAINT FK_FactSale_Customer FOREIGN KEY (CustomerId) REFERENCES EDW.DimCustomer (CustomerId),
        CONSTRAINT FK_FactSale_Employee FOREIGN KEY (EmployeeId) REFERENCES EDW.DimEmployee (EmployeeId),
        CONSTRAINT FK_FactSale_Product FOREIGN KEY (ProductId) REFERENCES EDW.DimProduct (ProductId),
        CONSTRAINT FK_FactSale_Date FOREIGN KEY (DateId) REFERENCES EDW.DimDate (DateId)
        
    );
GO
