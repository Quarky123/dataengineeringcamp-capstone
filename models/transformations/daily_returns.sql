WITH combined_stock_prices AS (
    SELECT *
    FROM {{ ref('combined_stock_prices') }}
),
daily_returns AS (
    SELECT
        DATE,
        AAPL_CLOSE / LAG(AAPL_CLOSE) OVER (ORDER BY DATE) - 1 AS AAPL_RETURN,
        MSFT_CLOSE / LAG(MSFT_CLOSE) OVER (ORDER BY DATE) - 1 AS MSFT_RETURN,
        TSLA_CLOSE / LAG(TSLA_CLOSE) OVER (ORDER BY DATE) - 1 AS TSLA_RETURN,
        SPY_CLOSE / LAG(SPY_CLOSE) OVER (ORDER BY DATE) - 1 AS SPY_RETURN
    FROM combined_stock_prices
)

SELECT *
FROM daily_returns
