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
stock_betas AS (
    SELECT * FROM {{ ref('stock_betas') }}
),
daily_returns AS (
    SELECT * FROM {{ ref('daily_returns') }}
),
stock_performance AS (
    SELECT
        aapl_data.DATE,
        aapl_data.SYMBOL AS stock_id,
        aapl_data.DAILY_CLOSE AS close_price,
        daily_returns.AAPL_RETURN AS daily_return,
        stock_betas.AAPL_BETA AS beta
    FROM aapl_data
    JOIN daily_returns ON aapl_data.DATE = daily_returns.DATE
    JOIN stock_betas ON aapl_data.DATE = stock_betas.DATE
    UNION ALL
    SELECT
        msft_data.DATE,
        msft_data.SYMBOL AS stock_id,
        msft_data.DAILY_CLOSE AS close_price,
        daily_returns.MSFT_RETURN AS daily_return,
        stock_betas.MSFT_BETA AS beta
    FROM msft_data
    JOIN daily_returns ON msft_data.DATE = daily_returns.DATE
    JOIN stock_betas ON msft_data.DATE = stock_betas.DATE
    UNION ALL
    SELECT
        tsla_data.DATE,
        tsla_data.SYMBOL AS stock_id,
        tsla_data.DAILY_CLOSE AS close_price,
        daily_returns.TSLA_RETURN AS daily_return,
        stock_betas.TSLA_BETA AS beta
    FROM tsla_data
    JOIN daily_returns ON tsla_data.DATE = daily_returns.DATE
    JOIN stock_betas ON tsla_data.DATE = stock_betas.DATE
)


SELECT
    {{ dbt_utils.generate_surrogate_key(['date', 'stock_id']) }} AS surrogate_key,
    *
FROM stock_performance