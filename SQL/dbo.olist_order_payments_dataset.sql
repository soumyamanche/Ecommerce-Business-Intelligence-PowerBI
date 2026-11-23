SELECT
    COUNT(*) AS Total_Payment_Records
FROM dbo.olist_order_payments_dataset;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS Missing_Sequence,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Type,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS Missing_Installments,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Value
FROM dbo.olist_order_payments_dataset;

SELECT
    COUNT(*) AS Duplicate_Payment_Groups
FROM (
    SELECT
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    FROM dbo.olist_order_payments_dataset
    GROUP BY
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    HAVING COUNT(*) > 1
) AS DuplicateRecords;

SELECT
    COUNT(*) AS Blank_Order_IDs
FROM dbo.olist_order_payments_dataset
WHERE LTRIM(RTRIM(order_id)) = '';

SELECT
    payment_type,
    COUNT(*) AS Payment_Records,
    SUM(payment_value) AS Total_Payment_Value
FROM dbo.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY Payment_Records DESC;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN payment_value = 0 THEN 1 ELSE 0 END) AS Zero_Payments,
    SUM(CASE WHEN payment_value < 0 THEN 1 ELSE 0 END) AS Negative_Payments,
    MIN(payment_value) AS Minimum_Payment,
    MAX(payment_value) AS Maximum_Payment
FROM dbo.olist_order_payments_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN payment_installments = 0 THEN 1 ELSE 0 END) AS Zero_Installments,
    SUM(CASE WHEN payment_installments < 0 THEN 1 ELSE 0 END) AS Negative_Installments,
    MIN(payment_installments) AS Minimum_Installments,
    MAX(payment_installments) AS Maximum_Installments
FROM dbo.olist_order_payments_dataset;

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM dbo.olist_order_payments_dataset
WHERE payment_installments = 0;

SELECT
    payment_installments,
    COUNT(*) AS Payment_Records,
    SUM(payment_value) AS Total_Payment_Value
FROM dbo.olist_order_payments_dataset
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;

SELECT
    COUNT(*) AS Total_Payment_Records,
    COUNT(DISTINCT order_id) AS Unique_Orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS Additional_Payment_Records
FROM dbo.olist_order_payments_dataset;

SELECT
    COUNT(*) AS Orders_With_Multiple_Payments
FROM (
    SELECT
        order_id
    FROM dbo.olist_order_payments_dataset
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS MultiplePayments;

SELECT
    Payment_Record_Count,
    COUNT(*) AS Number_Of_Orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS Payment_Record_Count
    FROM dbo.olist_order_payments_dataset
    GROUP BY order_id
) AS PaymentSummary
GROUP BY Payment_Record_Count
ORDER BY Payment_Record_Count;

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM dbo.olist_order_payments_dataset
WHERE order_id = 'fa65dad1b0e818e3ccc5cb0e39231352'
ORDER BY payment_sequential;

SELECT
    COUNT(*) AS Duplicate_Sequence_Groups
FROM (
    SELECT
        order_id,
        payment_sequential
    FROM dbo.olist_order_payments_dataset
    GROUP BY
        order_id,
        payment_sequential
    HAVING COUNT(*) > 1
) AS SequenceCheck;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_order_payments_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS Total_Records,
    SUM(
        CASE
            WHEN payment_value <> ROUND(payment_value, 2)
            THEN 1 ELSE 0
        END
    ) AS Values_With_More_Than_2_Decimals
FROM dbo.olist_order_payments_dataset;

SELECT
    SUM(payment_value) AS Original_Total,
    SUM(CAST(ROUND(payment_value, 2) AS DECIMAL(18,2))) AS Rounded_Total
FROM dbo.olist_order_payments_dataset;

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,

    CAST(ROUND(payment_value, 2) AS DECIMAL(12,2)) AS payment_value,

    CASE
        WHEN payment_value = 0 THEN 1
        ELSE 0
    END AS Flag_Zero_Payment_Value,

    CASE
        WHEN payment_installments = 0 THEN 1
        ELSE 0
    END AS Flag_Zero_Installments,

    CASE
        WHEN payment_type = 'not_defined' THEN 1
        ELSE 0
    END AS Flag_Undefined_Payment_Type

INTO dbo.order_payments_cleaned

FROM dbo.olist_order_payments_dataset;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_order_payments_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.order_payments_cleaned) AS Cleaned_Records;

     SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT order_id) AS Unique_Orders,
    COUNT(*) -
        COUNT(DISTINCT CONCAT(order_id, '-', payment_sequential))
        AS Duplicate_Payment_Keys
FROM dbo.order_payments_cleaned;


SELECT
    SUM(Flag_Zero_Payment_Value) AS Zero_Value_Flags,
    SUM(Flag_Zero_Installments) AS Zero_Installment_Flags,
    SUM(Flag_Undefined_Payment_Type) AS Undefined_Type_Flags
FROM dbo.order_payments_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_payments_cleaned';

SELECT
    SUM(CAST(ROUND(payment_value, 2) AS DECIMAL(18,2)))
        AS Original_Rounded_Total,

    (SELECT SUM(payment_value)
     FROM dbo.order_payments_cleaned)
        AS Cleaned_Total

FROM dbo.olist_order_payments_dataset;

SELECT
    SUM(CAST(ROUND(price, 2) AS DECIMAL(18,2))) AS Expected_Price_Total,
    SUM(price) AS Cleaned_Price_Total,
    SUM(CAST(ROUND(freight_value, 2) AS DECIMAL(18,2))) AS Expected_Freight_Total,
    SUM(freight_value) AS Cleaned_Freight_Total
FROM dbo.order_items_cleaned;