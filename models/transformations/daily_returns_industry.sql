-- my_model.sql

with latest_aapl as (
    select max(date) as max_date
    from {{ ref('src_aapl') }}
),

stg_product as (
    select *
    from {{ ref('daily_returns_inversed') }} d
    where d.date = (select max_date from latest_aapl)
),

stg_product_subcategory as (
    select *
    from {{ ref('industry_sector') }}
),

final_table as (
    select
        stg_product.date,
        stg_product.symbol as symbol,
        stg_product.returns,
        stg_product_subcategory.industry_sector,
        stg_product_subcategory.company_name
    from stg_product
    join stg_product_subcategory
    on stg_product.symbol = stg_product_subcategory.symbol
)

select *
from final_table
