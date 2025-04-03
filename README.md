# Telcomchurn

# Telco Customer Churn Analysis

## Problem Statement
A telecom company is experiencing customer churn, leading to revenue loss and increased customer acquisition costs. You have been tasked as a data analyst to analyze customer demographics, billing patterns, and service usage to uncover key drivers of churn. The insights you generate will help the company develop targeted strategies to improve customer retention and reduce churn rates.

## 📌 Project Overview
Customer churn is a critical concern for telecom companies, as retaining customers is often more cost-effective than acquiring new ones. In this projectI will be analyzing the Telco customer dataset to understand the factors influencing churn and derive actionable insights to reduce customer attrition.

## 🎯 Objectives
-	Identify key factors contributing to customer churn.
-	Analyze customer demographics and service usage to find patterns.
-	Determine the impact of contract types, tenure, and monthly charges on churn.
-	Assess how payment methods and internet services influence churn.
-	Provide actionable insights to reduce churn and improve customer retention.


## 📂 Dataset Description
The dataset contains customer information and service details, with the following key attributes:

| Column Name       | Description                                      |
|-------------------|-------------------------------------------------|
| `customerID`     | Unique customer identifier                      |
| `gender`         | Customer's gender (Male/Female)                 |
| `SeniorCitizen`  | Whether the customer is a senior citizen (0/1)  |
| `Partner`        | Whether the customer has a partner (Yes/No)     |
| `Dependents`     | Whether the customer has dependents (Yes/No)    |
| `tenure`         | Number of months the customer has stayed        |
| `PhoneService`   | Whether the customer has phone service (Yes/No) |
| `MultipleLines`  | Whether the customer has multiple phone lines   |
| `InternetService`| Type of internet service (DSL/Fiber Optic/None) |
| `OnlineSecurity` | Whether online security service is enabled      |
| `TechSupport`    | Whether the customer has tech support service   |
| `Contract`       | Type of contract (Month-to-month/One year/Two years) |
| `PaperlessBilling` | Whether billing is paperless (Yes/No)        |
| `PaymentMethod`  | Customer's payment method                       |
| `MonthlyCharges` | Monthly charges for the customer                |
| `TotalCharges`   | Total charges paid by the customer              |
| `Churn`          | Whether the customer churned (Yes/No)           |

## 🔍 Key SQL Queries & Insights
### A. Customer Segmentation & Demographics
1.	Retrieve the total number of customers and the churn rate.
```sql
SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer;
```

2.	Find the percentage of customers who churned based on gender.
```sql
SELECT 
	gender,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY gender
```

3.	Analyze the churn rate based on senior citizen status.
```sql
SELECT 
	CASE 
		WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
		ELSE 'Non Senior Citizen'
		END Citizen_Status
		,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY seniorcitizen
```

4.	Determine the average tenure of customers who churned versus those who stayed.
```sql
SELECT 
	CASE 
    WHEN Churn = 'Yes' THEN 'Churned Customers'
	ELSE 'Active Customers'
	END Customer_Status,
    COUNT(*) AS Total_Customers,
    AVG(Tenure) AS Avg_Tenure
FROM customer
GROUP BY Churn;
```


### B. Contract, Tenure & Billing Analysis
5.	Find the average monthly charges for churned customers compared to those who stayed.
```sql
SELECT 
    Contract AS Contract_Type,
    AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END) AS Avg_MonthlyCharges_Churned,
    AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END) AS Avg_MonthlyCharges_Stayed
FROM customer
GROUP BY Contract
ORDER BY Contract_Type;
```

6.	Identify the most common contract type among churned customers.
```sql
SELECT 
    Contract Contract_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY Contract
ORDER BY Churned_Customers DESC;
```

7.	Determine the churn rate for customers with different payment methods.
```sql
SELECT 
    PaymentMethod,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY PaymentMethod
ORDER BY Churn_Rate_Percentage DESC;
```

8.	Calculate the average tenure of customers based on contract type and churn status.
```sql
SELECT 
    Contract AS Contract_Type,
    AVG(CASE WHEN Churn = 'Yes' THEN Tenure END) AS Avg_tenure_Churned,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS Avg_tenures_Stayed
FROM customer
GROUP BY Contract;
```

9.	Find the correlation between total charges and churn status (e.g., do higher spenders churn more or less?).
```sql
SELECT 
    Churn,
    AVG(TotalCharges) AS Avg_TotalCharges,
    COUNT(*) AS Total_Customers
FROM customer
GROUP BY Churn
ORDER BY Churn DESC;
```

### C. Service Usage & Churn Patterns
10.	Identify the percentage of customers who churned based on their internet service type.
```sql
SELECT 
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY InternetService
ORDER BY Churn_Rate_Percentage DESC;
```

11.	Analyze how many churned customers had tech support services.
```sql
SELECT 
    TechSupport,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY TechSupport
ORDER BY Churned_Customers DESC;
```

13.	Find out whether customers with multiple services (e.g., phone, internet, TV) are more or less likely to churn.
```sql
WITH cte1 AS(
			SELECT *,
				CASE 
					WHEN PhoneService = 'Yes' AND InternetService != 'No' 
						 AND (StreamingTV = 'Yes' OR StreamingMovies = 'Yes') 
					THEN 'Phone + Internet + TV' 
					WHEN PhoneService = 'Yes' AND InternetService != 'No' 
					THEN 'Phone + Internet' 
					WHEN InternetService != 'No' AND (StreamingTV = 'Yes' OR StreamingMovies = 'Yes') 
					THEN 'Internet + TV' 
					WHEN PhoneService = 'Yes' 
					THEN 'Phone Only' 
					WHEN InternetService != 'No' 
					THEN 'Internet Only' 
					ELSE 'No Services' 
				END AS Service_Category
			FROM customer
			)

SELECT 
	Service_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM cte1
GROUP BY Service_Category
ORDER BY Churn_Rate_Percentage DESC;
```

13.	Determine the churn rate for customers with paperless billing versus those with mailed statements.
```sql
SELECT 
    PaperlessBilling,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY PaperlessBilling
ORDER BY Churn_Rate_Percentage DESC;
```
14.	Compare the churn rate of customers using fiber optic internet versus DSL or no internet service.
```sql
SELECT 
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY InternetService
ORDER BY Churn_Rate_Percentage DESC;
```


## 📊 Visualization
To complement the SQL analysis, we visualized key insights using **Power BI**:
- **Churn Rate by Contract Type**: A bar chart shows that **month-to-month contracts** have the highest churn.
- **Churn Rate by Payment Method**: A pie chart highlights that **electronic check users** churn at a higher rate.
- **Churn Rate by Internet Service Type**: A stacked bar chart shows that **fiber optic users churn more** compared to DSL users.

## 📌 Recommendations
Based on the analysis, the following strategies could help reduce churn:
- **Encourage long-term contracts**: Offering discounts for annual or two-year contracts may help reduce churn.
- **Improve Fiber Optic service**: Investigate why fiber optic customers leave more frequently and address potential service issues.
- **Educate customers on payment options**: Providing incentives for bank transfers or auto-pay setups may reduce churn.
- **Enhance tech support services**: Customers with tech support churn less, so investing in better support could improve retention.

## 🚀 Future Work
- Implement **predictive modeling** using machine learning to identify high-risk churn customers.
- Conduct **A/B testing** on retention strategies to measure effectiveness.
- Expand the dataset with customer feedback to gain more qualitative insights.

## 💡 Technologies Used
- **SQL** for data querying and analysis
- **Power BI** for data visualization
- **Python (Pandas, Seaborn, Matplotlib)** for advanced analytics (future work)

## 🏆 Conclusion
This project provides a **data-driven approach** to understanding customer churn in the telecom industry. By leveraging SQL and visualization tools, we identified key factors influencing churn and proposed actionable insights to improve retention rates.

---
📝 **Author:** Malik Akintola  
📅 **Date:** April 2025  
📌 **Repository:** [GitHub Link Here]  
