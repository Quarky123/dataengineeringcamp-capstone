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
),
unioned_data AS (
    SELECT * FROM aapl_data
    UNION ALL
    SELECT * FROM msft_data
    UNION ALL
    SELECT * FROM spy_data
    UNION ALL
    SELECT * FROM tsla_data
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date', 'symbol']) }} AS id,
    *
FROM unioned_data
