SELECT COUNT(*) AS Total_Records
FROM dbo.product_category_name_translation;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'product_category_name_translation'
ORDER BY ORDINAL_POSITION;

SELECT TOP 10
    column1,
    column2
FROM dbo.product_category_name_translation;
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN column1 IS NULL THEN 1 ELSE 0 END) AS Missing_Portuguese,
    SUM(CASE WHEN column2 IS NULL THEN 1 ELSE 0 END) AS Missing_English,
    SUM(CASE WHEN LTRIM(RTRIM(column1)) = '' THEN 1 ELSE 0 END) AS Blank_Portuguese,
    SUM(CASE WHEN LTRIM(RTRIM(column2)) = '' THEN 1 ELSE 0 END) AS Blank_English
FROM dbo.product_category_name_translation;

SELECT
    'Portuguese Category' AS Check_Type,
    COUNT(*) AS Duplicate_Groups
FROM (
    SELECT column1
    FROM dbo.product_category_name_translation
    GROUP BY column1
    HAVING COUNT(*) > 1
) AS P

UNION ALL

SELECT
    'English Category',
    COUNT(*)
FROM (
    SELECT column2
    FROM dbo.product_category_name_translation
    GROUP BY column2
    HAVING COUNT(*) > 1
) AS E;

SELECT
    COUNT(DISTINCT p.product_category_name) AS Product_Categories,
    COUNT(DISTINCT t.column1) AS Matched_Categories
FROM dbo.products_cleaned p
LEFT JOIN dbo.product_category_name_translation t
    ON p.product_category_name = t.column1
WHERE p.product_category_name IS NOT NULL;

SELECT DISTINCT
    p.product_category_name
FROM dbo.products_cleaned p
LEFT JOIN dbo.product_category_name_translation t
    ON p.product_category_name = t.column1
WHERE p.product_category_name IS NOT NULL
  AND t.column1 IS NULL
ORDER BY p.product_category_name;


SELECT
    product_category_name,
    COUNT(*) AS Product_Count
FROM dbo.products_cleaned
WHERE product_category_name IN (
    'pc_gamer',
    'portateis_cozinha_e_preparadores_de_alimentos'
)
GROUP BY product_category_name;

INSERT INTO dbo.product_category_name_translation
    (column1, column2)
VALUES
    ('pc_gamer', 'gaming_pc'),
    ('portateis_cozinha_e_preparadores_de_alimentos',
     'portable_kitchen_food_processors');

     SELECT
    COUNT(DISTINCT p.product_category_name) AS Product_Categories,
    COUNT(DISTINCT t.column1) AS Matched_Categories
FROM dbo.products_cleaned p
LEFT JOIN dbo.product_category_name_translation t
    ON p.product_category_name = t.column1
WHERE p.product_category_name IS NOT NULL;

SELECT
    column1 AS product_category_name,
    column2 AS product_category_name_english
INTO dbo.product_category_translation_cleaned
FROM dbo.product_category_name_translation;

SELECT
    (SELECT COUNT(*)
     FROM dbo.product_category_name_translation) AS Source_Rows,

    (SELECT COUNT(*)
     FROM dbo.product_category_translation_cleaned) AS Cleaned_Rows;


     SELECT
    column1 AS Portuguese_Category,
    COUNT(*) AS Record_Count
FROM dbo.product_category_name_translation
GROUP BY column1
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;

SELECT
    column1,
    column2,
    COUNT(*) AS Record_Count
FROM dbo.product_category_name_translation
WHERE column1 IN (
    'pc_gamer',
    'portateis_cozinha_e_preparadores_de_alimentos'
)
GROUP BY column1, column2;

DROP TABLE dbo.product_category_translation_cleaned;

SELECT DISTINCT
    column1 AS product_category_name,
    column2 AS product_category_name_english
INTO dbo.product_category_translation_cleaned
FROM dbo.product_category_name_translation;

DROP TABLE dbo.product_category_translation_cleaned;

SELECT DISTINCT
    column1 AS product_category_name,
    column2 AS product_category_name_english
INTO dbo.product_category_translation_cleaned
FROM dbo.product_category_name_translation;

SELECT COUNT(*) AS Cleaned_Records
FROM dbo.product_category_translation_cleaned;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT product_category_name) AS Unique_Portuguese,
    COUNT(DISTINCT product_category_name_english) AS Unique_English,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS Missing_Portuguese,
    SUM(CASE WHEN product_category_name_english IS NULL THEN 1 ELSE 0 END) AS Missing_English
FROM dbo.product_category_translation_cleaned;