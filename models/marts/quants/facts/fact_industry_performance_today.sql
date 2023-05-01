WITH fact_industry_performance_today AS (
    SELECT
        surrogate_key,
        -- Include any additional columns you need from the dim_industry_performance_today table
    FROM {{ ref('dim_industry_performance_today') }}
)

-- Your main query goes here, using the fact_industry_performance_today CTE
SELECT
    fact_industry_performance_today.surrogate_key,
    -- Include any additional columns or calculations you need
FROM fact_industry_performance_today
-- Add any necessary JOINs or additional CTEs
;
