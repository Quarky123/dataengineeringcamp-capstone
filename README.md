# Capstone Project

## Context

Who are the data pipeline for?

- Normal Users : Only concerned with the daily movement of stock prices
- Quants :Basically traders from financial institutions who make use of Algo to trade the markets. using it for data science and finance related applications

## Data Source:

- Alpaca API: Finance API which gives historical data of stocks. Live Dataset which refreshes every second
- Downside: unpaid users cannot access the latest 15 minutes of stock data

## Data Architecture

![Data Architecture Diagram](images/data_architecture.png)

## Data Pipeline

- Live dataset
- Full extract of 30 days worth of data (supposed to be 1 year) on the first extraction
- Incremental extract of 1 day worth of data each time subsequently after that

## Dimensional models

![Data Architecture Diagram](images/fact_table_1.png)
![Data Architecture Diagram](images/fact_table_2.png)
![Data Architecture Diagram](images/fact_table_3.png)

## Data Quality and Validation

Data quality testing is performed using dbt test, which helps maintain the integrity of the data throughout the pipeline.

## Final dashboard

![Data Architecture Diagram](images/table_1.jpg)
