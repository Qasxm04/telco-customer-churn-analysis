/* ============================================================
   Telco Customer Churn Analysis
   Database setup for Microsoft SQL Server
   ============================================================ */

IF DB_ID('db_churn') IS NULL
BEGIN
    CREATE DATABASE db_churn;
END;
GO

USE db_churn;
GO

/*
Import data/raw/telco_customer_churn.csv into a table named dbo.stg_Churn
using SQL Server Management Studio's Import Flat File wizard.

Recommended types:
- customerID and categorical fields: NVARCHAR
- SeniorCitizen and tenure: INT
- MonthlyCharges: DECIMAL(10,2)
- TotalCharges: NVARCHAR initially, because the source contains blanks
*/

SELECT TOP (10) *
FROM dbo.stg_Churn;
GO
