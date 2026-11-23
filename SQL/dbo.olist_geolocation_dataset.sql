SELECT COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_geolocation_dataset'
ORDER BY ORDINAL_POSITION;

SELECT TOP 10 *
FROM dbo.olist_geolocation_dataset;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS Unique_ZIP_Prefixes
FROM dbo.olist_geolocation_dataset;

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Duplicate_Count
FROM dbo.olist_geolocation_dataset
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

SELECT COUNT(*) AS Duplicate_Groups
FROM (
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    FROM dbo.olist_geolocation_dataset
    GROUP BY
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    HAVING COUNT(*) > 1
) AS Duplicates;

WITH DuplicateGroups AS
(
    SELECT COUNT(*) AS Occurrences
    FROM dbo.olist_geolocation_dataset
    GROUP BY
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    HAVING COUNT(*) > 1
)
SELECT
    COUNT(*) AS Duplicate_Groups,
    SUM(Occurrences - 1) AS Excess_Duplicate_Rows
FROM DuplicateGroups;

SELECT TOP 10
    geolocation_zip_code_prefix,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1
ORDER BY Total_Records DESC;

SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(
        geolocation_lat, '|', geolocation_lng
    )) AS Unique_Coordinates
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 24220
GROUP BY geolocation_zip_code_prefix;

SELECT
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(
        geolocation_lat, '|', geolocation_lng
    )) AS Unique_Coordinates
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 24220
GROUP BY
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;


SELECT
    COUNT(*) AS Total_City_State_Combinations,
    COUNT(DISTINCT geolocation_city) AS Unique_City_Names,
    COUNT(DISTINCT geolocation_state) AS Unique_States
FROM dbo.olist_geolocation_dataset;




SELECT
    SUM(CASE WHEN geolocation_city IS NULL OR geolocation_city = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN geolocation_state IS NULL OR geolocation_state = '' THEN 1 ELSE 0 END) AS Missing_State
FROM dbo.olist_geolocation_dataset;

SELECT
    SUM(CASE
        WHEN geolocation_lat IS NULL
          OR geolocation_lat NOT BETWEEN -90 AND 90
        THEN 1 ELSE 0
    END) AS Invalid_Latitude,

    SUM(CASE
        WHEN geolocation_lng IS NULL
          OR geolocation_lng NOT BETWEEN -180 AND 180
        THEN 1 ELSE 0
    END) AS Invalid_Longitude
FROM dbo.olist_geolocation_dataset;

SELECT
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS Null_Latitude,
    SUM(CASE WHEN geolocation_lat < -90 OR geolocation_lat > 90 THEN 1 ELSE 0 END) AS Out_Of_Range_Latitude,

    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS Null_Longitude,
    SUM(CASE WHEN geolocation_lng < -180 OR geolocation_lng > 180 THEN 1 ELSE 0 END) AS Out_Of_Range_Longitude
FROM dbo.olist_geolocation_dataset;

SELECT TOP 10
    geolocation_zip_code_prefix,
    COUNT(*) AS Missing_Coordinate_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat IS NULL
   OR geolocation_lng IS NULL
GROUP BY geolocation_zip_code_prefix
ORDER BY Missing_Coordinate_Records DESC;


SELECT
    geolocation_state,
    COUNT(*) AS Missing_Coordinate_Records,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS Affected_ZIP_Prefixes
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat IS NULL
   OR geolocation_lng IS NULL
GROUP BY geolocation_state
ORDER BY Missing_Coordinate_Records DESC;

SELECT
    geolocation_state,
    geolocation_city,
    COUNT(*) AS Missing_Coordinate_Records,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS Affected_ZIP_Prefixes
FROM dbo.olist_geolocation_dataset
WHERE (geolocation_lat IS NULL OR geolocation_lng IS NULL)
  AND geolocation_state IN ('AP', 'RR')
GROUP BY
    geolocation_state,
    geolocation_city
ORDER BY Missing_Coordinate_Records DESC;

SELECT TOP 10
    geolocation_lat,
    geolocation_lng,
    COUNT(DISTINCT geolocation_city) AS Different_City_Names,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat IS NOT NULL
  AND geolocation_lng IS NOT NULL
GROUP BY
    geolocation_lat,
    geolocation_lng
HAVING COUNT(DISTINCT geolocation_city) > 1
ORDER BY Different_City_Names DESC, Total_Records DESC;

SELECT
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat = -31.6669406890869
  AND geolocation_lng = -54.0708312988281
GROUP BY
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;

SELECT TOP 10 *
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat = -31.6669406890869
  AND geolocation_lng = -54.0708312988281;

  SELECT
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_lat BETWEEN -31.666941 AND -31.666940
  AND geolocation_lng BETWEEN -54.070832 AND -54.070831
GROUP BY
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;

SELECT
    SUM(CASE
        WHEN geolocation_zip_code_prefix IS NULL THEN 1
        ELSE 0
    END) AS Missing_ZIP_Prefix
FROM dbo.olist_geolocation_dataset;

SELECT
    SUM(CASE
        WHEN LEN(CAST(geolocation_zip_code_prefix AS VARCHAR(10))) < 5
        THEN 1 ELSE 0
    END) AS ZIP_Prefixes_With_Fewer_Than_5_Digits
FROM dbo.olist_geolocation_dataset;

SELECT
    MIN(geolocation_zip_code_prefix) AS Minimum_ZIP,
    MAX(geolocation_zip_code_prefix) AS Maximum_ZIP
FROM dbo.olist_geolocation_dataset;

SELECT COUNT(*) AS Invalid_ZIP_Prefixes
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix < 0
   OR geolocation_zip_code_prefix > 99999;

   SELECT TOP 10
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    COUNT(DISTINCT geolocation_city) AS Different_Cities,
    COUNT(DISTINCT geolocation_state) AS Different_States,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng
HAVING COUNT(DISTINCT geolocation_city) > 1
    OR COUNT(DISTINCT geolocation_state) > 1
ORDER BY Different_States DESC, Different_Cities DESC, Total_Records DESC;

SELECT
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 4011
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 4011
  AND geolocation_state = 'AC';

  SELECT
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 23056
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 23056
  AND geolocation_state = 'AC';

  SELECT
    geolocation_city,
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix = 71901
GROUP BY
    geolocation_city,
    geolocation_state
ORDER BY Total_Records DESC;

SELECT
    geolocation_state,
    COUNT(*) AS Total_Records
FROM dbo.olist_geolocation_dataset
GROUP BY geolocation_state
ORDER BY Total_Records DESC;

SELECT
    MAX(LEN(CAST(geolocation_zip_code_prefix AS VARCHAR(10))))
        AS Maximum_ZIP_Length
FROM dbo.olist_geolocation_dataset;

WITH RankedGeolocation AS
(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                geolocation_zip_code_prefix,
                geolocation_lat,
                geolocation_lng,
                geolocation_city,
                geolocation_state
            ORDER BY
                geolocation_zip_code_prefix
        ) AS Row_Num
    FROM dbo.olist_geolocation_dataset
)
SELECT COUNT(*) AS Duplicate_Rows_To_Remove
FROM RankedGeolocation
WHERE Row_Num > 1;



WITH RankedGeolocation AS
(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                geolocation_zip_code_prefix,
                geolocation_lat,
                geolocation_lng,
                geolocation_city,
                geolocation_state
            ORDER BY geolocation_zip_code_prefix
        ) AS Row_Num
    FROM dbo.olist_geolocation_dataset
)
SELECT
    RIGHT(
        '00000' + CAST(geolocation_zip_code_prefix AS VARCHAR(5)),
        5
    ) AS geolocation_zip_code_prefix,

    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,

    CASE
        WHEN geolocation_lat IS NULL THEN 1
        ELSE 0
    END AS Flag_Missing_Latitude,

    CASE
        WHEN geolocation_lng IS NULL THEN 1
        ELSE 0
    END AS Flag_Missing_Longitude,

    CASE
        WHEN geolocation_zip_code_prefix = 4011
             AND geolocation_state = 'AC'
        THEN 1

        WHEN geolocation_zip_code_prefix = 23056
             AND geolocation_state = 'AC'
        THEN 1

        ELSE 0
    END AS Flag_Potential_State_Mismatch

INTO dbo.geolocation_cleaned
FROM RankedGeolocation
WHERE Row_Num = 1;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_geolocation_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.geolocation_cleaned) AS Cleaned_Records;

     SELECT COUNT(*) AS Remaining_Duplicate_Groups
FROM
(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    FROM dbo.geolocation_cleaned
    GROUP BY
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    HAVING COUNT(*) > 1
) AS Duplicates;


SELECT COUNT(*) AS Remaining_Duplicate_Groups
FROM
(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    FROM dbo.geolocation_cleaned
    GROUP BY
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    HAVING COUNT(*) > 1
) AS Duplicates;

SELECT
    SUM(Flag_Missing_Latitude) AS Missing_Latitude,
    SUM(Flag_Missing_Longitude) AS Missing_Longitude,
    SUM(Flag_Potential_State_Mismatch) AS Potential_State_Mismatches
FROM dbo.geolocation_cleaned;

SELECT
    COUNT(*) AS Total_Records,
    SUM(
        CASE
            WHEN LEN(geolocation_zip_code_prefix) <> 5
            THEN 1 ELSE 0
        END
    ) AS Invalid_ZIP_Length
FROM dbo.geolocation_cleaned;


SELECT
    SUM(CASE
        WHEN geolocation_lat < -90
          OR geolocation_lat > 90
        THEN 1 ELSE 0
    END) AS Invalid_Latitude,

    SUM(CASE
        WHEN geolocation_lng < -180
          OR geolocation_lng > 180
        THEN 1 ELSE 0
    END) AS Invalid_Longitude

FROM dbo.geolocation_cleaned;

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    Flag_Potential_State_Mismatch
FROM dbo.geolocation_cleaned
WHERE Flag_Potential_State_Mismatch = 1;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_geolocation_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.geolocation_cleaned) AS Cleaned_Records,

    (SELECT COUNT(DISTINCT geolocation_zip_code_prefix)
     FROM dbo.geolocation_cleaned) AS Unique_ZIP_Prefixes;

