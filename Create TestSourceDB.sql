CREATE DATABASE [TestSourceDB] CONTAINMENT = NONE WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
      ALTER DATABASE [TestSourceDB]
SET
      ANSI_NULL_DEFAULT OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      ANSI_NULLS ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      ANSI_PADDING ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      ANSI_WARNINGS ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      ARITHABORT ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      AUTO_CLOSE OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      AUTO_SHRINK OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      AUTO_UPDATE_STATISTICS ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      CURSOR_CLOSE_ON_COMMIT OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      CURSOR_DEFAULT GLOBAL
GO
      ALTER DATABASE [TestSourceDB]
SET
      CONCAT_NULL_YIELDS_NULL ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      NUMERIC_ROUNDABORT OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      QUOTED_IDENTIFIER ON
GO
      ALTER DATABASE [TestSourceDB]
SET
      RECURSIVE_TRIGGERS OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      DISABLE_BROKER
GO
      ALTER DATABASE [TestSourceDB]
SET
      AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      DATE_CORRELATION_OPTIMIZATION OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      TRUSTWORTHY OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      ALLOW_SNAPSHOT_ISOLATION OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      PARAMETERIZATION SIMPLE
GO
      ALTER DATABASE [TestSourceDB]
SET
      READ_COMMITTED_SNAPSHOT OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      HONOR_BROKER_PRIORITY OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      RECOVERY SIMPLE
GO
      ALTER DATABASE [TestSourceDB]
SET
      MULTI_USER
GO
      ALTER DATABASE [TestSourceDB]
SET
      PAGE_VERIFY CHECKSUM
GO
      ALTER DATABASE [TestSourceDB]
SET
      DB_CHAINING OFF
GO
      ALTER DATABASE [TestSourceDB]
SET
      FILESTREAM(NON_TRANSACTED_ACCESS = OFF)
GO
      ALTER DATABASE [TestSourceDB]
SET
      TARGET_RECOVERY_TIME = 60 SECONDS
GO
      ALTER DATABASE [TestSourceDB]
SET
      DELAYED_DURABILITY = DISABLED
GO
      ALTER DATABASE [TestSourceDB]
SET
      ACCELERATED_DATABASE_RECOVERY = OFF
GO
      EXEC sys.sp_db_vardecimal_storage_format N'TestSourceDB', N'ON'
GO
      ALTER DATABASE [TestSourceDB]
SET
      QUERY_STORE = OFF
GO
      USE [TestSourceDB]
GO
      /****** Object:  Schema [HumanResources]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE SCHEMA [HumanResources]
GO
      /****** Object:  Schema [Person]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE SCHEMA [Person]
GO
      /****** Object:  Schema [Production]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE SCHEMA [Production]
GO
      /****** Object:  Schema [Purchasing]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE SCHEMA [Purchasing]
GO
      /****** Object:  Schema [Sales]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE SCHEMA [Sales]
GO
      /****** Object:  UserDefinedDataType [dbo].[AccountNumber]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[AccountNumber]
FROM
      [nvarchar](15) NULL
GO
      /****** Object:  UserDefinedDataType [dbo].[Flag]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[Flag]
FROM
      [bit] NOT NULL
GO
      /****** Object:  UserDefinedDataType [dbo].[Name]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[Name]
FROM
      [nvarchar](50) NULL
GO
      /****** Object:  UserDefinedDataType [dbo].[NameStyle]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[NameStyle]
FROM
      [bit] NOT NULL
GO
      /****** Object:  UserDefinedDataType [dbo].[OrderNumber]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[OrderNumber]
FROM
      [nvarchar](25) NULL
GO
      /****** Object:  UserDefinedDataType [dbo].[Phone]    Script Date: 30-04-2025 14:20:55 ******/
      CREATE TYPE [dbo].[Phone]
FROM
      [nvarchar](25) NULL
GO
      /****** Object:  Table [Person].[Address]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Person].[Address](
            [AddressID] [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
            [AddressLine1] [nvarchar](60) NOT NULL,
            [AddressLine2] [nvarchar](60) NULL,
            [City] [nvarchar](30) NOT NULL,
            [StateProvinceID] [int] NOT NULL,
            [PostalCode] [nvarchar](15) NOT NULL,
            [SpatialLocation] [geography] NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
      /****** Object:  Schema [Sales]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Person].[BusinessEntityAddress](
            [BusinessEntityID] [int] NOT NULL,
            [AddressID] [int] NOT NULL,
            [AddressTypeID] [int] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID] PRIMARY KEY CLUSTERED (
                  [BusinessEntityID] ASC,
                  [AddressID] ASC,
                  [AddressTypeID] ASC
            ) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Schema [Sales]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Person].[CountryRegion](
            [CountryRegionCode] [nvarchar](3) NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_CountryRegion_CountryRegionCode] PRIMARY KEY CLUSTERED ([CountryRegionCode] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Schema [Sales]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Person].[Person](
            [BusinessEntityID] [int] NOT NULL,
            [PersonType] [nchar](2) NOT NULL,
            [NameStyle] [dbo].[NameStyle] NOT NULL,
            [Title] [nvarchar](8) NULL,
            [FirstName] [dbo].[Name] NOT NULL,
            [MiddleName] [dbo].[Name] NULL,
            [LastName] [dbo].[Name] NOT NULL,
            [Suffix] [nvarchar](10) NULL,
            [EmailPromotion] [int] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Person].[StateProvince]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Person].[StateProvince](
            [StateProvinceID] [int] IDENTITY(1, 1) NOT NULL,
            [StateProvinceCode] [nchar](3) NOT NULL,
            [CountryRegionCode] [nvarchar](3) NOT NULL,
            [IsOnlyStateProvinceFlag] [dbo].[Flag] NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [TerritoryID] [int] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_StateProvince_StateProvinceID] PRIMARY KEY CLUSTERED ([StateProvinceID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Production].[Product]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Production].[Product](
            [ProductID] [int] IDENTITY(1, 1) NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [ProductNumber] [nvarchar](25) NOT NULL,
            [MakeFlag] [dbo].[Flag] NOT NULL,
            [FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
            [Color] [nvarchar](15) NULL,
            [SafetyStockLevel] [smallint] NOT NULL,
            [ReorderPoint] [smallint] NOT NULL,
            [StandardCost] [money] NOT NULL,
            [ListPrice] [money] NOT NULL,
            [Size] [nvarchar](5) NULL,
            [SizeUnitMeasureCode] [nchar](3) NULL,
            [WeightUnitMeasureCode] [nchar](3) NULL,
            [Weight] [decimal](8, 2) NULL,
            [DaysToManufacture] [int] NOT NULL,
            [ProductLine] [nchar](2) NULL,
            [Class] [nchar](2) NULL,
            [Style] [nchar](2) NULL,
            [ProductSubcategoryID] [int] NULL,
            [ProductModelID] [int] NULL,
            [SellStartDate] [datetime] NOT NULL,
            [SellEndDate] [datetime] NULL,
            [DiscontinuedDate] [datetime] NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED ([ProductID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Production].[ProductCategory]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Production].[ProductCategory](
            [ProductCategoryID] [int] IDENTITY(1, 1) NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_ProductCategory_ProductCategoryID] PRIMARY KEY CLUSTERED ([ProductCategoryID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Production].[ProductModel]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Production].[ProductModel](
            [ProductModelID] [int] IDENTITY(1, 1) NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED ([ProductModelID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Production].[ProductSubcategory]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Production].[ProductSubcategory](
            [ProductSubcategoryID] [int] IDENTITY(1, 1) NOT NULL,
            [ProductCategoryID] [int] NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID] PRIMARY KEY CLUSTERED ([ProductSubcategoryID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[Customer]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[Customer](
            [CustomerID] [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
            [PersonID] [int] NULL,
            [StoreID] [int] NULL,
            [TerritoryID] [int] NULL,
            [AccountNumber] [nvarchar](256) NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[SalesOrderDetail]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[SalesOrderDetail](
            [SalesOrderID] [int] NOT NULL,
            [SalesOrderDetailID] [int] IDENTITY(1, 1) NOT NULL,
            [CarrierTrackingNumber] [nvarchar](25) NULL,
            [OrderQty] [smallint] NOT NULL,
            [ProductID] [int] NOT NULL,
            [SpecialOfferID] [int] NOT NULL,
            [UnitPrice] [money] NOT NULL,
            [UnitPriceDiscount] [money] NOT NULL,
            [LineTotal] AS (
                  isnull(
                        ([UnitPrice] *((1.0) - [UnitPriceDiscount])) * [OrderQty],
(0.0)
                  )
            ),
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED (
                  [SalesOrderID] ASC,
                  [SalesOrderDetailID] ASC
            ) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[SalesOrderHeader]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[SalesOrderHeader](
            [SalesOrderID] [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
            [RevisionNumber] [tinyint] NOT NULL,
            [OrderDate] [datetime] NOT NULL,
            [DueDate] [datetime] NOT NULL,
            [ShipDate] [datetime] NULL,
            [Status] [tinyint] NOT NULL,
            [OnlineOrderFlag] [dbo].[Flag] NOT NULL,
            [SalesOrderNumber] AS (
                  isnull(
                        N'SO' + CONVERT([nvarchar](23), [SalesOrderID]),
                        N'*** ERROR ***'
                  )
            ),
            [PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
            [AccountNumber] [dbo].[AccountNumber] NULL,
            [CustomerID] [int] NOT NULL,
            [SalesPersonID] [int] NULL,
            [TerritoryID] [int] NULL,
            [BillToAddressID] [int] NOT NULL,
            [ShipToAddressID] [int] NOT NULL,
            [ShipMethodID] [int] NOT NULL,
            [CreditCardID] [int] NULL,
            [CreditCardApprovalCode] [varchar](15) NULL,
            [CurrencyRateID] [int] NULL,
            [SubTotal] [money] NOT NULL,
            [TaxAmt] [money] NOT NULL,
            [Freight] [money] NOT NULL,
            [TotalDue] AS (isnull(([SubTotal] + [TaxAmt]) + [Freight],(0))),
            [Comment] [nvarchar](128) NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED ([SalesOrderID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[SalesPerson]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[SalesPerson](
            [BusinessEntityID] [int] NOT NULL,
            [TerritoryID] [int] NULL,
            [SalesQuota] [money] NULL,
            [Bonus] [money] NOT NULL,
            [CommissionPct] [smallmoney] NOT NULL,
            [SalesYTD] [money] NOT NULL,
            [SalesLastYear] [money] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_SalesPerson_BusinessEntityID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[SalesTerritory]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[SalesTerritory](
            [TerritoryID] [int] IDENTITY(1, 1) NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [CountryRegionCode] [nvarchar](3) NOT NULL,
            [Group] [nvarchar](50) NOT NULL,
            [SalesYTD] [money] NOT NULL,
            [SalesLastYear] [money] NOT NULL,
            [CostYTD] [money] NOT NULL,
            [CostLastYear] [money] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED ([TerritoryID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      /****** Object:  Table [Sales].[Store]    Script Date: 30-04-2025 14:20:55 ******/
SET
      ANSI_NULLS ON
GO
SET
      QUOTED_IDENTIFIER ON
GO
      CREATE TABLE [Sales].[Store](
            [BusinessEntityID] [int] NOT NULL,
            [Name] [dbo].[Name] NOT NULL,
            [SalesPersonID] [int] NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Store_BusinessEntityID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      CREATE TABLE [HumanResources].[Employee](
            [BusinessEntityID] [int] NOT NULL,
            [NationalIDNumber] [nvarchar](15) NOT NULL,
            [LoginID] [nvarchar](256) NOT NULL,
            [OrganizationNode] [hierarchyid] NULL,
            [OrganizationLevel] AS ([OrganizationNode].[GetLevel]()),
            [JobTitle] [nvarchar](50) NOT NULL,
            [BirthDate] [date] NOT NULL,
            [MaritalStatus] [nchar](1) NOT NULL,
            [Gender] [nchar](1) NOT NULL,
            [HireDate] [date] NOT NULL,
            [SalariedFlag] [dbo].[Flag] NOT NULL,
            [VacationHours] [smallint] NOT NULL,
            [SickLeaveHours] [smallint] NOT NULL,
            [CurrentFlag] [dbo].[Flag] NOT NULL,
            [rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            CONSTRAINT [PK_Employee_BusinessEntityID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC) WITH (
                  PAD_INDEX = OFF,
                  STATISTICS_NORECOMPUTE = OFF,
                  IGNORE_DUP_KEY = OFF,
                  ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON,
                  OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON [PRIMARY]
      ) ON [PRIMARY]
GO
      ALTER DATABASE [TestSourceDB]
SET
      READ_WRITE
GO
      /* Insert Data into TestSourceDB */
      USE [TestSourceDB];

INSERT INTO
      Sales.SalesOrderHeader(
            [RevisionNumber],
            [OrderDate],
            [DueDate],
            [ShipDate],
            [Status],
            [OnlineOrderFlag],
            [PurchaseOrderNumber],
            [AccountNumber],
            [CustomerID],
            [SalesPersonID],
            [TerritoryID],
            [BillToAddressID],
            [ShipToAddressID],
            [ShipMethodID],
            [CreditCardID],
            [CreditCardApprovalCode],
            [CurrencyRateID],
            [SubTotal],
            [TaxAmt],
            [Freight],
            [Comment],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [RevisionNumber],
      [OrderDate],
      [DueDate],
      [ShipDate],
      [Status],
      [OnlineOrderFlag],
      [PurchaseOrderNumber],
      [AccountNumber],
      [CustomerID],
      [SalesPersonID],
      [TerritoryID],
      [BillToAddressID],
      [ShipToAddressID],
      [ShipMethodID],
      [CreditCardID],
      [CreditCardApprovalCode],
      [CurrencyRateID],
      [SubTotal],
      [TaxAmt],
      [Freight],
      [Comment],
      [rowguid],
      [ModifiedDate]
FROM
      [AdventureWorks2019].[Sales].[SalesOrderHeader]
GO


INSERT INTO [Sales].[SalesOrderDetail]
           ([SalesOrderID]
           ,[CarrierTrackingNumber]
           ,[OrderQty]
           ,[ProductID]
           ,[SpecialOfferID]
           ,[UnitPrice]
           ,[UnitPriceDiscount]
           ,[rowguid]
           ,[ModifiedDate])
           
     SELECT
           [SalesOrderID]
           ,[CarrierTrackingNumber]
           ,[OrderQty]
           ,[ProductID]
           ,[SpecialOfferID]
           ,[UnitPrice]
           ,[UnitPriceDiscount]
           ,[rowguid]
           ,[ModifiedDate]
  FROM AdventureWorks2019.[Sales].[SalesOrderDetail]
  WHERE [SalesOrderID] IN (SELECT [SalesOrderID] FROM TestSourceDB.[Sales].[SalesOrderHeader] )
GO

SET
      identity_insert [Production].[Product] ON
INSERT INTO
      [Production].[Product] (
            [ProductID],
            [Name],
            [ProductNumber],
            [MakeFlag],
            [FinishedGoodsFlag],
            [Color],
            [SafetyStockLevel],
            [ReorderPoint],
            [StandardCost],
            [ListPrice],
            [Size],
            [SizeUnitMeasureCode],
            [WeightUnitMeasureCode],
            [Weight],
            [DaysToManufacture],
            [ProductLine],
            [Class],
            [Style],
            [ProductSubcategoryID],
            [ProductModelID],
            [SellStartDate],
            [SellEndDate],
            [DiscontinuedDate],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [ProductID],
      [Name],
      [ProductNumber],
      [MakeFlag],
      [FinishedGoodsFlag],
      [Color],
      [SafetyStockLevel],
      [ReorderPoint],
      [StandardCost],
      [ListPrice],
      [Size],
      [SizeUnitMeasureCode],
      [WeightUnitMeasureCode],
      [Weight],
      [DaysToManufacture],
      [ProductLine],
      [Class],
      [Style],
      [ProductSubcategoryID],
      [ProductModelID],
      [SellStartDate],
      [SellEndDate],
      [DiscontinuedDate],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Production].[Product]
WHERE
      ProductID IN (
            SELECT
                  DISTINCT ProductID
            FROM
                  [Sales].[SalesOrderHeader]
      )
SET
      identity_insert [Production].[Product] OFF
GO
SET
      identity_insert [Production].[ProductCategory] ON
INSERT INTO
      [Production].[ProductCategory] (
            [ProductCategoryID],
            [Name],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [ProductCategoryID],
      [Name],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Production].[ProductCategory]
WHERE
      ProductCategoryID IN (
            SELECT
                  DISTINCT ProductCategoryID
            FROM
                  [Production].[Product]
      )
SET
      identity_insert [Production].[ProductCategory] OFF
GO
INSERT INTO
      [HumanResources].[Employee] (
            [BusinessEntityID],
            [NationalIDNumber],
            [LoginID],
            [OrganizationNode],
            [JobTitle],
            [BirthDate],
            [MaritalStatus],
            [Gender],
            [HireDate],
            [SalariedFlag],
            [VacationHours],
            [SickLeaveHours],
            [CurrentFlag],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [BusinessEntityID],
      [NationalIDNumber],
      [LoginID],
      [OrganizationNode],
      [JobTitle],
      [BirthDate],
      [MaritalStatus],
      [Gender],
      [HireDate],
      [SalariedFlag],
      [VacationHours],
      [SickLeaveHours],
      [CurrentFlag],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[HumanResources].[Employee]
WHERE
      BusinessEntityID IN (
            SELECT
                  DISTINCT SalesPersonID
            FROM
                  [Sales].[SalesOrderHeader]
      )
GO
INSERT INTO
      [Sales].[SalesPerson] (
            [BusinessEntityID],
            [TerritoryID],
            [SalesQuota],
            [Bonus],
            [CommissionPct],
            [SalesYTD],
            [SalesLastYear],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [BusinessEntityID],
      [TerritoryID],
      [SalesQuota],
      [Bonus],
      [CommissionPct],
      [SalesYTD],
      [SalesLastYear],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Sales].[SalesPerson]
WHERE
      BusinessEntityID IN (
            SELECT
                  DISTINCT BusinessEntityID
            FROM
                  Sales.SalesOrderHeader
      )
GO
SET
      identity_insert [Sales].[Customer] ON
INSERT INTO
      [Sales].[Customer] (
            [CustomerID],
            [PersonID],
            [StoreID],
            [TerritoryID],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [CustomerID],
      [PersonID],
      [StoreID],
      [TerritoryID],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Sales].[Customer]
WHERE
      CustomerID IN (
            SELECT
                  DISTINCT CustomerID
            FROM
                  [Sales].[SalesOrderHeader]
      )
SET
      identity_insert [Sales].[Customer] OFF
GO
SET
      IDENTITY_INSERT [Person].[Address] ON
-- INSERT INTO
--       [Person].[Address] (
--             [AddressID],
--             [AddressLine1],
--             [AddressLine2],
--             [City],
--             [StateProvinceID],
--             [PostalCode],
--             [SpatialLocation],
--             [rowguid],
--             [ModifiedDate]
--       )
-- SELECT
--       [AddressID],
--       [AddressLine1],
--       [AddressLine2],
--       [City],
--       [StateProvinceID],
--       [PostalCode],
--       [SpatialLocation],
--       [rowguid],
--       [ModifiedDate]
-- FROM
--       AdventureWorks2019.Person.Address
-- WHERE
--       [AddressID] IN (
--             SELECT
--                   [AddressID]
--             FROM
--                   TestSourceDB.[Person].[BusinessEntityAddress]
--       )
-- SET
--       IDENTITY_INSERT [Person].[Address] OFF
-- GO
-- INSERT INTO
--       [Person].[BusinessEntityAddress] (
--             [BusinessEntityID],
--             [AddressID],
--             [AddressTypeID],
--             [rowguid],
--             [ModifiedDate]
--       )
-- SELECT
--       [BusinessEntityID],
--       [AddressID],
--       [AddressTypeID],
--       [rowguid],
--       [ModifiedDate]
-- FROM
--       AdventureWorks2019.[Person].[BusinessEntityAddress]
-- WHERE
--       [AddressID] IN (
--             SELECT
--                   DISTINCT [AddressID]
--             FROM
--                   TestSourceDB.[Person].[Person]
--       )
-- GO
-- INSERT INTO
--       [Person].[CountryRegion] (
--             [CountryRegionCode],
--             [Name],
--             [ModifiedDate]
--       )
-- SELECT
--       [CountryRegionCode],
--       [Name],
--       [ModifiedDate]
-- FROM
--       AdventureWorks2019.[Person].[CountryRegion]
-- WHERE
--       [CountryRegionCode] COLLATE DATABASE_DEFAULT IN (
--             SELECT
--                   DISTINCT [CountryRegionCode]
--             FROM
--                   TestSourceDB.[Person].[StateProvince]
--       )
-- GO
INSERT INTO
      [Person].[Person] (
            [BusinessEntityID],
            [PersonType],
            [NameStyle],
            [Title],
            [FirstName],
            [MiddleName],
            [LastName],
            [Suffix],
            [EmailPromotion],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [BusinessEntityID],
      [PersonType],
      [NameStyle],
      [Title],
      [FirstName],
      [MiddleName],
      [LastName],
      [Suffix],
      [EmailPromotion],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Person].[Person]
WHERE
      [BusinessEntityID] IN (
            SELECT
                  [PersonID]
            FROM
                  TestSourceDB.[Sales].[Customer]
      )
UNION
SELECT
      [BusinessEntityID],
      [PersonType],
      [NameStyle],
      [Title],
      [FirstName],
      [MiddleName],
      [LastName],
      [Suffix],
      [EmailPromotion],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Person].[Person]
WHERE
      [BusinessEntityID] IN (
            SELECT
                  [BusinessEntityID]
            FROM
                  TestSourceDB.[Sales].[SalesPerson]
      )
GO
SET
      IDENTITY_INSERT [Person].[StateProvince] ON
-- INSERT INTO
--       [Person].[StateProvince] (
--             [StateProvinceID],
--             [StateProvinceCode],
--             [CountryRegionCode],
--             [IsOnlyStateProvinceFlag],
--             [Name],
--             [TerritoryID],
--             [rowguid],
--             [ModifiedDate]
--       )
-- SELECT
--       [StateProvinceID],
--       [StateProvinceCode],
--       [CountryRegionCode],
--       [IsOnlyStateProvinceFlag],
--       [Name],
--       [TerritoryID],
--       [rowguid],
--       [ModifiedDate]
-- FROM
--       AdventureWorks2019.[Person].[StateProvince]
-- WHERE
--       [StateProvinceID] IN (
--             SELECT
--                   [StateProvinceID]
--             FROM
--                   TestSourceDB.[Person].[Address]
--       )
-- SET
--       IDENTITY_INSERT [Person].[StateProvince] OFF
-- GO
SET
      IDENTITY_INSERT [Production].[ProductModel] ON
INSERT INTO
      [Production].[ProductModel] (
            [ProductModelID],
            [Name],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [ProductModelID],
      [Name],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Production].[ProductModel]
WHERE
      [ProductModelID] IN (
            SELECT
                  DISTINCT [ProductModelID]
            FROM
                  TestSourceDB.[Production].[Product]
      )
SET
      IDENTITY_INSERT [Production].[ProductModel] OFF
GO
SET
      IDENTITY_INSERT [Production].[ProductSubcategory] ON
INSERT INTO
      [Production].[ProductSubcategory] (
            [ProductSubcategoryID],
            [ProductCategoryID],
            [Name],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [ProductSubcategoryID],
      [ProductCategoryID],
      [Name],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Production].[ProductSubcategory]
WHERE
      [ProductSubcategoryID] IN (
            SELECT
                  DISTINCT [ProductSubcategoryID]
            FROM
                  TestSourceDB.[Production].[Product]
      )
SET
      IDENTITY_INSERT [Production].[ProductSubcategory] OFF
GO
SET
      IDENTITY_INSERT [Sales].[SalesTerritory] ON
INSERT INTO
      [Sales].[SalesTerritory] (
            [TerritoryID],
            [Name],
            [CountryRegionCode],
            [Group],
            [SalesYTD],
            [SalesLastYear],
            [CostYTD],
            [CostLastYear],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [TerritoryID],
      [Name],
      [CountryRegionCode],
      [Group],
      [SalesYTD],
      [SalesLastYear],
      [CostYTD],
      [CostLastYear],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Sales].[SalesTerritory]
WHERE
      [TerritoryID] IN (
            SELECT
                  DISTINCT [TerritoryID]
            FROM
                  TestSourceDB.[Sales].[SalesOrderHeader]
      )
SET
      IDENTITY_INSERT [Sales].[SalesTerritory] OFF
GO
INSERT INTO
      [Sales].[Store] (
            [BusinessEntityID],
            [Name],
            [SalesPersonID],
            [rowguid],
            [ModifiedDate]
      )
SELECT
      [BusinessEntityID],
      [Name],
      [SalesPersonID],
      [rowguid],
      [ModifiedDate]
FROM
      AdventureWorks2019.[Sales].[Store]
WHERE
      [SalesPersonID] IN (
            SELECT
                  [SalesPersonID]
            FROM
                  TestSourceDB.[Sales].[SalesPerson]
      )
GO

-- INSERT INTO [Person].[CountryRegion]
--            ([CountryRegionCode]
--            ,[Name]
--            ,[ModifiedDate])
--      SELECT
-- 	   [CountryRegionCode]
--       ,[Name]
--       ,[ModifiedDate]
-- 	 FROM AdventureWorks2019.[Person].[CountryRegion]
-- 	 WHERE [CountryRegionCode] COLLATE DATABASE_DEFAULT IN (SELECT DISTINCT [CountryRegionCode] FROM TestSourceDB.[Person].[StateProvince] )
-- GO

-- SET IDENTITY_INSERT [Person].[StateProvince] ON
-- INSERT INTO [Person].[StateProvince]
--            (
-- 		   [StateProvinceID]
-- 		   ,[StateProvinceCode]
--            ,[CountryRegionCode]
--            ,[IsOnlyStateProvinceFlag]
--            ,[Name]
--            ,[TerritoryID]
--            ,[rowguid]
--            ,[ModifiedDate])
--    SELECT	[StateProvinceID]
-- 		   ,[StateProvinceCode]
--            ,[CountryRegionCode]
--            ,[IsOnlyStateProvinceFlag]
--            ,[Name]
--            ,[TerritoryID]
--            ,[rowguid]
--            ,[ModifiedDate]
-- 	 FROM AdventureWorks2019.[Person].[StateProvince]
-- 	 WHERE  [StateProvinceID] IN (SELECT  [StateProvinceID] FROM TestSourceDB.[Person].[Address] ) 
-- GO
-- SET IDENTITY_INSERT [Person].[StateProvince] OFF