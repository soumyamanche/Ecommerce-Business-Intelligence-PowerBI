SELECT
    COUNT(*) AS Total_Product_Records
FROM dbo.olist_products_dataset;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT product_id) AS Unique_Products
FROM dbo.olist_products_dataset;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Missing_Product_ID,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS Missing_Category,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS Missing_Name_Length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS Missing_Description_Length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS Missing_Photo_Count,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS Missing_Weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Width
FROM dbo.olist_products_dataset;



SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE
        WHEN product_category_name IS NULL
         AND product_name_lenght IS NULL
         AND product_description_lenght IS NULL
         AND product_photos_qty IS NULL
         AND product_weight_g IS NULL
        THEN 1 ELSE 0
    END) AS All_Five_Attributes_Missing,

    SUM(CASE
        WHEN product_length_cm IS NULL
          OR product_height_cm IS NULL
          OR product_width_cm IS NULL
          OR product_weight_g IS NULL
        THEN 1 ELSE 0
    END) AS Missing_Physical_Details
FROM dbo.olist_products_dataset;


SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM dbo.olist_products_dataset
WHERE product_category_name IS NULL
   OR product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL
   OR product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

   WITH Missing_Patterns AS
(
    SELECT
        CONCAT(
            CASE WHEN product_category_name IS NULL THEN 'Category, ' ELSE '' END,
            CASE WHEN product_name_lenght IS NULL THEN 'Name Length, ' ELSE '' END,
            CASE WHEN product_description_lenght IS NULL THEN 'Description Length, ' ELSE '' END,
            CASE WHEN product_photos_qty IS NULL THEN 'Photo Count, ' ELSE '' END,
            CASE WHEN product_weight_g IS NULL THEN 'Weight, ' ELSE '' END,
            CASE WHEN product_length_cm IS NULL THEN 'Length, ' ELSE '' END,
            CASE WHEN product_height_cm IS NULL THEN 'Height, ' ELSE '' END,
            CASE WHEN product_width_cm IS NULL THEN 'Width, ' ELSE '' END
        ) AS Missing_Attributes
    FROM dbo.olist_products_dataset
)
SELECT
    Missing_Attributes,
    COUNT(*) AS Affected_Products
FROM Missing_Patterns
GROUP BY Missing_Attributes
ORDER BY Affected_Products DESC;

SELECT
    SUM(CASE WHEN product_weight_g = 0 THEN 1 ELSE 0 END) AS Zero_Weight,
    SUM(CASE WHEN product_weight_g < 0 THEN 1 ELSE 0 END) AS Negative_Weight,
    SUM(CASE WHEN product_length_cm = 0 THEN 1 ELSE 0 END) AS Zero_Length,
    SUM(CASE WHEN product_height_cm = 0 THEN 1 ELSE 0 END) AS Zero_Height,
    SUM(CASE WHEN product_width_cm = 0 THEN 1 ELSE 0 END) AS Zero_Width
FROM dbo.olist_products_dataset;

SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM dbo.olist_products_dataset
WHERE product_weight_g = 0;

SELECT
    COALESCE(product_category_name, 'Unknown') AS Product_Category,
    COUNT(*) AS Product_Count
FROM dbo.olist_products_dataset
WHERE product_weight_g = 0
GROUP BY product_category_name
ORDER BY Product_Count DESC;

SELECT
    COUNT(*) AS Total_Products,
    SUM(CASE WHEN product_weight_g <> ROUND(product_weight_g, 0) THEN 1 ELSE 0 END) AS Decimal_Weights,
    SUM(CASE WHEN product_length_cm <> ROUND(product_length_cm, 0) THEN 1 ELSE 0 END) AS Decimal_Lengths,
    SUM(CASE WHEN product_height_cm <> ROUND(product_height_cm, 0) THEN 1 ELSE 0 END) AS Decimal_Heights,
    SUM(CASE WHEN product_width_cm <> ROUND(product_width_cm, 0) THEN 1 ELSE 0 END) AS Decimal_Widths
FROM dbo.olist_products_dataset;

SELECT
    MIN(product_weight_g) AS Min_Weight,
    MAX(product_weight_g) AS Max_Weight,
    MIN(product_length_cm) AS Min_Length,
    MAX(product_length_cm) AS Max_Length,
    MIN(product_height_cm) AS Min_Height,
    MAX(product_height_cm) AS Max_Height,
    MIN(product_width_cm) AS Min_Width,
    MAX(product_width_cm) AS Max_Width
FROM dbo.olist_products_dataset;

SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM dbo.olist_products_dataset
WHERE product_weight_g > 30000
   OR product_length_cm > 100
   OR product_height_cm > 100
   OR product_width_cm > 100;

   SELECT
    COUNT(DISTINCT p.product_id) AS Products_In_Catalogue,
    COUNT(DISTINCT oi.product_id) AS Products_Ordered
FROM dbo.olist_products_dataset p
LEFT JOIN dbo.order_items_cleaned oi
    ON p.product_id = oi.product_id
WHERE p.product_weight_g > 30000
   OR p.product_length_cm > 100
   OR p.product_height_cm > 100
   OR p.product_width_cm > 100;

   SELECT
    COUNT(*) AS Total_Products,
    SUM(CASE
        WHEN product_id <> LTRIM(RTRIM(product_id))
        THEN 1 ELSE 0
    END) AS Product_IDs_With_Extra_Spaces
FROM dbo.olist_products_dataset;

SELECT
    COALESCE(NULLIF(LTRIM(RTRIM(product_category_name)), ''), 'Missing') AS Product_Category,
    COUNT(*) AS Product_Count
FROM dbo.olist_products_dataset
GROUP BY
    COALESCE(NULLIF(LTRIM(RTRIM(product_category_name)), ''), 'Missing')
ORDER BY Product_Count DESC;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%category%';

SELECT
    SUM(CASE WHEN product_name_lenght = 0 THEN 1 ELSE 0 END) AS Zero_Name_Length,
    SUM(CASE WHEN product_name_lenght < 0 THEN 1 ELSE 0 END) AS Negative_Name_Length,
    SUM(CASE WHEN product_description_lenght = 0 THEN 1 ELSE 0 END) AS Zero_Description_Length,
    SUM(CASE WHEN product_description_lenght < 0 THEN 1 ELSE 0 END) AS Negative_Description_Length
FROM dbo.olist_products_dataset;

SELECT
    SUM(CASE WHEN product_photos_qty = 0 THEN 1 ELSE 0 END) AS Zero_Photo_Count,
    SUM(CASE WHEN product_photos_qty < 0 THEN 1 ELSE 0 END) AS Negative_Photo_Count
FROM dbo.olist_products_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_products_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    CASE
        WHEN product_weight_g = 0 THEN 1
        ELSE 0
    END AS Flag_Zero_Weight
INTO dbo.products_cleaned
FROM dbo.olist_products_dataset;

SELECT
    (SELECT COUNT(*) FROM dbo.olist_products_dataset) AS Original_Count,
    (SELECT COUNT(*) FROM dbo.products_cleaned) AS Cleaned_Count;

    SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT product_id) AS Unique_Product_IDs,
    COUNT(*) - COUNT(DISTINCT product_id) AS Duplicate_ID_Count
FROM dbo.products_cleaned;

SELECT
    SUM(Flag_Zero_Weight) AS Flagged_Zero_Weight,
    SUM(CASE WHEN product_weight_g = 0 THEN 1 ELSE 0 END) AS Actual_Zero_Weight
FROM dbo.products_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products_cleaned'
ORDER BY ORDINAL_POSITION;

SELECT
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS Missing_Category,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS Missing_Name_Length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS Missing_Description_Length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS Missing_Photos,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS Missing_Weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Width
FROM dbo.products_cleaned;