{% set src_tables = ['SRC_AAPL', 'SRC_MSFT', 'SRC_TSLA'] %}

WITH src AS (
    {% for table in src_tables %}
    SELECT SYMBOL, DAILY_OPEN, DAILY_CLOSE, DATE
    FROM {{ table }}
    {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
),
industry_performance AS (
    SELECT
        isp.INDUSTRY_SECTOR,
        src.DATE,
        AVG(((src.DAILY_CLOSE - src.DAILY_OPEN) / src.DAILY_OPEN) * 100) AS weighted_avg_pct_return,
        COUNT(DISTINCT isp.COMPANY_NAME) AS num_companies
    FROM src
    JOIN INDUSTRY_SECTOR isp
        ON src.SYMBOL = isp.SYMBOL
    GROUP BY isp.INDUSTRY_SECTOR, src.DATE
),
industry_ranking AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY DATE ORDER BY weighted_avg_pct_return DESC) AS industry_ranking
    FROM industry_performance
)

SELECT
    industry_ranking.*,
    dim.industry_id
FROM industry_ranking
JOIN dim_industry_performance dim
    ON industry_ranking.INDUSTRY_SECTOR = dim.industry
    AND industry_ranking.DATE = dim.date;
