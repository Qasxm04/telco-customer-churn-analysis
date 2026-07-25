/* ============================================================
   Project: Telco Customer Churn Analysis
   File: 04_dashboard_views.sql
   Purpose: Create SQL views for Power BI dashboard reporting
   Database: db_churn
   Source Table: dbo.stg_Churn
   ============================================================ */

USE db_churn;
GO


/* ============================================================
   1. Executive Overview View
   Used for KPI cards in Power BI
   ============================================================ */

USE db_churn;
GO

DROP VIEW IF EXISTS dbo.vw_churn_overview;
GO

CREATE VIEW dbo.vw_churn_overview AS
SELECT 
    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(
        AVG(MonthlyCharges), 
        2
    ) AS AvgMonthlyCharges,

    ROUND(
        AVG(CAST(tenure AS FLOAT)), 
        2
    ) AS AvgTenure

FROM dbo.stg_Churn;
GO

SELECT *
FROM dbo.vw_churn_overview;


/* ============================================================
   2. Churn by Contract Type
   Used to show which contracts have the highest churn
   ============================================================ */

USE db_churn;
GO

DROP VIEW IF EXISTS dbo.vw_churn_by_contract;
GO

CREATE VIEW dbo.vw_churn_by_contract AS
SELECT
    CASE
        WHEN Contract = 'Month-to-month' THEN '1. Month-to-month'
        WHEN Contract = 'One year' THEN '2. One year'
        WHEN Contract = 'Two year' THEN '3. Two year'
        ELSE Contract
    END AS Contract,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY 
    CASE
        WHEN Contract = 'Month-to-month' THEN '1. Month-to-month'
        WHEN Contract = 'One year' THEN '2. One year'
        WHEN Contract = 'Two year' THEN '3. Two year'
        ELSE Contract
    END;
GO

/* ============================================================
   3. Churn by Payment Method
   Used to analyse churn linked to billing/payment behaviour
   ============================================================ */

USE db_churn;
GO

DROP VIEW IF EXISTS dbo.vw_churn_by_payment_method;
GO

CREATE VIEW dbo.vw_churn_by_payment_method AS
SELECT 
    PaymentMethod,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY PaymentMethod;
GO

SELECT *
FROM dbo.vw_churn_by_payment_method;

/* ============================================================
   4. Churn by Internet Service
   Used to compare churn across DSL, Fibre Optic, and No Internet
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_churn_by_internet_service;
GO

CREATE VIEW dbo.vw_churn_by_internet_service AS
SELECT 
    InternetService,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY InternetService;
GO

/* ============================================================
   5. Churn by Tenure Group
   Used to identify whether newer or older customers churn more
   ============================================================ */
DROP VIEW IF EXISTS dbo.vw_churn_by_tenure_group;
GO

CREATE VIEW dbo.vw_churn_by_tenure_group AS
SELECT
    CASE
        WHEN tenure <= 12 THEN '0 - 12 Months'
        WHEN tenure <= 24 THEN '13 - 24 Months'
        WHEN tenure <= 48 THEN '25 - 48 Months'
        ELSE '49+ Months'
    END AS TenureGroup,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY
    CASE
        WHEN tenure <= 12 THEN '0 - 12 Months'
        WHEN tenure <= 24 THEN '13 - 24 Months'
        WHEN tenure <= 48 THEN '25 - 48 Months'
        ELSE '49+ Months'
    END;
GO

/* ============================================================
   6. Churn by Online Security
   Used to check whether lack of online security links to churn
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_churn_by_online_security;
GO

CREATE VIEW dbo.vw_churn_by_online_security AS
SELECT 
    OnlineSecurity,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY OnlineSecurity;
GO

/* ============================================================
   7. Churn by Tech Support
   Used to check whether lack of support links to churn
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_churn_by_tech_support;
GO

CREATE VIEW dbo.vw_churn_by_tech_support AS
SELECT 
    TechSupport,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS ChurnRate,

    CAST(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY TechSupport;
GO


/* ============================================================
   8. Churn by Support and Security Combination
   Used for deeper customer risk analysis
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_churn_by_support_security;
GO

CREATE VIEW dbo.vw_churn_by_support_security AS
SELECT 
    TechSupport,
    OnlineSecurity,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS ChurnRate,

    ROUND(
        SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS RetentionRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY TechSupport, OnlineSecurity;
GO


/* ============================================================
   9. Revenue by Churn Status
   Used to compare revenue from retained vs churned customers
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_revenue_by_churn_status;
GO

CREATE VIEW dbo.vw_revenue_by_churn_status AS
SELECT 
    Churn,

    COUNT(*) AS TotalCustomers,

    ROUND(SUM(MonthlyCharges), 2) AS TotalMonthlyRevenue,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.stg_Churn
GROUP BY Churn;
GO


/* ============================================================
   10. High-Risk Customer View
   Simple rule-based customer risk segmentation
   Used for retention targeting
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_customer_risk_segments;
GO

CREATE VIEW dbo.vw_customer_risk_segments AS
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    Contract,
    PaymentMethod,
    InternetService,
    OnlineSecurity,
    TechSupport,
    MonthlyCharges,
    TotalCharges,
    Churn,

    CASE
        WHEN Contract = 'Month-to-month'
             AND tenure <= 12
             AND MonthlyCharges >= 70
        THEN 'High Risk'

        WHEN Contract = 'Month-to-month'
             AND tenure <= 24
        THEN 'Medium Risk'

        WHEN TechSupport = 'No'
             AND OnlineSecurity = 'No'
             AND InternetService <> 'No'
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS RiskSegment

FROM dbo.stg_Churn;
GO


/* ============================================================
   11. Risk Segment Summary
   Used for Power BI risk segment charts
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_risk_segment_summary;
GO

CREATE VIEW dbo.vw_risk_segment_summary AS
SELECT
    RiskSegment,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS RetainedCustomers,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS ChurnRate,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END),
        2
    ) AS MonthlyRevenueLost,

    ROUND(AVG(MonthlyCharges), 2) AS AvgMonthlyCharges

FROM dbo.vw_customer_risk_segments
GROUP BY RiskSegment;
GO


/* ============================================================
   12. Customer Detail View
   Used for detailed customer table in Power BI
   ============================================================ */

DROP VIEW IF EXISTS dbo.vw_customer_detail;
GO

CREATE VIEW dbo.vw_customer_detail AS
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,

    CASE
        WHEN tenure <= 12 THEN '0 - 12 Months'
        WHEN tenure <= 24 THEN '13 - 24 Months'
        WHEN tenure <= 48 THEN '25 - 48 Months'
        ELSE '49 + Months'
    END AS TenureGroup,

    Contract,
    PaymentMethod,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    MonthlyCharges,
    TotalCharges,
    Churn

FROM dbo.stg_Churn;
GO
/* ============================================================
   13. Churn by gender
   ============================================================ */

USE db_churn;
GO

DROP VIEW IF EXISTS dbo.vw_total_churn_by_gender;
GO

CREATE VIEW dbo.vw_total_churn_by_gender AS
SELECT
    gender,

    COUNT(*) AS TotalChurnedCustomers,

    CAST(
        COUNT(*) * 1.0 / 
        (SELECT COUNT(*) FROM dbo.stg_Churn WHERE Churn = 'Yes')
        AS DECIMAL(10,4)
    ) AS ChurnGenderPercentage

FROM dbo.stg_Churn
WHERE Churn = 'Yes'
GROUP BY gender;
GO

SELECT *
FROM dbo.vw_total_churn_by_gender;

/* ============================================================
   14. Test Views
   Run these after creating the views to check everything works
   ============================================================ */

SELECT * FROM dbo.vw_churn_overview;
SELECT * FROM dbo.vw_churn_by_contract;
SELECT * FROM dbo.vw_churn_by_payment_method;
SELECT * FROM dbo.vw_churn_by_internet_service;
SELECT * FROM dbo.vw_churn_by_tenure_group;
SELECT * FROM dbo.vw_churn_by_online_security;
SELECT * FROM dbo.vw_churn_by_tech_support;
SELECT * FROM dbo.vw_churn_by_support_security;
SELECT * FROM dbo.vw_revenue_by_churn_status;
SELECT * FROM dbo.vw_customer_risk_segments;
SELECT * FROM dbo.vw_risk_segment_summary;
SELECT * FROM dbo.vw_customer_detail;
GO
USE db_churn;
GO

DROP VIEW IF EXISTS dbo.vw_service_subscription_summary;
GO

CREATE VIEW dbo.vw_service_subscription_summary AS

WITH ServiceData AS (

    SELECT 
        'Phone Service' AS Service,
        CASE WHEN PhoneService = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Multiple Lines' AS Service,
        CASE WHEN MultipleLines = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Internet Service' AS Service,
        CASE WHEN InternetService <> 'No' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Online Security' AS Service,
        CASE WHEN OnlineSecurity = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Online Backup' AS Service,
        CASE WHEN OnlineBackup = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Device Protection' AS Service,
        CASE WHEN DeviceProtection = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Tech Support' AS Service,
        CASE WHEN TechSupport = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Streaming TV' AS Service,
        CASE WHEN StreamingTV = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn

    UNION ALL

    SELECT 
        'Streaming Movies' AS Service,
        CASE WHEN StreamingMovies = 'Yes' THEN 'Yes' ELSE 'No' END AS ServiceStatus
    FROM dbo.stg_Churn
),

ServiceCounts AS (
    SELECT
        Service,
        ServiceStatus,
        COUNT(*) AS CustomerCount
    FROM ServiceData
    GROUP BY Service, ServiceStatus
)

SELECT
    Service,
    ServiceStatus,
    CustomerCount,
    CAST(
        CustomerCount * 1.0 / SUM(CustomerCount) OVER (PARTITION BY Service)
        AS DECIMAL(10,4)
    ) AS Percentage
FROM ServiceCounts;
GO

SELECT *
FROM dbo.vw_service_subscription_summary
ORDER BY Service, ServiceStatus;