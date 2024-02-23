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

Select *
FROM app_store_apps
WHERE name iLIKE '%8%b%'

Select *
From play_store_apps
WHERE name iLIKE '%8%b%'

SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), 'apple' AS app_store
FROM app_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price
UNION ALL
SELECT name, rating, CAST(price AS MONEY), ROUND(AVG(CAST(review_count AS INT)),2), 'google' AS app_store
FROM play_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN 
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






