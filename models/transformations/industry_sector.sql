
SELECT
  'AAPL' as symbol,
  'Technology' as industry_sector,
  'Apple' as company_name

UNION ALL
SELECT
  'MSFT' as symbol,
  'Technology' as industry_sector,
  'Microsoft' as company_name
UNION ALL
SELECT
  'SPY' as symbol,
  'ETF' as industry_sector,
  'S&P 500 Index' as company_name
UNION ALL
SELECT
  'TSLA' as symbol,
  'Automotive' as industry_sector,
  'Tesla Motors' as company_name

-- create surrogate key for each

