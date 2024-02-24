select name, rating
from app_store_apps
UNION ALL
select name, rating
from play_store_apps

select *
from app_store_apps
where name ilike 'Netflix'

select *
from play_store_apps

select *
from app_store_apps
where rating >= 4.5
Order BY review_count DESC

--Query below allows matching table review count.
--Add union to combine tables.
SELECT TRIM(name),
       ROUND(AVG(CAST(review_count AS INT)),2) AS avg_numeric_review_count,
	   rating,
	   price
FROM app_store_apps
WHERE rating >= 4.5 AND name IN (
	Select TRIM(name)
	FROM play_store_apps
	WHERE rating >= 4.5)
GROUP BY name, rating, price
order by avg_numeric_review_count desc


SELECT TRIM(name),
       ROUND(AVG(CAST(review_count AS INT)),2) AS avg_numeric_review_count,
	   rating,
	   price
FROM play_store_apps
WHERE rating >= 4.5 AND name IN (
	Select TRIM(name)
	FROM app_store_apps
	WHERE rating >= 4.5)
GROUP BY name, rating, price
order by avg_numeric_review_count desc

/*"Instagram"
"Clash of Clans"
"Pinterest"
"Bible"
"Subway Surfers"
"Solitaire"
"Hay Day"
"Sonic Dash"
"Trivia Crack"
"Geometry Dash Lite"

"Instagram"
"Clash of Clans"
"Subway Surfers"
"Clash Royale"
"My Talking Tom"
"Shadow Fight 2"
"Hay Day"
"My Talking Angela"
"Asphalt 8: Airborne"
"PicsArt Photo Studio: Collage Maker & Pic Editor"*/

Select name REPLACE(name,'™','') AS name
FROM app_store_apps
WHERE name iLIKE '%8%b%'

Select *
From play_store_apps
WHERE name iLIKE '%8%b%'

SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), 'apple' AS app_store
FROM app_store_apps
WHERE CAST(price AS MONEY) <= '1.00' AND rating >= 4.5 AND  name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price
UNION ALL
SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), 'google' AS app_store
FROM play_store_apps
WHERE CAST(price AS MONEY) <= '1.00' AND rating >= 4.5 AND name IN 
	(SELECT name
	FROM app_store_apps)
GROUP BY name, rating, price
ORDER BY name, rating

--Good query above, but not showing 8 Ball Pool app.

/*What is the highest rating available? 5.0
Review count?
Null values
In development?
Top free apps?
What demographic?
Top paid apps?
What apps have the most downloads?
Marketing expense (1,000*12)*lifespan of app*/

--Trying replace on name to get 8 ball app.
SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), primary_genre, 'apple' AS app_store
FROM app_store_apps
WHERE CAST(price AS MONEY) <= '1.00' AND rating >= 4.5 AND  name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price, primary_genre
UNION ALL
SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), genres, 'google' AS app_store
FROM play_store_apps
WHERE CAST(price AS MONEY) <= '1.00' AND rating >= 4.5 AND name IN 
	(SELECT name
	FROM app_store_apps)
GROUP BY name, rating, price, genres
ORDER BY name, rating

-- Updated query to show combined average app rating bewteen app stores with more liberal rating value to capture more apps.
SELECT name, (ROUND(AVG(avg_rating)*2,0)/2) AS avg_app_rating_combined
FROM
(SELECT name, AVG(rating) AS avg_rating, price, AVG(CAST(review_count AS INT)) AS review_count_avg, content_rating, primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE rating >=3.5
AND price <= '1.00'
AND name IN
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name, AVG(rating) AS avg_rating, (CAST(REPLACE(price, '$', '') AS NUMERIC)), AVG(review_count) AS review_count_avg, content_rating, genres, 'google' AS app_store
FROM public.play_store_apps
WHERE rating >=3.5
AND (CAST(REPLACE(price, '$', '') AS NUMERIC)) <= '1.00'
AND name IN
	(SELECT name
		FROM public.app_store_apps)
GROUP BY name, price, content_rating, genres
ORDER BY name)
GROUP BY name
ORDER BY avg_app_rating_combined DESC, name;

--final query showing
SELECT name, ROUND((ROUND(AVG(avg_rating)*2,0)/2),2) AS avg_app_rating_combined, ROUND(AVG(review_count_avg),2) AS avg_review_count, price
FROM
(SELECT name, AVG(rating) AS avg_rating, price, AVG(CAST(review_count AS INT)) AS review_count_avg, content_rating, primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE name IN
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name, AVG(rating) AS avg_rating, (CAST(REPLACE(price, '$', '') AS NUMERIC)), AVG(review_count) AS review_count_avg, content_rating, genres, 'google' AS app_store
FROM public.play_store_apps
WHERE name IN
	(SELECT name
		FROM public.app_store_apps)
GROUP BY name, price, content_rating, genres
ORDER BY name)
WHERE price <= '1.00'
GROUP BY name, price
HAVING ROUND((ROUND(AVG(avg_rating)*2,0)/2),2) >=3.5
ORDER BY avg_app_rating_combined DESC, avg_review_count DESC
LIMIT 10;






