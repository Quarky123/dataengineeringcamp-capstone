{% set src_tables = ['src_aapl', 'src_msft', 'src_tsla'] %}

SELECT DISTINCT
    isp.INDUSTRY_SECTOR as industry,
    src.DATE as date
FROM {{ ref('industry_sector') }} isp
JOIN (
    {% for table in src_tables %}
    SELECT DISTINCT SYMBOL, DATE
    FROM {{ ref(table) }}
    {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
) src
ON isp.SYMBOL = src.SYMBOL;


not sure why it doesn't work in the dbt but works in the sql snowflake