

WITH calendar AS (
    SELECT
        date,
        date_key
    FROM {{ ref('dim_calendar') }}
),

stock_data AS (
    SELECT
        date,
        symbol,
        id
        
    FROM {{ ref('dim_stock_daily_data') }}
)

SELECT
    stock_data.date,
    calendar.date_key,
    stock_data.id as stock_id
FROM stock_data
JOIN calendar
  ON stock_data.date = calendar.date
