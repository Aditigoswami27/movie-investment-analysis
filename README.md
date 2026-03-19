# movie-investment-analysis
## Project Overview : This project analyzes movie investment trends, profitability patterns, and genre-based risk using an end-to-end data analytics workflow.
The goal was to understand:
-Do high budgets guarantee high returns?
-Which genres offer better risk-adjusted ROI?
-What is the failure rate across investment categories?
-How has profitability evolved over time?

## Tech Stack :
-Python (Pandas) – Data cleaning, feature engineering & EDA
-PostgreSQL – Advanced SQL analysis (aggregations, window functions, quartiles)
-Power BI – Interactive dashboard & business visualization

## Project Workflow:
Raw Dataset → Data Cleaning & Feature Engineering (Pandas) → Exported Structured Tables → Relational Modeling in PostgreSQL → Advanced SQL Analysis → Interactive Power BI Dashboard .
 
## Key Analysis Performed :
1.  Investment & Profitability :
       -ROI & Profit calculation
       -Budget category segmentation
       -Loss-making percentage analysis
       -ROI quartile distribution using NTILE

2.  Time Trend Analysis :
     -Movies released per year
     -Revenue growth trends
     -Median ROI by year
     -Most profitable movie per year (Window functions)

3.  Genre Performance Analysis
     -Average & Median ROI by genre
     -Failure rate by genre
     -Revenue contribution by genre
     -Risk comparison across genres

## Key Insights:

  -High-budget films generate higher revenue but lower median ROI.

  -Horror & Family genres show stronger risk-adjusted returns.

  -Some genres exhibit significantly higher failure rates.

  -Industry production volume increased sharply after 1990.

  -ROI distribution is highly skewed with a small number of extreme outliers.

## SQL Concepts Demonstrated
-GROUP BY & HAVING
-Subqueries
-Window Functions (ROW_NUMBER, DENSE_RANK, NTILE)
-PERCENTILE_CONT for Median
-Risk segmentation using conditional aggregation
-Relational joins between fact & dimension tables

## Repository Structure
movie-investment-analysis/
- cleaned_movies.csv/         → Cleaned datasets
- movies_notebook.ipynb/      → Data cleaning & EDA notebook
- quries.sql/                 → Analytical SQL queries
- dashboard.pbix/             → Dashboard (.pbix file)
- dashboard page_1            → first page of dashboard
- dashboard page_2            → second page of dashboard
- README.md

## Dashboard Features
-Interactive genre & year slicers
-Risk vs Profit visualization
-ROI performance comparison
-Failure rate analysis
-Top profitable movies leaderboard

## What This Project Demonstrates

✔ End-to-end analytics pipeline
✔ Business-focused thinking
✔ Risk & profitability evaluation
✔ Clean data modeling practices
✔ Professional dashboard design
