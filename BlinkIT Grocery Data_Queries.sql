--Project Name      : BlinkIT Grocery Data Analysis
--Database Name     : Blinkit_db
--Table Name        : blinkit_data
--Database Tool     : PostgreSQL (pgAdmin 4)




CREATE TABLE blinkit_data (
    Item_Fat_Content VARCHAR(50),
    Item_Identifier VARCHAR(50),
    Item_Type VARCHAR(50),
    Outlet_Establishment_Year INT,
    Outlet_Identifier VARCHAR(50),
    Outlet_Location_Type VARCHAR(50),
    Outlet_Size VARCHAR(50),
    Outlet_Type VARCHAR(50),
    Item_Visibility FLOAT,
    Item_Weight FLOAT,
    Total_Sales FLOAT,
    Rating FLOAT
);

SELECT * FROM blinkit_data;

SELECT COUNT(*) FROM blinkit_data; 

--Data Cleaning--
UPDATE blinkit_data
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;
	
--After executing this query check the data has been cleaned or not using below query
SELECT DISTINCT Item_Fat_Content FROM blinkit_data;

--A. KPI’s--
--1. TOTAL SALES:
SELECT CAST(SUM(Total_Sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_data;

--2. AVERAGE SALES
SELECT CAST(AVG(Total_Sales) AS INT) AS Avg_Sales
FROM blinkit_data;

--3. NO OF ITEMS
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_data;

--4. AVG RATING
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_data;



--B. Total Sales by Fat Content:--
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content

--C. Total Sales by Item Type--
SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC


--D. Fat Content by Outlet for Total Sales--
SELECT 
    Outlet_Location_Type,

    CAST(SUM(CASE 
        WHEN Item_Fat_Content = 'Low Fat' 
        THEN Total_Sales 
        ELSE 0 
    END) AS DECIMAL(10,2)) AS Low_Fat,

    CAST(SUM(CASE 
        WHEN Item_Fat_Content = 'Regular' 
        THEN Total_Sales 
        ELSE 0 
    END) AS DECIMAL(10,2)) AS Regular

FROM blinkit_data

GROUP BY Outlet_Location_Type

ORDER BY Outlet_Location_Type;


--E. Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year

--F. Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


--G. Sales by Outlet Location
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;


--H. All Metrics by Outlet Type:
 

SELECT Outlet_Type,
        CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
		CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
