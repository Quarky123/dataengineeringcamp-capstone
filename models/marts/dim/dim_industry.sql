WITH DISTINCT_INDUSTRY_DATES AS (
    SELECT DISTINCT
        DATE,
        INDUSTRY_SECTOR
    FROM {{ ref('daily_returns_industry') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['date', 'industry_sector']) }} AS surrogate_key,
    DATE AS date,
    INDUSTRY_SECTOR AS industry_name
FROM DISTINCT_INDUSTRY_DATES
