-- Kreiranje baze podataka
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'UpravljanjeProizvodnjom')
BEGIN
    CREATE DATABASE UpravljanjeProizvodnjom
END
GO

USE UpravljanjeProizvodnjom
GO

-- Tabela za korisnike
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Username NVARCHAR(50) NOT NULL UNIQUE,
        Password NVARCHAR(255) NOT NULL,
        Email NVARCHAR(100),
        Role NVARCHAR(50) NOT NULL DEFAULT 'USER',
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastLogin DATETIME,
        ModifiedDate DATETIME
    )
END
GO

-- Tabela za uloge
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
BEGIN
    CREATE TABLE Roles (
        Id INT PRIMARY KEY IDENTITY(1,1),
        RoleName NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(255),
        Permissions NVARCHAR(MAX),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    )
END
GO

-- Tabela za log aktivnosti
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ActivityLog')
BEGIN
    CREATE TABLE ActivityLog (
        Id INT PRIMARY KEY IDENTITY(1,1),
        UserId INT,
        Username NVARCHAR(50),
        ActivityType NVARCHAR(50) NOT NULL,
        Description NVARCHAR(255),
        TableName NVARCHAR(100),
        RecordId INT,
        ActivityDate DATETIME NOT NULL DEFAULT GETDATE(),
        IPAddress NVARCHAR(15),
        FOREIGN KEY (UserId) REFERENCES Users(Id)
    )
END
GO

-- Tabela za proizvode
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        Id INT PRIMARY KEY IDENTITY(1,1),
        ProductName NVARCHAR(100) NOT NULL,
        Description NVARCHAR(255),
        SKU NVARCHAR(50) UNIQUE,
        Price DECIMAL(10,2),
        Quantity INT NOT NULL DEFAULT 0,
        ReorderLevel INT,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME
    )
END
GO

-- Tabela za narudžbine
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE Orders (
        Id INT PRIMARY KEY IDENTITY(1,1),
        OrderNumber NVARCHAR(50) UNIQUE,
        OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
        CustomerId INT,
        Status NVARCHAR(50) NOT NULL DEFAULT 'NEW',
        TotalAmount DECIMAL(10,2),
        Description NVARCHAR(255),
        DueDate DATETIME,
        CreatedBy INT,
        ModifiedDate DATETIME,
        FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
    )
END
GO

-- Tabela za stavke narudžbine
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')
BEGIN
    CREATE TABLE OrderItems (
        Id INT PRIMARY KEY IDENTITY(1,1),
        OrderId INT NOT NULL,
        ProductId INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,
        TotalPrice DECIMAL(10,2),
        FOREIGN KEY (OrderId) REFERENCES Orders(Id),
        FOREIGN KEY (ProductId) REFERENCES Products(Id)
    )
END
GO

-- Tabela za proizvodne poslove
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductionJobs')
BEGIN
    CREATE TABLE ProductionJobs (
        Id INT PRIMARY KEY IDENTITY(1,1),
        JobNumber NVARCHAR(50) UNIQUE,
        OrderId INT,
        ProductId INT,
        Quantity INT NOT NULL,
        QuantityProduced INT NOT NULL DEFAULT 0,
        Status NVARCHAR(50) NOT NULL DEFAULT 'PLANNING',
        StartDate DATETIME,
        EndDate DATETIME,
        EstimatedDate DATETIME,
        Notes NVARCHAR(MAX),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME,
        FOREIGN KEY (OrderId) REFERENCES Orders(Id),
        FOREIGN KEY (ProductId) REFERENCES Products(Id)
    )
END
GO

-- Tabela za resurse (mašine, radnike, materijal)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Resources')
BEGIN
    CREATE TABLE Resources (
        Id INT PRIMARY KEY IDENTITY(1,1),
        ResourceName NVARCHAR(100) NOT NULL,
        ResourceType NVARCHAR(50) NOT NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'AVAILABLE',
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME
    )
END
GO

-- Tabela za dodelu resursa na poslove
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'JobResources')
BEGIN
    CREATE TABLE JobResources (
        Id INT PRIMARY KEY IDENTITY(1,1),
        JobId INT NOT NULL,
        ResourceId INT NOT NULL,
        AllocatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ReleaseDate DATETIME,
        FOREIGN KEY (JobId) REFERENCES ProductionJobs(Id),
        FOREIGN KEY (ResourceId) REFERENCES Resources(Id)
    )
END
GO

-- Tabela za izveštaje
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reports')
BEGIN
    CREATE TABLE Reports (
        Id INT PRIMARY KEY IDENTITY(1,1),
        ReportName NVARCHAR(100) NOT NULL,
        ReportType NVARCHAR(50),
        CreatedBy INT,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastRun DATETIME,
        GeneratedFile NVARCHAR(255),
        FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
    )
END
GO

-- Indeksi za performanse
CREATE INDEX idx_Users_Username ON Users(Username)
GO
CREATE INDEX idx_Users_Role ON Users(Role)
GO
CREATE INDEX idx_ActivityLog_UserId ON ActivityLog(UserId)
GO
CREATE INDEX idx_ActivityLog_ActivityDate ON ActivityLog(ActivityDate)
GO
CREATE INDEX idx_Orders_Status ON Orders(Status)
GO
CREATE INDEX idx_Orders_OrderDate ON Orders(OrderDate)
GO
CREATE INDEX idx_ProductionJobs_Status ON ProductionJobs(Status)
GO
CREATE INDEX idx_ProductionJobs_OrderId ON ProductionJobs(OrderId)
GO

--默认корисничке улогe и администратор
INSERT INTO Roles (RoleName, Description, Permissions)
VALUES 
    ('ADMIN', 'Administrator sa svim dozvolama', 'ALL'),
    ('MANAGER', 'Menadžer proizvodnje', 'PRODUCTION,ORDERS,REPORTS'),
    ('OPERATOR', 'Radnik na proizvodnji', 'PRODUCTION,VIEW'),
    ('VIEWER', 'Samo pregled podataka', 'VIEW')
GO

-- Korisnik admin (lozinka treba da se promeni)
INSERT INTO Users (Username, Password, Email, Role, IsActive)
VALUES ('admin', '1234', 'admin@example.com', 'ADMIN', 1)
GO

PRINT 'Baza podataka i tabele su uspešno kreirane!'
GO
