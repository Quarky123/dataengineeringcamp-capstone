WITH latest_dates AS (
    SELECT
        STOCK_ID,
        MAX(DATE) AS max_date
    FROM {{ ref('fact_daily_stock_performance') }}
    GROUP BY STOCK_ID
)

SELECT
    t.*
FROM table_name AS t
JOIN latest_dates AS ld
ON t.STOCK_ID = ld.STOCK_ID AND t.DATE = ld.max_date
