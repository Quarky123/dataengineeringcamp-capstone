-- src_aapl.sql

WITH AAPL AS (
SELECT * FROM AIRBYTE_DATABASE.AIRBYTE_SCHEMA.AAPL
)
SELECT
    'AAPL' AS symbol,
    DATE AS DATE,
    LOW AS DAILY_LOW,
    HIGH AS DAILY_HIGH,
    OPEN AS DAILY_OPEN,
    CLOSE AS DAILY_CLOSE,
    VOLUME AS DAILY_VOLUME
FROM 
    AAPL
