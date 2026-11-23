SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%seller%';

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT seller_id) AS Unique_Sellers,
    COUNT(*) - COUNT(DISTINCT seller_id) AS Duplicate_ID_Count
FROM dbo.olist_sellers_dataset;

SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Missing_Seller_ID,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS Missing_Zip_Code,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS Missing_State
FROM dbo.olist_sellers_dataset;

SELECT
    SUM(CASE WHEN LTRIM(RTRIM(seller_city)) = '' THEN 1 ELSE 0 END) AS Blank_City,
    SUM(CASE WHEN LTRIM(RTRIM(seller_state)) = '' THEN 1 ELSE 0 END) AS Blank_State
FROM dbo.olist_sellers_dataset;

SELECT
    seller_city,
    seller_state,
    COUNT(*) AS Seller_Count
FROM dbo.olist_sellers_dataset
GROUP BY seller_city, seller_state
HAVING COUNT(*) > 1
ORDER BY Seller_Count DESC;

SELECT
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
FROM dbo.olist_sellers_dataset
WHERE
    (seller_city = 'curitiba' AND seller_state <> 'PR')
    OR (seller_city = 'belo horizonte' AND seller_state <> 'MG')
    OR (seller_city = 'caxias do sul' AND seller_state <> 'RS')
    OR (seller_city = 'rio de janeiro' AND seller_state <> 'RJ');

    SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN LEN(CAST(seller_zip_code_prefix AS VARCHAR(10))) <> 5
        THEN 1 ELSE 0
    END) AS Invalid_Zip_Length,
    MIN(seller_zip_code_prefix) AS Minimum_Zip,
    MAX(seller_zip_code_prefix) AS Maximum_Zip
FROM dbo.olist_sellers_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_sellers_dataset'
  AND COLUMN_NAME = 'seller_zip_code_prefix';

  SELECT
    SUM(CASE WHEN seller_zip_code_prefix < 10000 THEN 1 ELSE 0 END) AS Needs_One_Leading_Zero,
    SUM(CASE WHEN seller_zip_code_prefix >= 10000 THEN 1 ELSE 0 END) AS Already_Five_Digits
FROM dbo.olist_sellers_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN seller_zip_code_prefix < 0
          OR seller_zip_code_prefix > 99999
        THEN 1 ELSE 0
    END) AS Invalid_Zip_Range
FROM dbo.olist_sellers_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN seller_id <> LTRIM(RTRIM(seller_id))
        THEN 1 ELSE 0
    END) AS Seller_IDs_With_Extra_Spaces
FROM dbo.olist_sellers_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN seller_city <> LTRIM(RTRIM(seller_city))
        THEN 1 ELSE 0
    END) AS Cities_With_Extra_Spaces
FROM dbo.olist_sellers_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN seller_state <> LTRIM(RTRIM(seller_state))
        THEN 1 ELSE 0
    END) AS States_With_Extra_Spaces,
    SUM(CASE
        WHEN LEN(seller_state) <> 2
        THEN 1 ELSE 0
    END) AS Invalid_State_Length
FROM dbo.olist_sellers_dataset;

SELECT
    seller_id,
    RIGHT('00000' + CAST(seller_zip_code_prefix AS VARCHAR(5)), 5)
        AS seller_zip_code_prefix,
    seller_city,
    seller_state,
    CASE
        WHEN (seller_city = 'curitiba' AND seller_state <> 'PR')
          OR (seller_city = 'belo horizonte' AND seller_state <> 'MG')
          OR (seller_city = 'caxias do sul' AND seller_state <> 'RS')
          OR (seller_city = 'rio de janeiro' AND seller_state <> 'RJ')
        THEN 1
        ELSE 0
    END AS Flag_City_State_Mismatch
INTO dbo.sellers_cleaned
FROM dbo.olist_sellers_dataset;

SELECT
    (SELECT COUNT(*) FROM dbo.olist_sellers_dataset) AS Original_Count,
    (SELECT COUNT(*) FROM dbo.sellers_cleaned) AS Cleaned_Count;

    SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT seller_id) AS Unique_Seller_IDs,
    COUNT(*) - COUNT(DISTINCT seller_id) AS Duplicate_IDs
FROM dbo.sellers_cleaned;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN LEN(seller_zip_code_prefix) <> 5
        THEN 1 ELSE 0
    END) AS Invalid_Zip_Length
FROM dbo.sellers_cleaned;

SELECT
    SUM(Flag_City_State_Mismatch) AS Flagged_Records,
    SUM(CASE
        WHEN (seller_city = 'curitiba' AND seller_state <> 'PR')
          OR (seller_city = 'belo horizonte' AND seller_state <> 'MG')
          OR (seller_city = 'caxias do sul' AND seller_state <> 'RS')
          OR (seller_city = 'rio de janeiro' AND seller_state <> 'RJ')
        THEN 1 ELSE 0
    END) AS Actual_Mismatches
FROM dbo.sellers_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sellers_cleaned'
ORDER BY ORDINAL_POSITION;

SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Missing_Seller_ID,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS Missing_Zip_Code,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS Missing_State
FROM dbo.sellers_cleaned;