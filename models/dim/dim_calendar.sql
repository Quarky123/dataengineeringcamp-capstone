WITH RECURSIVE rec_cte AS (
    -- start date
    SELECT MIN(date) AS dt FROM {{ ref('fact_stock_daily_data') }}
    UNION ALL
    SELECT DATEADD('day',1,dt) as dt
    FROM rec_cte
    -- end date (inclusive)
    WHERE dt <  (SELECT MAX(date) FROM {{ ref('fact_stock_daily_data') }})
)

SELECT
  dt AS date,
  EXTRACT(DAY FROM dt) AS day,
  EXTRACT(MONTH FROM dt) AS month,
  EXTRACT(YEAR FROM dt) AS year,
  EXTRACT(DOW FROM dt) AS day_of_week,
{{ dbt_utils.generate_surrogate_key(['date'])  }} as date_key 
FROM rec_cte

