ALTER TABLE customer
ALTER COLUMN churn 

-- Customer Segmentation & Demographics
--	1.	Retrieve the total number of customers and the churn rate.

SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer;

--	2.	Find the percentage of customers who churned based on gender.
SELECT 
	gender,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY gender

--	3.	Analyze the churn rate based on senior citizen status.
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

--	4.	Determine the average tenure of customers who churned versus those who stayed.
SELECT 
	CASE 
    WHEN Churn = 'Yes' THEN 'Churned Customers'
	ELSE 'Active Customers'
	END Customer_Status,
    COUNT(*) AS Total_Customers,
    AVG(Tenure) AS Avg_Tenure
FROM customer
GROUP BY Churn;


--Contract, Tenure & Billing Analysis
--	5.	Find the average monthly charges for churned customers compared to those who stayed.
SELECT 
    Contract AS Contract_Type,
    AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END) AS Avg_MonthlyCharges_Churned,
    AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END) AS Avg_MonthlyCharges_Stayed
FROM customer
GROUP BY Contract
ORDER BY Contract_Type;

--	6.	Identify the most common contract type among churned customers.
SELECT 
    Contract Contract_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY Contract
ORDER BY Churned_Customers DESC;

--	7.	Determine the churn rate for customers with different payment methods.
SELECT 
    PaymentMethod,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY PaymentMethod
ORDER BY Churn_Rate_Percentage DESC;


--	8.	Calculate the average tenure of customers based on contract type and churn status.
SELECT 
    Contract AS Contract_Type,
    AVG(CASE WHEN Churn = 'Yes' THEN Tenure END) AS Avg_tenure_Churned,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS Avg_tenures_Stayed
FROM customer
GROUP BY Contract;

--	9.	Find the correlation between total charges and churn status (e.g., do higher spenders churn more or less?).
SELECT 
    Churn,
    AVG(TotalCharges) AS Avg_TotalCharges,
    COUNT(*) AS Total_Customers
FROM customer
GROUP BY Churn
ORDER BY Churn DESC;

-- Service Usage & Churn Patterns
--	10.	Identify the percentage of customers who churned based on their internet service type.
SELECT 
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY InternetService
ORDER BY Churn_Rate_Percentage DESC;

--	11.	Analyze how many churned customers had tech support services.
SELECT 
    TechSupport,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY TechSupport
ORDER BY Churned_Customers DESC;


--	12.	Find out whether customers with multiple services (e.g., phone, internet, TV) are more or less likely to churn.
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

--	13.	Determine the churn rate for customers with paperless billing versus those with mailed statements.
SELECT 
    PaperlessBilling,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY PaperlessBilling
ORDER BY Churn_Rate_Percentage DESC;

--	14.	Compare the churn rate of customers using fiber optic internet versus DSL or no internet service.
SELECT 
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM customer
GROUP BY InternetService
ORDER BY Churn_Rate_Percentage DESC;


