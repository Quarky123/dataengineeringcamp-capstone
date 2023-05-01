WITH daily_data AS (
    SELECT
        DATE,
        INDUSTRY_SECTOR,
        SUM(RETURNS) AS industry_total_returns,
        COUNT(DISTINCT COMPANY_NAME) AS number_of_companies
    FROM {{ ref('daily_returns_industry') }}
    GROUP BY DATE, INDUSTRY_SECTOR
),
industry_weighted_average_return AS (
    SELECT
        DATE,
        INDUSTRY_SECTOR,
        industry_total_returns / number_of_companies AS weighted_avg_return
    FROM daily_data
),
industry_rankings AS (
    SELECT
        DATE,
        INDUSTRY_SECTOR,
        weighted_avg_return,
        DENSE_RANK() OVER (PARTITION BY DATE ORDER BY weighted_avg_return DESC) AS industry_rank
    FROM industry_weighted_average_return
),
fact_with_surrogate_key AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['DATE', 'INDUSTRY_SECTOR']) }} AS surrogate_key,
        DATE,
        INDUSTRY_SECTOR,
        weighted_avg_return,
        industry_rank
    FROM industry_rankings
)
SELECT
    surrogate_key AS surrogate_key,
    DATE AS date,
    INDUSTRY_SECTOR AS industry_sector,
    weighted_avg_return AS weighted_average_return,
    industry_rank AS ranking_of_industry
FROM fact_with_surrogate_key
