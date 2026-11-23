SELECT
    COUNT(*) AS Total_order_items_Records
FROM dbo.olist_order_items_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'olist_order_items_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'olist_order_items_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS Missing_Item_ID,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Missing_Product_ID,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Missing_Seller_ID,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS Missing_Shipping_Date,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS Missing_Price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS Missing_Freight
FROM dbo.olist_order_items_dataset;

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS Record_Count
FROM dbo.olist_order_items_dataset
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

SELECT
    SUM(CASE WHEN LTRIM(RTRIM(order_id)) = '' THEN 1 ELSE 0 END) AS Blank_Order_ID,
    SUM(CASE WHEN LTRIM(RTRIM(product_id)) = '' THEN 1 ELSE 0 END) AS Blank_Product_ID,
    SUM(CASE WHEN LTRIM(RTRIM(seller_id)) = '' THEN 1 ELSE 0 END) AS Blank_Seller_ID
FROM dbo.olist_order_items_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN price = 0 THEN 1 ELSE 0 END) AS Zero_Price_Records,
    SUM(CASE WHEN price < 0 THEN 1 ELSE 0 END) AS Negative_Price_Records,
    MIN(price) AS Minimum_Price,
    MAX(price) AS Maximum_Price
FROM dbo.olist_order_items_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS Zero_Freight_Records,
    SUM(CASE WHEN freight_value < 0 THEN 1 ELSE 0 END) AS Negative_Freight_Records,
    MIN(freight_value) AS Minimum_Freight,
    MAX(freight_value) AS Maximum_Freight
FROM dbo.olist_order_items_dataset;

SELECT TOP 10
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM dbo.olist_order_items_dataset
WHERE freight_value = 0
ORDER BY price DESC;

SELECT
    seller_id,
    COUNT(*) AS Zero_Freight_Items
FROM dbo.olist_order_items_dataset
WHERE freight_value = 0
GROUP BY seller_id
ORDER BY Zero_Freight_Items DESC;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS Missing_Shipping_Dates,
    MIN(shipping_limit_date) AS Earliest_Shipping_Deadline,
    MAX(shipping_limit_date) AS Latest_Shipping_Deadline
FROM dbo.olist_order_items_dataset;

SELECT
    COUNT(*) AS Invalid_Date_Sequence_Count
FROM dbo.olist_order_items_dataset AS oi
INNER JOIN dbo.orders_cleaned AS o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN price <> ROUND(price, 2) THEN 1 ELSE 0 END) AS Price_More_Than_2_Decimals,
    SUM(CASE WHEN freight_value <> ROUND(freight_value, 2) THEN 1 ELSE 0 END) AS Freight_More_Than_2_Decimals,
    SUM(price) AS Original_Price_Total,
    SUM(freight_value) AS Original_Freight_Total
FROM dbo.olist_order_items_dataset;

SELECT
    SUM(price) AS Original_Price_Total,
    SUM(CAST(ROUND(price, 2) AS DECIMAL(12,2))) AS Rounded_Price_Total,
    SUM(freight_value) AS Original_Freight_Total,
    SUM(CAST(ROUND(freight_value, 2) AS DECIMAL(12,2))) AS Rounded_Freight_Total
FROM dbo.olist_order_items_dataset;

SELECT
    order_item_id,
    COUNT(*) AS Item_Record_Count
FROM dbo.olist_order_items_dataset
GROUP BY order_item_id
ORDER BY order_item_id;

SELECT
    order_id,
    COUNT(*) AS Total_Items,
    MIN(order_item_id) AS First_Item,
    MAX(order_item_id) AS Last_Item
FROM dbo.olist_order_items_dataset
GROUP BY order_id
HAVING
    MIN(order_item_id) <> 1
    OR MAX(order_item_id) <> COUNT(*);

    SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    CAST(ROUND(price, 2) AS DECIMAL(12,2)) AS price,
    CAST(ROUND(freight_value, 2) AS DECIMAL(12,2)) AS freight_value,
    CASE
        WHEN freight_value = 0 THEN 1
        ELSE 0
    END AS Flag_Zero_Freight
INTO dbo.order_items_cleaned
FROM dbo.olist_order_items_dataset;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_order_items_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.order_items_cleaned) AS Cleaned_Records;

     SELECT
    COUNT(*) AS Total_Records,
    SUM(Flag_Zero_Freight) AS Flagged_Zero_Freight,
    SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS Actual_Zero_Freight
FROM dbo.order_items_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'order_items_cleaned'
ORDER BY ORDINAL_POSITION;

SELECT
    SUM(CAST(ROUND(price, 2) AS DECIMAL(18,2))) AS Expected_Price_Total,
    SUM(price) AS Cleaned_Price_Total,
    SUM(CAST(ROUND(freight_value, 2) AS DECIMAL(18,2))) AS Expected_Freight_Total,
    SUM(freight_value) AS Cleaned_Freight_Total
FROM dbo.order_items_cleaned;