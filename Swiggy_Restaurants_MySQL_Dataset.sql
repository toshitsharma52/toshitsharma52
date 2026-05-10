## – Restaurant Dataset Analysis
## - DataBase Name = Swiggy

## - Name:[Toshit Bhardwaj]

## - Overview:
--   This dataset contains information about various restaurants, including their names,
--   locations (cities), ratings, cuisines, and cost details.
--   The primary purpose of this dataset is to analyze restaurant trends, customer
--   preferences, and performance based on ratings and other factors. 

## - By using this dataset, we can perform different types of analysis such as:

-- 1- Identifying top-rated restaurants
-- 2- Comparing restaurants across different cities
-- 3- Understanding popular cuisines
-- 4- Analyzing cost vs rating relationship

##- The dataset is structured in tabular format and managed using SQL in MySQL Workbench.
--  Queries such as SELECT, filtering, sorting, and aggregation functions can be applied 
--  to extract meaningful insights.  																		  


USE swiggy;


-- 1. Select all columns from the restaurant table.

SELECT * FROM restaurants;

-- Purpose: Retrieves all columns and rows from the restaurants table.

-- Insights:

-- The * wildcard returns every column available (e.g., id, name, city, cuisine, rating, etc.)

-- Useful for quick data exploration, but not recommended for production or large datasets

-- Performance impact: Reads all columns, which may transfer unnecessary data over the network


-- 2. Display the names and cities of all restaurants.

SELECT name,city FROM restaurants;

-- Purpose: Returns only the restaurant name and city for all records.

-- Insights:

-- Column projection – limits output to specific columns, reducing data transfer

-- More efficient than SELECT * when you don't need all columns

-- Clean output for reports or APIs that only require basic location info


-- 3. Find all restaurants located in Bangalore

SELECT * FROM restaurants 
where city LIKE "%Bangalore";

-- Purpose: Finds all restaurants whose city ends with "Bangalore" (e.g., "Bangalore", "North Bangalore", "Bangalore".

-- Insights:

-- Pattern matching with LIKE – % is a wildcard matching zero or more characters before "Bangalore"

-- ⚠️ Potential issue: This also matches values like "Greater Bangalore" or "Bangalore City" (if stored differently)

-- Better approach for exact match: WHERE city = 'Bangalore'

-- Performance consideration: LIKE '%Bangalore' cannot use a standard B-tree index efficiently (leading wildcard), causing a full table scan


-- 4. List the names and ratings of restaurants with a rating greater than 4.0.

SELECT name,rating 
 FROM restaurants 
WHERE rating > 4;

-- Purpose: Returns restaurant names and their ratings for establishments rated above 4.0.

-- Insights:

-- Numeric filtering – uses comparison operator > to find high-rated restaurants

-- Column projection – only returns name and rating, excluding other columns like city, cost, cuisine

-- No decimal handling – since it's > 4 (not > 4.0), a restaurant with rating 4.0 would be excluded (only >4, not >=4)

-- Common use case – finding top-rated restaurants for recommendations


-- 5. Find restaurants where the cost is less than or equal to 300.

SELECT * FROM restaurants 
WHERE cost <= 300;

-- Purpose: Retrieves all columns for budget-friendly restaurants costing 300 or less (in currency units, typically INR for Indian restaurants).

-- Insights:

-- Less-than-or-equal filter – <= 300 includes restaurants costing exactly 300 or less

-- Budget segmentation – useful for filtering "affordable" or "economy" options

-- Full row retrieval – SELECT * returns all columns (cuisine, city, rating, etc.), helpful for detailed comparison

-- Potential data type consideration – if cost is stored as VARCHAR instead of INT/DECIMAL, this query would fail or produce unexpected results


-- 6. Display all distinct cuisine types available in the dataset.

SELECT COUNT(DISTINCT cuisine) 
 FROM restaurants;
 
 -- Purpose: Returns the total number of unique cuisine types available across all restaurants.

-- Insights:

-- Aggregation with DISTINCT – eliminates duplicate cuisine values before counting

-- Not listing, but counting – unlike "display all distinct cuisine types" (the description), this query only shows the count, not the actual cuisine names

-- Data quality indicator – helps understand culinary variety in the dataset
-- Mismatch with requirement – description asks to "display all distinct cuisine types" but query shows count instead

 
-- 7. Find all restaurants serving Biryani cuisine.

SELECT * FROM restaurants 
WHERE cuisine LIKE "%Biryani";

-- Purpose: Finds all restaurants serving Biryani cuisine, matching any cuisine name that ends with "Biryani".

-- Insights:

-- Pattern matching with trailing wildcard – "%Biryani" captures cuisines like:

-- "Biryani" (exact match)

-- "Hyderabadi Biryani"

-- "Chicken Biryani"

-- "Mutton Biryani"

-- ⚠️ Missing leading wildcard – Would NOT match "Biryani Rice" or "Biryani Combo" (if stored differently)

-- Common in Indian restaurant datasets – Biryani is a popular dish, often stored as variant names

-- Performance issue – Leading % prevents index usage, causing full table scan


-- 8. Show the top 5 restaurants with the highest ratings.

SELECT * FROM restaurants
ORDER BY rating DESC
LIMIT 5;

-- Purpose: Retrieves all columns for the top 5 highest-rated restaurants in the dataset.

-- Insights:

-- Multi-step query execution:

-- ORDER BY rating DESC – sorts all restaurants from highest to lowest rating
-- LIMIT 5 – returns only the first 5 rows from the sorted result
-- No tie-handling – if multiple restaurants share the same top rating (e.g., 5.0), only 5 total rows return, potentially excluding some top-rated restaurants

-- Common use case – "Best restaurants" feature on food delivery apps

-- Index optimization – an index on rating would make this query extremely fast


-- 9. List restaurants with a rating count greater than 1000.

SELECT * FROM restaurants 
WHERE rating_count > 1000;

-- Purpose: Retrieves all columns for restaurants that have received more than 1000 user ratings/reviews.

-- Insights:

-- Popularity filter – rating_count typically represents the number of customer reviews/ratings submitted

-- High social proof – restaurants with 1000+ ratings are well-established and heavily reviewed

-- Data interpretation:

-- High rating_count + high rating = Widely loved restaurant

-- High rating_count + low rating = Controversial or consistently poor quality

-- Low rating_count + high rating = New restaurant or niche (statistically less reliable)

-- Business value – helps identify market leaders and trusted establishments


-- 10. Count the total number of restaurants in the dataset.

SELECT COUNT(DISTINCT(name))
FROM restaurants;

-- Purpose: Returns the number of unique restaurant names in the dataset.

-- Insights:

-- DISTINCT on name – counts each unique restaurant name only once, even if multiple branches exist

-- ⚠️ Data quality concerns:

-- Same restaurant chain with different branches? (e.g., "Dominos" vs "Dominos Pizza - Koramangala")

-- Same restaurant with slight name variations? (e.g., "McDonald's", "Mcdonalds", "Mc Donalds")

-- Typos or capitalization differences? (SELECT DISTINCT(name) is case-sensitive in most SQL databases)

-- Not the same as row count – if a restaurant has multiple branches/cuisines, they'll be counted once


-- 11. Find the average cost of all restaurants.

SELECT AVG(cost) AS AVERAGE_COST
FROM restaurants;

-- Purpose: Calculates the average (mean) cost across all restaurants in the dataset.

-- Insights:

-- Aggregate function – AVG() processes all cost values and returns a single number

-- Column alias – AS AVERAGE_COST renames the output column for better readability

-- NULL handling – AVG() automatically ignores NULL values (doesn't treat them as zero)

-- Single output row – returns one value representing overall market price level

-- Use cases:

-- Benchmark for "expensive" vs "affordable" categorization

-- Understanding market positioning

-- Budget planning for users


-- 12. Display restaurant names and costs ordered by cost in ascending order.

SELECT name,cost FROM restaurants
ORDER BY cost ASC;

-- Purpose: Returns restaurant names and their costs, sorted from cheapest to most expensive.

-- Insights:

-- Sorting operation – ORDER BY cost ASC arranges results in ascending order (lowest first)

-- ASC is optional – ascending is the default if not specified (ORDER BY cost does the same)

-- NULL behavior – NULL values typically appear first or last depending on database (MySQL puts NULLs first for ASC)

-- Performance consideration – Without index on cost, each query triggers a full table sort

-- Practical use: Budget-conscious users finding affordable options


-- 13. Find the average rating of restaurants for each city.

SELECT AVG(rating) AS AVERAGE_RATING ,city FROM restaurants
GROUP BY city;

-- Purpose: Calculates the average rating for restaurants in each city, showing one row per city.

-- Insights:

-- GROUP BY city – partitions data into groups by unique city names before calculating averages

-- Two-column output – city name and its corresponding average rating

-- NULL handling in grouping – all NULL city values (if any) form their own group

-- Critical order of execution:

-- FROM restaurants – get all rows
-- GROUP BY city – divide into city groups
-- SELECT AVG(rating), city – compute per-group average
-- ⚠️ Common mistake alert – Columns in SELECT must either be in GROUP BY or be aggregated


-- 14. Count the number of restaurants available in each city.

SELECT COUNT(*) AS TOTAL_RESTAURANTS ,city
FROM restaurants 
GROUP BY city;

-- Purpose: Returns the number of restaurants in each city, showing one row per city with its restaurant count.

-- Insights:

-- Group by city – partitions all restaurants by their city value

-- COUNT(*) – counts total rows (including duplicates and NULLs) in each city group

-- Difference from COUNT(column) – COUNT(*) includes rows with NULL values, while COUNT(city) would exclude NULL cities

-- Output structure – Two columns: city name and restaurant count for that city

-- Use cases:

-- Market analysis (which cities have most restaurant coverage)

-- Identifying data gaps (cities with low counts)

-- Business expansion decisions


-- 15. Find the maximum and minimum cost of restaurants for each cuisine.

SELECT MAX(cost),MIN(cost),cuisine
FROM restaurants
GROUP BY cuisine;

-- Purpose: For each cuisine type, finds the most expensive and cheapest restaurant cost, showing the price range per cuisine.

-- Insights:

-- Range analysis – MAX(cost) and MIN(cost) together show the price spread for each cuisine

-- GROUP BY cuisine – Each unique cuisine gets its own row

-- Business intelligence value:

-- Luxury cuisines (high min/max) – French, Japanese, fine dining

-- Budget cuisines (low min/max) – Street food, fast food, local cuisine

-- Versatile cuisines (large spread) – Indian, Chinese (available from cheap to premium)

-- Missing context – Doesn't show average or how many restaurants per cuisine


-- 16. List cuisines that have more than 10 restaurants.

SELECT cuisine,COUNT(*) AS TOTAL_RESTAURANTS
FROM restaurants
GROUP BY cuisine 
HAVING TOTAL_RESTAURANTS >10;


-- Purpose: Identifies cuisine types that are widely available, specifically those with more than 10 restaurants in the dataset.

-- Insights:

-- FILTER after grouping – HAVING clause filters groups, unlike WHERE which filters individual rows before grouping

-- Execution order matters:

-- FROM restaurants – get all rows
-- GROUP BY cuisine – form cuisine groups
-- COUNT(*) – calculate count per group
-- HAVING TOTAL_RESTAURANTS > 10 – keep only groups with >10 restaurants
-- SELECT – return the filtered results
-- Column alias usage – HAVING TOTAL_RESTAURANTS > 10 uses the alias (allowed in HAVING, but not in WHERE in most SQL databases)

-- Business value:

-- Identifies popular, mainstream cuisines

-- Indicates market saturation

-- Helps understand culinary preferences in the dataset


-- 17. Find the top 3 cities with the highest number of restaurants.

SELECT city, COUNT(*)  AS TOTAL_RESTAURANTS
FROM restaurants 
GROUP BY city
ORDER BY TOTAL_RESTAURANTS DESC LIMIT 3;

-- Purpose: Identifies the top 3 cities with the highest concentration of restaurants.

-- Insights:

-- Multi-stage processing:

-- GROUP BY city – group restaurants by city
-- COUNT(*) – count per city
-- ORDER BY TOTAL_RESTAURANTS DESC – sort from most to least restaurants
-- LIMIT 3 – keep only the top 3 rows
-- Geographic market analysis – reveals primary markets/cities where the dataset has strongest coverage

-- Business applications:

-- Where to launch new restaurant features first

-- Which cities need more data collection

-- Competitive density analysis


-- 18. Display the average cost of restaurants for each cuisine.

SELECT cuisine, AVG(cost) AS AVERAGE_COST,cuisine
FROM restaurants 
GROUP BY cuisine;
-- not correct

-- Issues identified:

-- Duplicate column – cuisine appears twice in the SELECT clause (redundant but not an error)

-- Not necessarily "incorrect" – The query will execute successfully, just has redundant column

-- Missing ordering – No ORDER BY makes output unpredictable

-- Potential confusion – Might have been meant to show something else


-- 19. Find cities where the average restaurant rating is greater than 4.0.

SELECT city,AVG(rating) AS AVERAGE_RATING 
FROM restaurants
GROUP BY city
HAVING AVERAGE_RATING >4;

-- Purpose: Identifies cities where restaurants, on average, have ratings above 4.0 out of 5 (or 10, depending on scale).

-- Insights:

-- Quality geography – Maps culinary excellence across cities

-- HAVING with average – Filters cities based on aggregated rating (can't use WHERE here)

-- Threshold filtering – > 4 sets a high bar for "good restaurant cities"

-- Data quality consideration – Cities with very few restaurants might show misleading averages


-- 20. List restaurants whose cost is higher than the average cost of all restaurants.

SELECT name, cost
FROM restaurants
WHERE cost > (SELECT AVG(cost) FROM restaurants);

-- Purpose: Identifies restaurants that are priced above the overall market average, helping users find "premium" or "expensive" establishments.

-- Insights:

-- Correlated subquery alternative – This uses a uncorrelated subquery (the subquery runs independently once)

-- Execution order:

-- SELECT AVG(cost) FROM restaurants – calculates overall average cost (runs once)
-- Result (e.g., ₹450) is used in the outer query
-- SELECT name, cost FROM restaurants WHERE cost > 450 – filters restaurants
-- Dynamic threshold – The threshold automatically updates as data changes

-- Business value:

-- Identifies premium/luxury restaurants

-- Market positioning analysis

-- Helps budget-conscious users avoid expensive options


-- 21. Find the total number of ratings (rating_count) for each city.

SELECT city , SUM(rating_count) AS total_number_of_ratings
FROM restaurants
GROUP BY city 
ORDER BY total_number_of_ratings DESC;

-- Purpose: Calculates the total number of user reviews/ratings submitted for restaurants in each city, then ranks cities by review volume.

-- Insights:

-- SUM aggregation – Adds up all rating_count values (reviews per restaurant) within each city

-- Attention/activity metric – Unlike restaurant count, this measures user engagement and review activity

-- Two ways to interpret:

-- High total ratings = Popular food scene, active reviewer community, larger population

-- Low total ratings = Less reviewed, smaller market, or newer platform adoption

-- Not the same as restaurant count – A city with 50 restaurants (each with 1000 reviews) has 50,000 total ratings, while a city with 200 restaurants (each with 100 reviews) has 20,000 total ratings


-- 22. Display cuisines ordered by their average rating in descending order.

SELECT cuisine , AVG(rating) AS AVERAGE_RATING
FROM restaurants
GROUP BY cuisine
ORDER BY AVERAGE_RATING DESC;

-- Purpose: Ranks cuisine types by their average rating, from highest to lowest quality (based on customer reviews).

-- Insights:

-- Quality ranking – Identifies which cuisines consistently receive the best ratings

-- Group by cuisine – Averages ratings across all restaurants serving that cuisine type

-- DESC ordering – Best-rated cuisines appear first

-- Business applications:

-- Restaurant owners: Which cuisine types to focus on

-- Food delivery apps: Highlight top-rated cuisine categories

-- Consumers: Discover consistently high-quality cuisine types

-- Data quality consideration – Cuisines with few restaurants may have unreliable averages


-- 23. Find restaurants that have the highest rating within their city.

SELECT MAX(rating),name,city
FROM restaurants 
GROUP BY name,city;

-- What This Query Actually Retrieves:
-- Returns: All unique restaurant name and city combinations with their rating (the MAX(rating) is redundant).

-- Complete Insights:
-- 1. Logical Explanation
-- This query groups records by both name and city together, meaning:

-- Each unique pair of (name, city) becomes one group

-- If a restaurant exists in multiple cities (e.g., "Dominos" in Bangalore and "Dominos" in Mumbai), each city gets its own row

-- If the same restaurant has multiple entries in the same city (e.g., different branches or cuisines), they're grouped together

-- MAX(rating) finds the highest rating among that group


-- 24. List cities that have more than one cuisine type available.

WITH city_csn AS(
SELECT COUNT(cuisine) AS Tot_Cuisine,city
FROM restaurants
GROUP BY city)
SELECT city
FROM city_csn
WHERE Tot_Cuisine >1;


-- Purpose: Identifies cities that have culinary diversity - specifically, cities with more than one type of cuisine available.

-- Insights:

-- CTE (Common Table Expression) – WITH city_csn AS (...) creates a temporary named result set for better readability

-- Two-step process:

-- CTE calculates total cuisine count per city (including duplicates)
-- Main query filters for cities with cuisine count > 1
-- ⚠️ Critical flaw – Uses COUNT(cuisine) instead of COUNT(DISTINCT cuisine)

-- What it actually counts: Total number of restaurant entries per city (not unique cuisine types)

-- What the description asks for: "Cities that have more than one cuisine type" (unique cuisines)


-- 25. Find the restaurant(s) with the maximum rating_count in the dataset.

SELECT * FROM restaurants
WHERE rating_count = 
(SELECT MAX(rating_count) FROM restaurants);

-- Purpose: Finds the restaurant(s) with the highest number of user reviews/ratings (most reviewed restaurant in the dataset).

-- Insights:

-- Uncorrelated subquery – Inner query (SELECT MAX(rating_count)...) runs once independently

-- Dynamic threshold – Automatically finds the maximum value, no hardcoded numbers

-- Tie handling – Returns ALL restaurants tied for the maximum (unlike LIMIT 1)

-- Execution order:

-- Inner query finds the single highest rating_count value (e.g., 50,000)
-- Outer query returns all restaurants with rating_count = that value
-- Business value: Identifies the most popular/reviewed restaurants (not necessarily highest rated)


-- 26. Which restaurant of delhi is visited by least number of people?

SELECT * FROM restaurants
WHERE city = "delhi"
AND rating_count = (SELECT MIN(rating_count)
                      FROM restaurants
                      WHERE city = "delhi");
                      

-- Purpose: Finds the least popular restaurant(s) in Delhi based on the lowest number of user reviews/ratings.

-- Insights:

-- Two-level filtering – First restricts to Delhi, then finds minimum rating_count within Delhi

-- Least visited interpretation – Assumes rating_count correlates with footfall/visitors (reasonable for review-based platforms)

-- Tie handling – Returns ALL restaurants tied for the lowest rating_count in Delhi

-- Business value:

-- Identifies struggling restaurants needing investigation

-- Finds hidden gems (new restaurants with few reviews but potentially good)

-- Quality control – very low review counts might indicate data issues


-- 27. Which restaurant has generated maximum revenue all over india?

SELECT name, cost*rating_count AS revenue
FROM restaurants
WHERE cost*rating_count = (SELECT MAX(cost*rating_count)
FROM restaurants);

-- Purpose: Identifies the restaurant(s) that have generated the maximum estimated revenue (cost per meal × number of reviews as a proxy for customers).

-- Insights:

-- Revenue proxy calculation – cost * rating_count estimates total revenue (assuming each review = one customer visit)

-- ⚠️ Significant limitations:

-- Assumes every customer leaves a review (typical review rate is 1-10% of customers)

-- Doesn't account for repeat customers or multiple visits

-- Same cost for all items (uses average cost)

-- No time dimension (lifetime vs monthly revenue)

-- Business value:

-- Identifies top-performing restaurants by estimated gross revenue

-- Investment or acquisition targets

-- Market leaders in each cuisine/city


-- 28. How many restaurants are having rating more than the average rating?

SELECT COUNT(*) AS restaurants_higher_than_average_rating
FROM restaurants
WHERE rating > (SELECT AVG(rating) FROM restaurants);

-- Purpose: Counts how many restaurants have ratings above the overall average rating across all restaurants.

-- Insights:

-- Above-average performers – Identifies restaurants that exceed the mean rating

-- Statistical expectation – Typically ~50% of restaurants should be above average in a normal distribution

-- Skew detection – If result is far from 50%, indicates skewed rating distribution:

-- Much less than 50%: Many restaurants have below-average ratings (negative skew)

-- Much more than 50%: Many restaurants have above-average ratings (positive skew, possibly inflated ratings)

-- Business meaning: Shows how many restaurants are "beating the market average"




-- 29. Which restaurant of Delhi has generated most revenue?

SELECT * FROM restaurants
WHERE city = "delhi" 
AND rating_count*cost = (SELECT MAX(rating_count*cost)
FROM restaurants
WHERE city = "delhi");

-- Purpose: Identifies the highest-grossing restaurant specifically in Delhi based on estimated revenue (cost × review count).

-- Insights:

-- City-specific revenue leader – Finds Delhi's top performer, not national champion

-- Subquery correlation – Inner query filters to Delhi before finding MAX (efficient)

-- Tie handling – Returns all Delhi restaurants tied for maximum estimated revenue

-- Business value: Identifies market leader in India's capital city


-- 30. Which restaurant chain has maximum number of restaurants? COMMON TABLE EXPRESSION

WITH result AS (
SELECT name , COUNT(*) AS chains
FROM restaurants
GROUP BY name ) 
SELECT * FROM result
WHERE chains = (SELECT MAX(chains) FROM result);

-- Purpose: Identifies the restaurant chain(s) with the highest number of locations/branches in the dataset.

-- Insights:

-- Chain identification – Assumes same name across different locations = chain restaurant

-- CTE structure – WITH result AS (...) creates temporary table for cleaner code

-- Two-step process:

-- CTE counts occurrences of each restaurant name
-- Main query filters for chains with maximum count
-- ⚠️ Data quality assumption – Works best if chain branches have identical names (e.g., "Dominos", "McDonald's")

-- Business value: Identifies most expansive food chains


-- 31. Which restaurant chain has generated maximum revenue?

WITH max_rev AS (
SELECT name , SUM(rating_count*cost) AS revenue
FROM restaurants
GROUP BY name
)
SELECT * FROM max_rev
WHERE revenue = (SELECT MAX(revenue) FROM max_rev);


-- Purpose: Finds the restaurant chain that has generated the highest total estimated revenue across all its branches.

-- Insights:

-- Chain-level aggregation – Groups by restaurant name, sums revenue across all branches

-- Total empire value – Shows which chain has largest total business volume

-- Different from Query 28 – A chain with fewer branches but higher per-branch revenue could win

-- Business value: Identifies most commercially successful restaurant brand




  


-- 32. Which city has maximum number of restaurants?

WITH city_max_res AS (
SELECT city , COUNT(*) AS num_res
FROM restaurants
GROUP BY city
)
SELECT city FROM city_max_res
WHERE num_res = (SELECT MAX(num_res) FROM city_max_res );


-- Purpose: Identifies the city with the highest number of restaurants in the dataset.

-- Insights:

-- Market size leader – Shows which city has most restaurant options

-- Simple aggregation – COUNT(*) per city, then find maximum

-- Single city output – Returns one city (or multiple if tie)

-- Data collection bias – May reflect data coverage, not actual restaurant density



 

-- 33. Which city has generated maximum revenue all over india?

WITH city_max_rev AS (
SELECT city , SUM(rating_count*cost) AS revenue
FROM restaurants
GROUP BY city
)
SELECT city FROM city_max_rev
WHERE revenue = ( SELECT MAX(revenue)
FROM city_max_rev );


-- Purpose: Identifies the city that generates the highest total estimated restaurant revenue.

-- Insights:

-- Economic center – Shows which city has largest restaurant economy

-- Revenue concentration – Reveals where most money is spent on dining

-- Different from Query 32 – A city with fewer but premium restaurants could win


-- 34. Which city has generated maximum foot fall all over india?

WITH best_city AS (
SELECT city , SUM(rating_count) AS footfall
FROM restaurants
GROUP BY city
)
SELECT city FROM best_city
WHERE footfall = ( SELECT MAX(footfall)
FROM best_city );


-- Purpose: Identifies the city with the highest total customer footfall (total reviews across all restaurants).

-- Insights:

-- Activity center – Shows which city has most dining-out activity

-- Review culture proxy – May reflect both population and review-writing habits

-- Different from revenue – High footfall but moderate cost = activity without premium pricing





-- 35. List 10 least expensive cuisines? DATA IS NOT CLEAN

SELECT cuisine , cost
FROM restaurants 
ORDER BY cost ASC
LIMIT 10 ; 


-- Purpose: Lists the 10 cheapest and 10 most expensive restaurant entries (not necessarily unique cuisines).

-- ⚠️ Critical Issue Identified: "DATA IS NOT CLEAN" – These queries have significant problems:
 

 

-- 36. List 10 most expensive cuisines?

SELECT cuisine , cost
FROM restaurants 
ORDER BY cost DESC
LIMIT 10 ; 


-- ⚠️ Critical Issue Identified: "DATA IS NOT CLEAN" – These queries have significant problems:


-- 37. What is the city is having Biryani as most popular cuisine

WITH city_biryani AS (
SELECT city,SUM(rating_count) AS popular
FROM restaurants
WHERE cuisine = "biryani"
GROUP BY city
)
SELECT city FROM city_biryani
WHERE popular =(SELECT MAX(popular) FROM city_biryani); 


-- Purpose: Finds the city where Biryani cuisine has the highest total footfall (most customer reviews for Biryani restaurants).

-- Insights:

-- Specialty city – Identifies the Biryani capital based on customer activity

-- Cuisine-city fit – Reveals geographic strongholds for specific dishes

-- ⚠️ Note: Uses SUM(rating_count) not restaurant count – favors cities with highly popular Biryani joints



-- 38. List top 10 unique restaurants with unique name only throughout the dataset
--  as per generate maximum revenue (Single restaurant with that name)

SELECT name,MAX(rating_count*cost) AS revenue
FROM restaurants
GROUP BY name
ORDER BY revenue DESC
LIMIT 10;



-- Purpose: Lists the top 10 unique restaurant names (chains/concepts) by their single highest-grossing branch's estimated revenue.

-- Insights:

-- Per-chain peak performance – Shows best-performing branch of each chain

-- Not total revenue – Different from Query 31 (which sums all branches)

-- Comparisons:

-- Query 31 = total chain revenue (empire size)

-- Query 38 = best single branch (flagship store performance)

-- Business value: Identifies chains with exceptional flagship locations


-- 39. Rank every restaurant from most expensive to least expensive.

SELECT * , RANK()
OVER(ORDER BY cost DESC) AS ranking
FROM restaurants;


-- Purpose: Assigns a rank to every restaurant based on price (most expensive first), with ties receiving the same rank and creating gaps.

-- Insights:

-- Window function introduction – RANK() assigns position without grouping/aggregating rows

-- Gap creation – If two restaurants tie for #1, next gets rank #3 (gap after ties)

-- Full table output – Returns all rows with additional ranking column

-- Use case: Price segmentation, finding most expensive options


-- 40. Rank every restaurant from most visited to least visited.

SELECT * , DENSE_RANK()
OVER(ORDER BY rating_count DESC) AS footfall
FROM restaurants;



-- Purpose: Ranks restaurants by popularity (most reviews/visits) without gaps in ranking numbers.

-- Insights:

-- DENSE_RANK advantage – No gaps: 1,2,2,3 (vs RANK: 1,2,2,4)

-- Footfall proxy – Uses rating_count as measure of visitor volume

-- Better for business – DENSE_RANK often preferred for top-N analysis

-- Use case: "Top 10 most popular restaurants" lists


-- 41. Rank every restaurant from most expensive to least expensive as per their city.

SELECT * ,RANK()
OVER(PARTITION BY city ORDER BY cost DESC) AS ranking
FROM restaurants;


-- Purpose: Ranks restaurants by price within each city separately (most expensive in each city gets rank 1).

-- Insights:

-- PARTITION BY – Restarts ranking for each city

-- Intra-city comparison – "Which restaurant is most expensive in Bangalore?"

-- No gaps within partitions – Gaps exist but reset per city

-- Use case: City-level price leadership analysis


-- 42. Dense-rank every restaurant from most expensive to least expensive as per their city.

SELECT *, DENSE_RANK()
OVER(PARTITION BY city ORDER BY cost DESC) AS ranking
FROM restaurants;


-- Purpose: Same as Query 41 but without ranking gaps within each city.

-- Insights:

-- Within-city dense ranking – No gaps in rank numbers per city

-- Better for city-level top-N – If 3 restaurants tie for most expensive, all get rank 1, next gets rank 2

-- Use case: "Show me top 3 most expensive restaurants in each city"


-- 43. Row-number every restaurant from most expensive to least expensive as per their city.

SELECT *, ROW_NUMBER()
OVER(PARTITION BY city ORDER BY cost DESC) AS row_numbers
FROM restaurants;


-- Purpose: Assigns a unique sequential number to each restaurant within its city based on price order.

-- Insights:

-- Unique per partition – No two restaurants in same city get same row_number

-- Tie-breaking – If costs tie, arbitrary but deterministic ordering (may depend on database)

-- Use case: Pagination, unique ranking for display


-- 44. Rank the restaurant based on their prices (most to least expensive)
-- as per cuisine using rank, dense_rank, and row_number.

SELECT *, RANK()
OVER(PARTITION BY cuisine ORDER BY cost DESC) AS cuisine_ranking
FROM restaurants;

SELECT *, DENSE_RANK()
OVER(PARTITION BY cuisine ORDER BY cost DESC) AS cuisine_dense_ranking
FROM restaurants;

SELECT *, ROW_NUMBER()
OVER(PARTITION BY cuisine ORDER BY cost DESC) AS cuisine_row_numbering
FROM restaurants;


-- Purpose: Ranks restaurants by price within each cuisine type using all three ranking methods.

-- Insights:

-- Cuisine-level price analysis – Identifies premium and budget options within each cuisine

-- Three perspectives – Different ranking methods for different business needs

-- Use case: "Find expensive Japanese restaurants" or "Budget Italian options


-- 45. Find top 5 restaurants of every city as per their revenue.

SELECT name,city,rating_count*cost AS revenue,DENSE_RANK()
OVER(PARTITION BY rating_count*cost ORDER BY city ASC) AS bes_5_rest
FROM restaurants
LIMIT 5,


-- This query has multiple errors:

-- Issues identified:
-- Wrong PARTITION BY – Partitioning by rating_count*cost (the revenue value itself) creates one partition per unique revenue value

-- Missing ORDER BY for ranking – Ranking within revenue-same groups makes no sense

-- LIMIT 5 without ORDER BY – Returns arbitrary 5 rows, not top 5 per city

-- Misleading alias – bes_5_rest doesn't match what query does

-- CORRECT: Top 5 restaurants per city by revenue
SELECT name, city, revenue, city_rank
FROM (
  SELECT 
    name,
    city,
    rating_count * cost AS revenue,
    DENSE_RANK() OVER(PARTITION BY city ORDER BY rating_count * cost DESC) AS city_rank
  FROM restaurants
  WHERE cost IS NOT NULL AND rating_count IS NOT NULL
) ranked
WHERE city_rank <= 5
ORDER BY city, city_rank;


-- 46. Find top 5 restaurants of every cuisine as per their revenue cuisine.

WITH ranking_data AS
(SELECT*,rating_count*cost AS revenue,Row_Number()
OVER(PARTITION BY cuisine ORDER BY rating_count*cost DESC) AS Rowid
FROM restaurants
)
SELECT * FROM ranking_data
WHERE Rowid <=5;


-- Purpose: Finds the top 5 revenue-generating restaurants for each cuisine type.

-- Insights:

-- Correct implementation – Proper CTE with row_number partitioning by cuisine

-- Per-cuisine leaders – Shows best-performing restaurant in each food category

-- Rowid filter – WHERE Rowid <=5 keeps only top 5 per cuisine

-- Use case: "Best Italian restaurants in terms of revenue"




-- 47. List the top 5 cuisines as per the revenue generated by top 5 restaurants of every cuisine.

WITH ranking_data AS
(SELECT *,rating_count*cost AS revenue,row_number()
OVER(PARTITION BY cuisine ORDER BY rating_count*cost DESC) AS Rowid
FROM restaurants
)
SELECT cuisine,SUM(revenue) AS TotalRevenue
FROM ranking_data
WHERE Rowid <=5
GROUP BY cuisine
ORDER BY TotalRevenue DESC
LIMIT 5;


-- Purpose: Identifies the top 5 cuisines by summing the revenue of the top 5 restaurants in each cuisine.

-- Insights:

-- Two-level aggregation:

-- First, identify top 5 restaurants per cuisine
-- Then, sum their revenues and rank cuisines
-- Quality filter – Only considers top performers, not all restaurants of a cuisine

-- Business value: "Which cuisine's best restaurants generate the most money?"



-- 48. List the top 5 cities as per the revenue generated by top 5 restaurants of every city.

WITH ranking_data AS
(SELECT *,rating_count*cost AS revenue , row_number()
OVER(PARTITION BY city ORDER BY rating_count*cost DESC) AS Rowid
FROM restaurants
)
SELECT city,SUM(revenue) AS
Top5_rest_totrevenue
FROM ranking_data
WHERE rowid <=5
GROUP BY city
ORDER BY Top5_rest_totrevenue DESC
LIMIT 5;


-- Purpose: Identifies the top 5 cities by summing the revenue of the top 5 restaurants in each city.

-- Insights:

-- City economic power – Shows which cities have the strongest top-tier restaurants

-- Different from total city revenue – A city with many mediocre restaurants might not rank high here

-- Use case: "Which cities have the most successful premium restaurant scene?"



-- 49. Find the total revenue generated by top 1% restaurants.

WITH ranked_data AS
(SELECT rating_count*cost AS revenue, PERCENT_RANK()
OVER(ORDER BY rating_count*cost DESC) AS percentile_rank
FROM restaurants
)
SELECT SUM(revenue) AS totalrevenue
FROM  ranked_data
WHERE percentile_rank <=.01;


-- Purpose: Calculates the total revenue generated by the top 1% of highest-grossing restaurants.

-- Insights:

-- PERCENT_RANK() – Returns percentile (0 to 1) of each row's position

-- Top 1% threshold – <= .01 captures the highest performing 1% of restaurants

-- Revenue concentration – Reveals how much revenue is concentrated in elite restaurants

-- Pareto analysis – Checks if 1% of restaurants generate disproportionate revenue



-- 50. Find the total revenue generated by top 20% restaurants.

 With ranked_data AS
   (SELECT rating_count*cost AS revenue, PERCENT_RANK()
   OVER(ORDER BY rating_count*cost DESC) AS percentile_rank
   FROM restaurants
   )
   SELECT SUM(revenue) AS totalrevenue
   FROM ranked_data
   WHERE percentile_rank <=.02;
   
   
  --  ⚠️ Note discrepancy: Description says "top 20%" but query uses <= .02 which is top 2% (not 20%).
  
  
  -- Top 20% (as described):
WHERE percentile_rank <= 0.20

-- Top 2% (as implemented in query):
WHERE percentile_rank <= 0.02

-- Alternative using NTILE (more intuitive)
WITH revenue_tiles AS (
  SELECT 
    rating_count * cost AS revenue,
    NTILE(100) OVER(ORDER BY rating_count * cost DESC) as percentile_group
  FROM restaurants
)
SELECT SUM(revenue) as totalrevenue
FROM revenue_tiles
WHERE percentile_group <= 1;  -- Top 1%

-- Top 20% using NTILE
WITH revenue_tiles AS (
  SELECT 
    rating_count * cost AS revenue,
    NTILE(5) OVER(ORDER BY rating_count * cost DESC) as quintile
  FROM restaurants
)
SELECT SUM(revenue) as top_20_percent_revenue
FROM revenue_tiles
WHERE quintile = 1;


## Conclusion:
-- Overall, this dataset provides a practical way to explore SQL operations
-- and gain insights into the restaurant through structured data analysis.
   
   

