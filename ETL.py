
import os
from dotenv import load_dotenv
# load environment variables from .env file
load_dotenv()
# get the values of the environment variables
api_key_id = os.getenv('API_KEY_ID')
api_secret_key = os.getenv('API_SECRET_KEY')
DB_USERNAME = os.getenv('DB_USERNAME')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')


import alpaca_trade_api as tradeapi
# import alpaca_trade_api 

from alpaca_trade_api.rest import REST, TimeFrame
import pandas as pd
import requests
import psycopg2

from datetime import datetime, timedelta
import pytz
import alpaca_trade_api as tradeapi
from alpaca_trade_api.rest import TimeFrame


# note that it will always be delayed by 1 day because my subscription doesn't for up to date data

def individual_stock_bar(api_key_id,api_secret_key,stock_ticker):
    # authentication and connection details
    base_url = 'https://paper-api.alpaca.markets'
    api = tradeapi.REST(api_key_id, api_secret_key, base_url, api_version='v2')

    # get today's date in UTC timezone
    today = datetime.now(pytz.utc)- timedelta(days=1)

    # calculate the date one year from today's date in UTC timezone
    # i am just using 30 days for demonstration purposes, supposed to be 365 days
    one_year_from_now = today - timedelta(days=30)

    # convert the dates to string format with the desired date format "YYYY-MM-DD"
    start_date = today.strftime('%Y-%m-%d')
    end_date = one_year_from_now.strftime('%Y-%m-%d')

    # get the AAPL stock bars for the specified date range
    return (api.get_bars(stock_ticker, TimeFrame.Day,  end_date, start_date,adjustment='raw').df)
    
# upsert
def create_and_insert(stock_ticker, df):
    cur = conn.cursor()

    # use f-strings to create the table name with the stock ticker symbol
    create_table_query = f"""
        CREATE TABLE IF NOT EXISTS {stock_ticker} (
            date DATE PRIMARY KEY,
            open FLOAT,
            high FLOAT,
            low FLOAT,
            close FLOAT,
            volume INT
        )
    """

    # execute the query to create the table
    cur.execute(create_table_query)

    # commit the transaction to persist the changes
    conn.commit()

    # upsert the data into the table using the ON CONFLICT clause
    for index, row in df.iterrows():
        upsert_query = f"""
            INSERT INTO {stock_ticker} (date, open, high, low, close, volume)
            VALUES ('{index.date()}', {row['open']}, {row['high']}, {row['low']}, {row['close']}, {row['volume']})
            ON CONFLICT (date) DO UPDATE 
            SET open = excluded.open,
                high = excluded.high,
                low = excluded.low,
                close = excluded.close,
                volume = excluded.volume
        """
        cur.execute(upsert_query)

    # commit the transaction to persist the changes
    conn.commit()

    # close the cursor and connection objects
    cur.close()

# read the file txt 
def read_stocks_file(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
    # strip newline characters and whitespace from each line
    stocks_list = [line.strip() for line in lines]
    return stocks_list


# define the SQL query to create a table named the stock ticker if it doesn't already exist
conn = psycopg2.connect(
    user=DB_USERNAME,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT,
    database=DB_NAME
)

list_of_stocks = read_stocks_file('stocks.txt')

for stock in list_of_stocks:
    df = individual_stock_bar(api_key_id,api_secret_key,stock_ticker=stock)
    create_and_insert(stock,df)
conn.close()

print('upserting in progress')