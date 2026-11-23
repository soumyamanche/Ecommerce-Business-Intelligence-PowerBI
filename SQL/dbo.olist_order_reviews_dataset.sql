SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;

SELECT
    COUNT(*) AS Total_Review_Records
FROM dbo.olist_order_reviews_dataset;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_order_reviews_dataset'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS Total_Records,

    COUNT(DISTINCT review_id) AS Unique_Review_IDs,

    COUNT(DISTINCT order_id) AS Unique_Orders,

    COUNT(*) - COUNT(DISTINCT review_id)
        AS Duplicate_Review_ID_Records

FROM dbo.olist_order_reviews_dataset;

SELECT TOP 10
    review_id,
    COUNT(*) AS Occurrences
FROM dbo.olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM dbo.olist_order_reviews_dataset
WHERE review_id IN
(
    SELECT TOP 5 review_id
    FROM dbo.olist_order_reviews_dataset
    GROUP BY review_id
    HAVING COUNT(*) > 1
    ORDER BY COUNT(*) DESC
)
ORDER BY review_id;

SELECT COUNT(*) AS Duplicate_Review_Order_Groups
FROM
(
    SELECT
        review_id,
        order_id
    FROM dbo.olist_order_reviews_dataset
    GROUP BY
        review_id,
        order_id
    HAVING COUNT(*) > 1
) AS DuplicateGroups;


SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END)
        AS Missing_Review_ID,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        AS Missing_Order_ID,

    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END)
        AS Missing_Review_Score,

    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END)
        AS Missing_Review_Title,

    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END)
        AS Missing_Review_Message,

    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END)
        AS Missing_Creation_Date,

    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END)
        AS Missing_Answer_Timestamp

FROM dbo.olist_order_reviews_dataset;

SELECT
    review_score,
    COUNT(*) AS Review_Count,
    CAST(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM dbo.olist_order_reviews_dataset)
        AS DECIMAL(5,2)
    ) AS Percentage
FROM dbo.olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

SELECT
    MIN(review_creation_date) AS Earliest_Review_Date,
    MAX(review_creation_date) AS Latest_Review_Date,
    MIN(review_answer_timestamp) AS Earliest_Answer_Date,
    MAX(review_answer_timestamp) AS Latest_Answer_Date
FROM dbo.olist_order_reviews_dataset;


SELECT
    MIN(review_score) AS Minimum_Score,
    MAX(review_score) AS Maximum_Score,

    SUM(CASE
        WHEN review_score < 1 OR review_score > 5
        THEN 1 ELSE 0
    END) AS Invalid_Score_Records

FROM dbo.olist_order_reviews_dataset;


SELECT
    COUNT(*) AS Total_Records,

    SUM(
        CASE
            WHEN review_answer_timestamp < review_creation_date
            THEN 1 ELSE 0
        END
    ) AS Answer_Before_Review,

    SUM(
        CASE
            WHEN review_answer_timestamp = review_creation_date
            THEN 1 ELSE 0
        END
    ) AS Same_Timestamp

FROM dbo.olist_order_reviews_dataset;

SELECT
    MIN(DATEDIFF(
        MINUTE,
        review_creation_date,
        review_answer_timestamp
    )) AS Minimum_Response_Minutes,

    MAX(DATEDIFF(
        MINUTE,
        review_creation_date,
        review_answer_timestamp
    )) AS Maximum_Response_Minutes,

    AVG(CAST(DATEDIFF(
        MINUTE,
        review_creation_date,
        review_answer_timestamp
    ) AS BIGINT)) AS Average_Response_Minutes

FROM dbo.olist_order_reviews_dataset;

SELECT
    CASE
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 1
            THEN 'Within 1 day'

        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 3
            THEN '1-3 days'

        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 7
            THEN '4-7 days'

        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 30
            THEN '8-30 days'

        ELSE 'Over 30 days'
    END AS Response_Time_Category,

    COUNT(*) AS Review_Count

FROM dbo.olist_order_reviews_dataset

GROUP BY
    CASE
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 1
            THEN 'Within 1 day'
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 3
            THEN '1-3 days'
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 7
            THEN '4-7 days'
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) <= 30
            THEN '8-30 days'
        ELSE 'Over 30 days'
    END
ORDER BY MIN(DATEDIFF(DAY, review_creation_date,
                     review_answer_timestamp));


SELECT COUNT(*) AS Exact_Duplicate_Groups
FROM
(
    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp
    FROM dbo.olist_order_reviews_dataset
    GROUP BY
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp
    HAVING COUNT(*) > 1
) AS Duplicates;


SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,

    DATEDIFF(
        MINUTE,
        review_creation_date,
        review_answer_timestamp
    ) AS Response_Time_Minutes,

    CASE
        WHEN DATEDIFF(
            DAY,
            review_creation_date,
            review_answer_timestamp
        ) > 30
        THEN 1
        ELSE 0
    END AS Flag_Response_Over_30_Days

INTO dbo.order_reviews_cleaned

FROM dbo.olist_order_reviews_dataset;

SELECT
    (SELECT COUNT(*)
     FROM dbo.olist_order_reviews_dataset) AS Original_Records,

    (SELECT COUNT(*)
     FROM dbo.order_reviews_cleaned) AS Cleaned_Records;

SELECT COUNT(*) AS Duplicate_Review_Order_Groups
FROM
(
    SELECT
        review_id,
        order_id
    FROM dbo.order_reviews_cleaned
    GROUP BY
        review_id,
        order_id
    HAVING COUNT(*) > 1
) AS Duplicates;


SELECT
    SUM(CASE
        WHEN Response_Time_Minutes <>
             DATEDIFF(MINUTE, review_creation_date,
                      review_answer_timestamp)
        THEN 1 ELSE 0
    END) AS Incorrect_Response_Times,

    SUM(Flag_Response_Over_30_Days)
        AS Delayed_Response_Flags,

    SUM(CASE
        WHEN DATEDIFF(DAY, review_creation_date,
                      review_answer_timestamp) > 30
        THEN 1 ELSE 0
    END) AS Actual_Delayed_Responses

FROM dbo.order_reviews_cleaned;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_reviews_cleaned'
ORDER BY ORDINAL_POSITION;