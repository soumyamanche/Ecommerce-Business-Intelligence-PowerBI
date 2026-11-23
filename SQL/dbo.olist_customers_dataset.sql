
USE Ecommerce_Analytics;
GO

SELECT COUNT(*) AS Total_Customer_Records
FROM dbo.olist_customers_dataset;


SELECT
    customer_id,
    COUNT(*) AS Duplicate_Count
FROM dbo.olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS Missing_Customer_IDs
FROM dbo.olist_customers_dataset
WHERE customer_id IS NULL;

SELECT
    COUNT(*) AS Total_Customer_Records,
    COUNT(DISTINCT customer_unique_id) AS Total_Unique_Customers
FROM dbo.olist_customers_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_customers_dataset';

SELECT
    COUNT(*) AS Missing_Zip_Codes
FROM dbo.olist_customers_dataset
WHERE customer_zip_code_prefix IS NULL;

SELECT TOP 20
    customer_zip_code_prefix
FROM dbo.olist_customers_dataset
ORDER BY customer_zip_code_prefix;

SELECT
    COUNT(*) AS Short_Postal_Codes
FROM dbo.olist_customers_dataset
WHERE LEN(CAST(customer_zip_code_prefix AS VARCHAR(10))) < 5;

SELECT TOP 20
    customer_zip_code_prefix AS Original_Zip_Code,
    RIGHT(
        '00000' + CAST(customer_zip_code_prefix AS VARCHAR(5)),
        5
    ) AS Corrected_Zip_Code
FROM dbo.olist_customers_dataset
WHERE LEN(CAST(customer_zip_code_prefix AS VARCHAR(10))) < 5
ORDER BY customer_zip_code_prefix;

SELECT
    COUNT(*) AS Postal_Codes_More_Than_5_Digits
FROM dbo.olist_customers_dataset
WHERE LEN(CAST(customer_zip_code_prefix AS VARCHAR(10))) > 5;


SELECT
    customer_id,
    customer_unique_id,
    RIGHT(
        '00000' + CAST(customer_zip_code_prefix AS VARCHAR(5)),
        5
    ) AS customer_zip_code_prefix,
    customer_city,
    customer_state
INTO dbo.customers_cleaned
FROM dbo.olist_customers_dataset;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT customer_unique_id) AS Unique_Customers,
    MIN(LEN(customer_zip_code_prefix)) AS Minimum_Zip_Length,
    MAX(LEN(customer_zip_code_prefix)) AS Maximum_Zip_Length
FROM dbo.customers_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers_cleaned';

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT customer_unique_id) AS Unique_Customers,
    MIN(LEN(customer_zip_code_prefix)) AS Minimum_Zip_Length,
    MAX(LEN(customer_zip_code_prefix)) AS Maximum_Zip_Length
FROM dbo.customers_cleaned;