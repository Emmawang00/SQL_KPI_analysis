-- Active: 1667572255139@@projectsql.mysql.database.azure.com@3306@702project
USE 702project;

INSERT INTO 702project.dim_sales (SalesOrderDetailID, ProductID)
SELECT SalesOrderDetailID, ProductID from project.salesorderdetail;

INSERT INTO 702project.dim_category(ProductCategoryID_key, CategoryName)
SELECT c.ProductCategoryID, c.Name
FROM project.productcategory c;

INSERT INTO 702project.dim_Product(ProductID_key, ProductSubcategoryID, SubcategoryName, ProductCategoryID_key)

select DISTINCT * from (
Select a.ProductID,a.ProductSubcategoryID, h.Name, h.ProductCategoryID
FROM project.product a
LEFT JOIN (
SELECT b.ProductSubcategoryID, b.Name, b.ProductCategoryID
FROM project.productsubcategory b)h
ON h.ProductSubcategoryID = a.ProductSubcategoryID)j
Where ProductSubcategoryID != '';

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO GroupProject.fact_salesprocess(
dim_sales_SalesOrderDetailID, dim_Product_ProductID_key, Revenue, 
PurchaseCost, DelieveryTime, AverageLeadTime, ReorderPoint, Class)

SELECT DISTINCT j.SalesOrderDetailID, j.ProductID, j.Revenue, j.PurchaseCost, 
j.DeliveryTime, j.AverageLeadTime, k.ReorderPoint, k.Class FROM (
SELECT DISTINCT a.SalesOrderDetailID, a.ProductID, (a.UnitPrice*a.OrderQty) AS Revenue, p.PurchaseCost, 
DATEDIFF(a.DueDate, a.ShipDate) AS DeliveryTime, p.AverageLeadTime
FROM Project.salesorderdetail a
LEFT JOIN (
SELECT h.ProductID, h.PurchaseCost, l.AverageLeadTime
FROM (
SELECT d.ProductID, (d.LastReceiptCost - d.StandardPrice) AS PurchaseCost 
FROM Project.productvendor d)h
LEFT JOIN (SELECT ProductID, avg(AverageLeadTime) AS AverageLeadTime FROM Project.productvendor GROUP BY ProductID) l
ON h.ProductID = l.ProductID)p
ON a.ProductID = p.ProductID)j
LEFT JOIN (
SELECT c.ProductID, c.ReorderPoint, c.Class
FROM Project.product c) k
ON j.ProductID = k.ProductID;