-- Active: 1667663883788@@projectsql.mysql.database.azure.com@3306@datawarehouse
USE Datawarehouse;

# What is the average revenue per product category?
SELECT `SubcategoryName`, SUM(Revenue) AS Revenue_sub
FROM fact_salesprocess b
LEFT JOIN dim_product a ON a.ProductID_key = b.dim_Product_ProductID_key
LEFT JOIN dim_category c ON c.ProductCategoryID_key = a.ProductCategoryID_key
GROUP BY c.CategoryName, a.SubcategoryName
ORDER BY SUM(Revenue) DESC;

# What is the average revenue per product subcategory - bikes, components, accessories, clothing?

SELECT `CategoryName`, SUM(Revenue_sub) FROM
(SELECT DISTINCT CategoryName, SUM(Revenue) AS Revenue_sub
FROM fact_salesprocess b
LEFT JOIN dim_product a ON a.ProductID_key = b.dim_Product_ProductID_key
LEFT JOIN dim_category c ON c.ProductCategoryID_key = a.ProductCategoryID_key
GROUP BY c.CategoryName, a.SubcategoryName
ORDER BY SUM(Revenue) DESC) k
GROUP BY CategoryName;

# Shall we reduce “Delivery time - the time from order to being received by customers- to increase productivity?

SELECT SubcategoryName, AVG(`DelieveryTime`), SUM(Revenue) 
FROM fact_salesprocess b
LEFT JOIN dim_product a ON a.ProductID_key = b.dim_Product_ProductID_key
GROUP BY a.`SubcategoryName`
ORDER BY SUM(Revenue) DESC, AVG(`DelieveryTime`) ASC;

