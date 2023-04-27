-- fact_stock_daily_data.sql

WITH aapl_data AS (
    SELECT * FROM {{ ref('src_aapl') }}
),
msft_data AS (
    SELECT * FROM {{ ref('src_msft') }}
),
spy_data AS (
    SELECT * FROM {{ ref('src_spy') }}
),
tsla_data AS (
    SELECT * FROM {{ ref('src_tsla') }}
)

SELECT * FROM aapl_data
UNION ALL
SELECT * FROM msft_data
UNION ALL
SELECT * FROM spy_data
UNION ALL
SELECT * FROM tsla_data
