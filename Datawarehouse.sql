-- Active: 1667663883788@@projectsql.mysql.database.azure.com@3306@datawarehouse
USE Datawarehouse;
DROP TABLE IF EXISTS `dim_category`;
CREATE TABLE `dim_category` (
  `ProductCategoryID_key` int NOT NULL,
  `CategoryName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ProductCategoryID_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dim_product`;
CREATE TABLE `dim_product` (
  `ProductID_key` int NOT NULL,
  `ProductSubcategoryID` int DEFAULT NULL,
  `SubcategoryName` varchar(45) DEFAULT NULL,
  `ProductCategoryID_key` int NOT NULL,
  PRIMARY KEY (`ProductID_key`),
  KEY `fk_dim_product_dim_category1_idx` (`ProductCategoryID_key`),
  CONSTRAINT `fk_dim_product_dim_category1` FOREIGN KEY (`ProductCategoryID_key`) REFERENCES `dim_category` (`ProductCategoryID_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `dim_sales` (
  `SalesOrderDetailID` int NOT NULL,
  `ProductID` int DEFAULT NULL,
  PRIMARY KEY (`SalesOrderDetailID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `fact_salesprocess` (
  `dim_sales_SalesOrderDetailID` int NOT NULL,
  `dim_Product_ProductID_key` int DEFAULT NULL,
  `Revenue` int DEFAULT NULL,
  `PurchaseCost` int DEFAULT NULL,
  `DelieveryTime` int DEFAULT NULL,
  `AverageLeadTime` int DEFAULT NULL,
  `ReorderPoint` int DEFAULT NULL,
  `Class` varchar(45) DEFAULT NULL,
  KEY `fk_dim_product_has_dim_sales_dim_sales1_idx` (`dim_sales_SalesOrderDetailID`),
  KEY `fk_fact_salesprocess_dim_Product1_idx` (`dim_Product_ProductID_key`),
  CONSTRAINT `fk_dim_product_has_dim_sales_dim_sales1` FOREIGN KEY (`dim_sales_SalesOrderDetailID`) REFERENCES `dim_sales` (`SalesOrderDetailID`),
  CONSTRAINT `fk_fact_salesprocess_dim_Product1` FOREIGN KEY (`dim_Product_ProductID_key`) REFERENCES `dim_Product` (`ProductID_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4