USE Ecommerce_Analytics;
GO

SELECT
    COUNT(*) AS Total_Order_Records
FROM dbo.olist_orders_dataset;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_orders_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE WHEN order_id IS NULL
        THEN 1 ELSE 0 END) AS Missing_Order_ID,

    SUM(CASE WHEN customer_id IS NULL
        THEN 1 ELSE 0 END) AS Missing_Customer_ID,

    SUM(CASE WHEN order_status IS NULL
        THEN 1 ELSE 0 END) AS Missing_Order_Status,

    SUM(CASE WHEN order_purchase_timestamp IS NULL
        THEN 1 ELSE 0 END) AS Missing_Purchase_Timestamp,

    SUM(CASE WHEN order_approved_at IS NULL
        THEN 1 ELSE 0 END) AS Missing_Approval_Timestamp,

    SUM(CASE WHEN order_delivered_carrier_date IS NULL
        THEN 1 ELSE 0 END) AS Missing_Carrier_Timestamp,

    SUM(CASE WHEN order_delivered_customer_date IS NULL
        THEN 1 ELSE 0 END) AS Missing_Delivery_Timestamp,

    SUM(CASE WHEN order_estimated_delivery_date IS NULL
        THEN 1 ELSE 0 END) AS Missing_Estimated_Delivery

FROM dbo.olist_orders_dataset;

SELECT
    order_status,
    COUNT(*) AS Total_Orders,

    SUM(CASE WHEN order_approved_at IS NULL
        THEN 1 ELSE 0 END) AS Missing_Approval,

    SUM(CASE WHEN order_delivered_carrier_date IS NULL
        THEN 1 ELSE 0 END) AS Missing_Carrier_Date,

    SUM(CASE WHEN order_delivered_customer_date IS NULL
        THEN 1 ELSE 0 END) AS Missing_Delivery_Date

FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY Total_Orders DESC;

SELECT
    order_id,
    COUNT(*) AS Duplicate_Count
FROM dbo.olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT
    COUNT(*) AS Total_Records,
    COUNT(order_id) AS Available_Order_IDs,
    COUNT(DISTINCT order_id) AS Unique_Order_IDs,

    SUM(CASE WHEN order_id IS NULL
        THEN 1 ELSE 0 END) AS Missing_Order_IDs

FROM dbo.olist_orders_dataset;

SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY Total_Orders DESC;

SELECT
    COUNT(*) AS Blank_Order_Status
FROM dbo.olist_orders_dataset
WHERE LTRIM(RTRIM(order_status)) = '';

SELECT
    MIN(order_purchase_timestamp) AS First_Order_Date,
    MAX(order_purchase_timestamp) AS Latest_Order_Date,
    COUNT(*) AS Total_Orders
FROM dbo.olist_orders_dataset;

SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(*) AS Total_Orders
FROM dbo.olist_orders_dataset
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;

SELECT
    COUNT(*) AS Future_Purchase_Dates
FROM dbo.olist_orders_dataset
WHERE order_purchase_timestamp > GETDATE();

SELECT
    COUNT(*) AS Invalid_Approval_Timestamps
FROM dbo.olist_orders_dataset
WHERE order_approved_at < order_purchase_timestamp;

SELECT
    COUNT(*) AS Invalid_Carrier_Timestamps
FROM dbo.olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

  SELECT TOP 10
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date
FROM dbo.olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
ORDER BY order_approved_at;

SELECT
    order_status,
    COUNT(*) AS Invalid_Carrier_Timestamps
FROM dbo.olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
GROUP BY order_status
ORDER BY Invalid_Carrier_Timestamps DESC;

SELECT
    COUNT(*) AS Invalid_Delivery_Timestamps
FROM dbo.olist_orders_dataset
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

  SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM dbo.olist_orders_dataset
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

  SELECT
    CASE
        WHEN order_delivered_customer_date
             > order_estimated_delivery_date
            THEN 'Late Delivery'

        WHEN order_delivered_customer_date
             < order_estimated_delivery_date
            THEN 'Early Delivery'

        ELSE 'On-Time Delivery'
    END AS Delivery_Performance,

    COUNT(*) AS Total_Orders

FROM dbo.olist_orders_dataset

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY
    CASE
        WHEN order_delivered_customer_date
             > order_estimated_delivery_date
            THEN 'Late Delivery'
        WHEN order_delivered_customer_date
             < order_estimated_delivery_date
            THEN 'Early Delivery'
        ELSE 'On-Time Delivery'
    END

ORDER BY Total_Orders DESC;

SELECT
    COUNT(*) AS Invalid_Estimated_Delivery_Dates
FROM dbo.olist_orders_dataset
WHERE order_estimated_delivery_date < order_purchase_timestamp;

SELECT
    order_id,
    order_status,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM dbo.olist_orders_dataset
WHERE order_status = 'delivered'
  AND (
      order_approved_at IS NULL
      OR order_delivered_carrier_date IS NULL
      OR order_delivered_customer_date IS NULL
  );

  SELECT
    COUNT(*) AS Invalid_Purchase_Delivery_Dates
FROM dbo.olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

  SELECT
    COUNT(*) AS Blank_ID_Records
FROM dbo.olist_orders_dataset
WHERE LTRIM(RTRIM(order_id)) = ''
   OR LTRIM(RTRIM(customer_id)) = '';

   SELECT
    *,
    CASE
        WHEN order_status = 'delivered'
         AND order_approved_at IS NULL THEN 1
        ELSE 0
    END AS Flag_Delivered_Missing_Approval,

    CASE
        WHEN order_status = 'delivered'
         AND order_delivered_carrier_date IS NULL THEN 1
        ELSE 0
    END AS Flag_Delivered_Missing_Carrier,

    CASE
        WHEN order_status = 'delivered'
         AND order_delivered_customer_date IS NULL THEN 1
        ELSE 0
    END AS Flag_Delivered_Missing_Delivery,

    CASE
        WHEN order_delivered_carrier_date < order_approved_at
        THEN 1 ELSE 0
    END AS Flag_Carrier_Before_Approval,

    CASE
        WHEN order_delivered_customer_date < order_delivered_carrier_date
        THEN 1 ELSE 0
    END AS Flag_Delivery_Before_Carrier

INTO dbo.orders_cleaned
FROM dbo.olist_orders_dataset;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_orders_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.orders_cleaned) AS Cleaned_Records;

     SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT order_id) AS Unique_Order_IDs,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Missing_Order_IDs
FROM dbo.orders_cleaned;

SELECT
    SUM(Flag_Delivered_Missing_Approval) AS Missing_Approval,
    SUM(Flag_Delivered_Missing_Carrier) AS Missing_Carrier,
    SUM(Flag_Delivered_Missing_Delivery) AS Missing_Delivery,
    SUM(Flag_Carrier_Before_Approval) AS Carrier_Before_Approval,
    SUM(Flag_Delivery_Before_Carrier) AS Delivery_Before_Carrier
FROM dbo.orders_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders_cleaned'
ORDER BY ORDINAL_POSITION;