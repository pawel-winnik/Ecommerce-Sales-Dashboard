
CREATE DATABASE Ecommerce_DW;
GO
USE Ecommerce_DW;
GO


CREATE TABLE Dim_Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    ListPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE Dim_Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Segment VARCHAR(30) NOT NULL
);

CREATE TABLE Fact_Sales (
    SalesID INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATE NOT NULL,
    CustomerID INT FOREIGN KEY REFERENCES Dim_Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Dim_Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(4,2) DEFAULT 0.00
);
GO


INSERT INTO Dim_Products (ProductName, Category, CostPrice, ListPrice) VALUES
('Słuchawki Wireless Pro', 'Audio', 120.00, 250.00),
('Smartband Fit 5', 'Gadzety', 80.00, 150.00),
('Klawiatura Mechaniczna', 'Komputery', 150.00, 320.00),
('Mysz Bezprzewodowa', 'Komputery', 40.00, 90.00),
('Głośnik Bluetooth', 'Audio', 90.00, 200.00);

INSERT INTO Dim_Customers (CustomerName, City, Country, Segment) VALUES
('Jan Kowalski', 'Wrocław', 'Polska', 'Retail'),
('Anna Nowak', 'Warszawa', 'Polska', 'VIP'),
('TechCorp Sp. z o.o.', 'Kraków', 'Polska', 'B2B'),
('Marek Wiśniewski', 'Poznań', 'Polska', 'Retail'),
('Ewa Zielińska', 'Gdańsk', 'Polska', 'Retail');

INSERT INTO Fact_Sales (OrderDate, CustomerID, ProductID, Quantity, UnitPrice, Discount) VALUES
('2025-03-15', 1, 1, 1, 250.00, 0.00),
('2025-03-18', 2, 2, 2, 150.00, 0.10),
('2025-06-20', 3, 3, 5, 300.00, 0.15),
('2025-09-10', 4, 1, 1, 250.00, 0.05),
('2025-11-25', 5, 4, 3, 90.00, 0.00),
('2026-01-10', 1, 5, 1, 200.00, 0.00),
('2026-02-14', 2, 1, 2, 240.00, 0.05),
('2026-03-01', 3, 3, 10, 290.00, 0.20),
('2026-03-15', 4, 2, 1, 150.00, 0.00),
('2026-04-02', 5, 5, 2, 200.00, 0.10);
GO


CREATE VIEW vw_Sales_Analysis AS
SELECT 
    f.SalesID,
    f.OrderDate,
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Segment,
    p.ProductID,
    p.ProductName,
    p.Category,
    f.Quantity,
    f.UnitPrice,
    f.Discount,
    CAST(f.Quantity * f.UnitPrice * (1 - f.Discount) AS DECIMAL(10,2)) AS NetSalesAmount,
    CAST(f.Quantity * p.CostPrice AS DECIMAL(10,2)) AS TotalCost,
    CAST((f.Quantity * f.UnitPrice * (1 - f.Discount)) - (f.Quantity * p.CostPrice) AS DECIMAL(10,2)) AS GrossMargin
FROM Fact_Sales f
JOIN Dim_Customers c ON f.CustomerID = c.CustomerID
JOIN Dim_Products p ON f.ProductID = p.ProductID;
GO