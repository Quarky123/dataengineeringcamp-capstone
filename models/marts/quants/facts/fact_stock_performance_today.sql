WITH latest_dates AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY STOCK_ID ORDER BY DATE DESC) as row_num
    FROM {{ ref('dim_daily_stock_performance') }}
)

SELECT
    *
FROM latest_dates
WHERE row_num = 1