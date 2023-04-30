-- fact_stock_summary_data.sql

WITH stock_data AS (
  SELECT
    symbol,
    DATE_TRUNC('month', date) AS month,
    AVG((daily_high + daily_low) / 2) AS avg_price,
    SUM(daily_volume) AS total_volume
  FROM {{ ref('fact_stock_daily_data') }}
  GROUP BY symbol, DATE_TRUNC('month', date)
)

SELECT
  *,
  RANK() OVER (PARTITION BY symbol ORDER BY month) AS month_rank
FROM stock_data
