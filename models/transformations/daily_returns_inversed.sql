WITH
    aapl AS (
        SELECT
            DATE,
            SYMBOL,
            (DAILY_CLOSE - DAILY_OPEN) / DAILY_OPEN AS return
        FROM
            {{ ref('src_aapl') }}
    ),
    tsla AS (
        SELECT
            DATE,
            SYMBOL,
            (DAILY_CLOSE - DAILY_OPEN) / DAILY_OPEN AS return
        FROM
            {{ ref('src_tsla') }}
    ),
    msft AS (
        SELECT
            DATE,
            SYMBOL,
            (DAILY_CLOSE - DAILY_OPEN) / DAILY_OPEN AS return
        FROM
            {{ ref('src_msft') }}
    ),
    spy AS (
        SELECT
            DATE,
            SYMBOL,
            (DAILY_CLOSE - DAILY_OPEN) / DAILY_OPEN AS return
        FROM
            {{ ref('src_spy') }}
    )

SELECT
    DATE,
    SYMBOL AS symbol,
    return AS returns
FROM
    aapl
UNION ALL
SELECT
    DATE,
    SYMBOL AS symbol,
    return AS returns
FROM
    tsla
UNION ALL
SELECT
    DATE,
    SYMBOL AS symbol,
    return AS returns
FROM
    msft
UNION ALL
SELECT
    DATE,
    SYMBOL AS symbol,
    return AS returns
FROM
    spy
