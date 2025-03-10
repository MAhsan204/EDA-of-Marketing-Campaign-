USE marketing_campaign;

SELECT * 
FROM customers AS cus
INNER JOIN marketing_interactions AS mi
ON cus.CustomerID=mi.CustomerID
INNER JOIN subscriptions AS subs
ON cus.CustomerID=subs.CustomerID
INNER JOIN transactions AS trans
ON cus.CustomerID=trans.CustomerID;


--Customer Interaction and Purchase Analysis
--Identify when customers interacted with the campaign, when they signed up, and when they made a purchase.

SELECT 
	cus.CustomerID,
	InteractionDate,
	SignUpDate,
	PurchaseDate
FROM marketing_interactions AS mi
INNER JOIN customers AS cus
ON mi.CustomerID = cus.CustomerID
INNER JOIN transactions AS trans
ON cus.CustomerID=trans.CustomerID;

--Marketing Campaign Performance Analysis
--Determine the number of customers acquired through each marketing campaign, segmented by gender.

SELECT 
	CampaignID,
	Gender,
	COUNT(*)
FROM customers AS cus
INNER JOIN marketing_interactions AS mi
ON cus.CustomerID = mi.CustomerID
GROUP BY CampaignID,Gender
ORDER BY Gender;

--Campaign Effectiveness on Subscriptions
--Evaluate the number of customers who subscribed through each campaign, their average age, gender distribution, and average income.

SELECT 
	CampaignID,
	Gender,
	COUNT(*) AS Customer_per_Campaign,
	AVG(Age) AS Average_Age,
	AVG(Income) AS Average_Income
FROM customers AS cus
INNER JOIN marketing_interactions AS mi
ON cus.CustomerID=mi.CustomerID
GROUP BY CampaignID,Gender
ORDER BY COUNT(*) DESC;

-- City-wise Subscription Spending Patterns
--Identify the cities where customers spend the most on subscriptions and analyze their demographic characteristics, including average age and income.

SELECT 
	cus.Location,
	AVG(Age) AS Average_Age,
	AVG(Income) AS Average_Income,
	AVG(Amount) AS Average_Amount_Subscription
FROM customers AS cus
INNER JOIN transactions AS trans
ON cus.CustomerID = trans.CustomerID
GROUP BY cus.Location
ORDER BY AVG(Amount) DESC;

--Top-Selling Products and Campaign Influence
--Determine which product has the highest sales, the age group that purchases it the most, and the marketing campaign that influenced the purchase.

SELECT 
	ProductID,
	CampaignID,
	COUNT(*) AS Total_Sales,
	AVG(Age) AS Average_Age
FROM customers AS cus
INNER JOIN transactions AS trans
ON cus.CustomerID = trans.CustomerID
INNER JOIN marketing_interactions AS mi
ON cus.CustomerID=mi.CustomerID
GROUP BY ProductID,CampaignID
ORDER BY COUNT(*) DESC;

--Highest Revenue-Generating Products
--Identify the top 10 products that have generated the highest revenue based on average transaction amounts.

SELECT TOP 10
	ProductID,
	AVG(Amount)
FROM transactions
GROUP BY ProductID
ORDER BY AVG(Amount) DESC;

--Customer Churn and Spending Behavior
--Analyze the spending behavior of churned customers (Churn = 0) to determine if pricing might be a factor in customer attrition.

SELECT 
	Churned,
	AVG(Amount),
	MAX(Amount),
	MIN(Amount)
FROM subscriptions AS subs
INNER JOIN transactions AS trans
ON subs.CustomerID = trans.CustomerID
GROUP BY Churned

--Income Group Distribution of Customers
--Segment customers into different salary groups (Low, Mid, Good, Handsome) and determine the most common income category among customers.

SELECT 
CASE
	WHEN Income BETWEEN 30000 AND 50000 THEN 'Low Salary'
	WHEN Income BETWEEN 50000 AND 70000 THEN 'Mid Salary'
	WHEN Income BETWEEN 70000 AND 90000 THEN 'Good Salary'
	WHEN Income > 90000 THEN 'Handsome Salary'
END AS Salary_Group,
COUNT(*) AS Total_Count
FROM customers
GROUP BY 
CASE
	WHEN Income BETWEEN 30000 AND 50000 THEN 'Low Salary'
	WHEN Income BETWEEN 50000 AND 70000 THEN 'Mid Salary'
	WHEN Income BETWEEN 70000 AND 90000 THEN 'Good Salary'
	WHEN Income > 90000 THEN 'Handsome Salary'
END; 

-- Subscription Trends by Age Group and Month
--Identify which age groups subscribe the most and in which months they are more likely to make a purchase.

SELECT 
CASE
	WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults(18-25)'
	WHEN Age BETWEEN 26 AND 35 THEN 'Early Career Professionals(26-35)'
	WHEN Age BETWEEN 36 AND 45 THEN 'Mid-Career Professionals(36-45)'
	WHEN Age BETWEEN 46 AND 60 THEN 'Experienced Professionals(46-60)'
	ELSE 'Senior Citizens (60+)'
END AS Age_Group,
MONTH(PurchaseDate) AS Purchase_Month,
COUNT(*) AS Total_Count
FROM customers AS cus
INNER JOIN transactions AS trans
ON cus.CustomerID=trans.CustomerID
GROUP BY
	CASE
		WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults(18-25)'
        WHEN Age BETWEEN 26 AND 35 THEN 'Early Career Professionals(26-35)'
        WHEN Age BETWEEN 36 AND 45 THEN 'Mid-Career Professionals(36-45)'
        WHEN Age BETWEEN 46 AND 60 THEN 'Experienced Professionals(46-60)'
        ELSE 'Senior Citizens (60+)'
	END,
	MONTH(PurchaseDate)
ORDER BY 
	MONTH(PurchaseDate),
	COUNT(*);

--Age Group and Salary Category Distribution
--Analyze the distribution of customers based on their age group and salary category to understand the relationship between income levels and age demographics.

SELECT 
	CASE 
		WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults'
        WHEN Age BETWEEN 26 AND 35 THEN 'Early Career Professionals'
        WHEN Age BETWEEN 36 AND 45 THEN 'Mid-Career Professionals'
        WHEN Age BETWEEN 46 AND 60 THEN 'Experienced Professionals'
        ELSE 'Senior Citizens'
    END AS Age_Group,

    CASE
        WHEN Income BETWEEN 30000 AND 50000 THEN 'Low Salary'
        WHEN Income BETWEEN 50000 AND 70000 THEN 'Mid Salary'
        WHEN Income BETWEEN 70000 AND 90000 THEN 'Good Salary'
        WHEN Income > 90000 THEN 'Handsome Salary'
    END AS Salary_Group,

    COUNT(*) AS Total_Employees
FROM customers
GROUP BY 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults'
        WHEN Age BETWEEN 26 AND 35 THEN 'Early Career Professionals'
        WHEN Age BETWEEN 36 AND 45 THEN 'Mid-Career Professionals'
        WHEN Age BETWEEN 46 AND 60 THEN 'Experienced Professionals'
        ELSE 'Senior Citizens'
    END,
    CASE
        WHEN Income BETWEEN 30000 AND 50000 THEN 'Low Salary'
        WHEN Income BETWEEN 50000 AND 70000 THEN 'Mid Salary'
        WHEN Income BETWEEN 70000 AND 90000 THEN 'Good Salary'
        WHEN Income > 90000 THEN 'Handsome Salary'
    END
ORDER BY Age_Group;
