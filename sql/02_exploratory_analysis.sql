Select	gender, Count(gender) as TotalCount,
Count(gender) * 100.0 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By gender

Select Contract, Count(Contract) as TotalCount,
Count(Contract) * 100.0 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By Contract

Select Contract,
Count(*) as TotalCustomer,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) * 100 / Count(*) as ChurnRate
From stg_Churn
Group By Contract
Order By ChurnRate Desc




Select SeniorCitizen,Count(SeniorCitizen) as TotalCount,
Count(SeniorCitizen) * 100.0 / (Select Count(*) from stg_Churn) as percetage
From stg_Churn
Group By SeniorCitizen

Select PaymentMethod, Count(PaymentMethod) as TotalPaymentCount,
Count(PaymentMethod) * 100.0 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn 
Group By PaymentMethod

Select PaymentMethod,
Count(*) as TotalCustomers,
Sum(Case when Churn = 'yes'  Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) * 100.0 / Count(*) as ChurnRate
From stg_Churn
Group By PaymentMethod
Order By ChurnRate Desc


Select InternetService, Count(InternetService) as TotalService,
Count(InternetService) * 100.0 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By InternetService

Select InternetService,
Count(*) as TotalCustomers,
Sum(Case When Churn = 'yes' Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'yes' Then 1 Else 0 End) * 100 / Count(*) as ChurnRate
From stg_Churn 
Group By InternetService
Order By ChurnRate Desc


Select Partner, Count(Partner) as Total,
Count(Partner) * 100 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By Partner

Select Dependents, Count(Partner) as Total_Dependents,
Count(Partner) * 100 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By Dependents

Select OnlineSecurity, Count(OnlineSecurity) as Total_Person_Online_Security,
Count(OnlineSecurity) * 100 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By OnlineSecurity

Select OnlineSecurity,
Count(*) as TotalCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) * 100.0 / Count(*) as ChurnRate
From stg_Churn
Group By OnlineSecurity
Order By ChurnRate Desc

Select TechSupport, Count(TechSupport) as Total_Support,
Count(TechSupport) * 100 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By TechSupport

Select TechSupport,
Count(*) as TotalCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) * 100.0 / Count(*) as ChurnRate
From stg_Churn
Group By TechSupport
Order By ChurnRate Desc

Select Churn, Count(Churn) as TotalChurn,
Count(Churn) * 100 / (Select Count(*) from stg_Churn) as Percentage
From stg_Churn
Group By Churn

Select InternetService
From stg_Churn

Select
Case
	When tenure <= 12 Then '0 - 12 Months'
	When tenure <= 24 Then '23 - 24 Months'
	When tenure <= 48 Then '25 - 48 Months'
	Else '49 + Months'
End as TenureGroup,
Count(*) as TotalCustomers,
Sum(Case When Churn = 'yes' Then 1 Else 0 End) as ChurnedCustomers,
Sum(Case When Churn = 'yes' Then 1 Else 0 End) * 100 / Count(*) as ChurnRate
From stg_Churn
Group By
Case 
	When tenure <= 12 Then '0 - 12 Months'
	When tenure <= 24 Then '13 - 24 Months'
	When tenure <= 48 Then '25 - 48 Months'
	Else '49 + Months'
End 
Order By ChurnRate Desc

-- Revenue Analysis
-- 1. Monthly revenue lost

Select
Round(Sum(MonthlyCharges), 2) as MonthlyRevenueLost
From stg_Churn
Where Churn = 'Yes'

-- 2. Average monthly charges by churn
Select Churn,
Count(*) as TotalCustomers,
Round(AVG(MonthlyCharges), 2) as AVGMonthlyCharges
From stg_Churn
Group By Churn
Order By AVGMonthlyCharges Desc

-- 3. Revenue lost by contract type
Select Contract,
Count(*) as ChurnedCustomers,
Round(Sum(MonthlyCharges), 2) as MonthlyChargesLost,
Round(AVG(MonthlyCharges), 2) as AVGMonthlyCharges
From stg_Churn
Where Churn = 'Yes'
Group By Contract
Order By MonthlyChargesLost Desc

-- 4. Revenue lost by Payment Method

Select PaymentMethod,
Count(*) as ChurnedCustomers,
Round(Sum(MonthlyCharges), 2) as MonthlyRevenueLost,
Round(Avg(MonthlyCharges), 2) as AvgMonthlyCharges
From stg_Churn
Where Churn = 'Yes'
Group By PaymentMethod
Order By MonthlyRevenueLost Desc

-- 5. Revenue lost by internet service
Select InternetService,
Count(*) as ChurnedCustomers,
Round(Sum(MonthlyCharges), 2) as MonthlyRevenueLost,
Round(Avg(MonthlyCharges), 2) as AvgMonthlyCharges
From stg_Churn
Where Churn = 'Yes'
Group By InternetService
Order By MonthlyRevenueLost Desc

--6. Total revenue comparison by churn
Select Churn,
Count(*) as TotalCustomers,
Round(Sum(MonthlyCharges), 2) as TotalMonthlyRevenue,
Round(Avg(MonthlyCharges), 2) as AvgMonthlyCharges
From stg_Churn
Group By Churn
Order By TotalMonthlyRevenue Desc