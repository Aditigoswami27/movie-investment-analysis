CREATE TABLE movies(
	movie_id INTEGER PRIMARY KEY,
	title VARCHAR(200),
	language VARCHAR(50),
	country VARCHAR(50),
    genres VARCHAR(250),
	budget NUMERIC(14,2),
	revenue NUMERIC(14,2),
	votes_count INTEGER,
	duration INTEGER,
	year INTEGER,
	imdb_rating NUMERIC(2,1),
	profit NUMERIC(14,2),
	roi NUMERIC(4,4),
	budget_category VARCHAR(50)
);

SELECT * FROM movies;

CREATE TABLE genres(
	movie_id INTEGER REFERENCES movies(movie_id),
	genre VARCHAR(50)
);

SELECT * FROM genres;

--SECTION 1 — Foundation (Core Aggregation)

--What is the total number of movies in the dataset?
SELECT COUNT(MOVIE_ID) AS MOVIE_COUNT FROM MOVIES;

--What is the overall average budget, revenue, profit, and ROI?
SELECT AVG(BUDGET) AS AVG_BUDGET, AVG(REVENUE) AS AVG_REVENUE, AVG(ROI) AS AVG_ROI, AVG(PROFIT) AS AVG_PROFIT FROM MOVIES;

--What percentage of movies are loss-making (ROI < 0)?
SELECT ROUND(100.0* SUM(CASE WHEN ROI<0 THEN 1 ELSE 0 END)/COUNT(*),2) AS LOSS_PERCENTAGE FROM MOVIES; 

--What is the median ROI of the entire dataset?
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ROI) AS MEDIAN_ROI FROM MOVIES; 

--SECTION 2 — Budget Risk & Performance

--What is the average and median ROI for each budget category?
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ROI)  AS MEDIAN_ROI ,AVG(ROI) AS AVG_ROI ,
BUDGET_CATEGORY FROM MOVIES 
GROUP BY(BUDGET_CATEGORY);

--Which budget category has the highest failure rate?
SELECT BUDGET_CATEGORY ,(COUNT(CASE WHEN ROI<0 THEN 1 END)*100.0)/COUNT(*)
AS FAILURE_RATE FROM MOVIES 
GROUP BY(BUDGET_CATEGORY) ORDER BY FAILURE_RATE DESC ; 

--Among high-budget movies, how many are profitable vs loss-making?
SELECT SUM(CASE WHEN ROI<0 THEN 1 ELSE 0 END) AS LOSS_MAKING,
  SUM(CASE WHEN ROI>0 THEN 1 ELSE 0 END) AS PROFITABALE
FROM MOVIES WHERE BUDGET_CATEGORY= 'High budget';

--Which 10 movies have the highest ROI among movies with budget below the dataset median?
SELECT TITLE, BUDGET, ROI FROM MOVIES WHERE
BUDGET< (
	SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY BUDGET) AS MEDIAN_BUDGET FROM MOVIES
)   
ORDER BY ROI DESC LIMIT 10 ;

--SECTION 3 — Time-Based Business Trends

--How many movies were released per year?
SELECT YEAR, COUNT(*) AS MOVIES_PER_YEAR FROM MOVIES GROUP BY(YEAR);

--Which 5 years generated the highest total revenue?
SELECT YEAR, SUM(REVENUE) AS TOTAL_REVENUE FROM MOVIES 
GROUP BY(YEAR) ORDER BY(TOTAL_REVENUE) DESC LIMIT 5; 

--Which year had the highest median ROI?
SELECT year,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ROI) AS MEDIAN_ROI 
FROM MOVIES group by year
ORDER BY MEDIAN_ROI DESC LIMIT 1;

--For each year, identify the single most profitable movie.(Use window function or DISTINCT ON)
SELECT * FROM (
	SELECT title, YEAR,PROFIT ,ROW_NUMBER() OVER(PARTITION BY YEAR ORDER BY PROFIT DESC) AS ROW_NUM
			FROM MOVIES )t
WHERE ROW_NUM=1	; 

--SECTION 4 — Genre Performance (Using JOIN)

--Which genres have the highest average ROI (consider only genres with at least 100 movies)?
SELECT G.GENRE,AVG(M.ROI) AS AVG_ROI
FROM MOVIES M JOIN GENRES G ON M.MOVIE_ID = G.MOVIE_ID
GROUP BY G.GENRE
HAVING COUNT(*)>=100 ORDER BY AVG_ROI DESC;

--Which genres have the highest failure rate?
SELECT G.GENRE,(COUNT(CASE WHEN M.ROI<0 THEN 1 END)*100.0)/COUNT(*) AS FAILURE_RATE 
FROM MOVIES M JOIN GENRES G ON M.MOVIE_ID = G.MOVIE_ID
GROUP BY G.GENRE ORDER BY FAILURE_RATE DESC;

--Among genres with at least 200 movies, which genre has the highest median ROI? 
SELECT G.GENRE, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY M.ROI) AS MEDIAN_ROI
FROM MOVIES M JOIN GENRES G ON M.MOVIE_ID = G.MOVIE_ID
GROUP BY G.GENRE HAVING COUNT(*)>=200 
ORDER BY MEDIAN_ROI DESC LIMIT 1;

--What percentage contribution does each genre make to total industry revenue?
SELECT G.GENRE, ROUND(
	100.0*SUM(M.REVENUE)/(SELECT SUM(REVENUE) FROM MOVIES)
	,2) AS CONTRIBUTION 
FROM GENRES G JOIN MOVIES M ON M.MOVIE_ID = G.MOVIE_ID           
GROUP BY G.GENRE 
ORDER BY CONTRIBUTION DESC;

--SECTION 5 — Advanced SQL (This Shows Real Skill)

--Rank movies within each genre based on ROI (highest to lowest).
SELECT M.TITLE ,G.GENRE,M.ROI ,DENSE_RANK() OVER(PARTITION BY G.GENRE ORDER BY M.ROI DESC) AS RANK_OF_MOVIES FROM 
GENRES G JOIN MOVIES M ON M.MOVIE_ID = G.MOVIE_ID ;

--Divide all movies into 4 ROI quartiles using NTILE.
SELECT MOVIE_ID,TITLE,ROI, NTILE(4) OVER(ORDER BY ROI DESC) AS QUARTILE FROM MOVIES;

--How many movies fall into each quartile?
SELECT QUARTILE ,COUNT(*) AS MOVIE_COUNT FROM (
	SELECT NTILE(4) OVER(ORDER BY ROI DESC) AS QUARTILE FROM MOVIES
)T
GROUP BY QUARTILE ORDER BY QUARTILE;
