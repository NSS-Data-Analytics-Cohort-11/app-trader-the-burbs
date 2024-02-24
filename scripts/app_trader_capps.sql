ALTER TABLE play_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY

ALTER TABLE app_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY

ALTER TABLE app_store_apps
ALTER COLUMN review_count TYPE integer USING review_count :: integer

SELECT ROUND(rating * 2, 0)/2
FROM play_store_apps
WHERE name = 'Mandala Coloring Book';


SELECT *
FROM app_store_apps;

SELECT name, price, primary_genre, ROUND(AVG(rating) * 2, 0)/2 AS avg_rating, round(AVG(review_count)) AS avg_review_count, 'apple' AS app_store,
	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as content_rating
FROM app_store_apps as a
WHERE rating >= 3
	and price <= '$1.00'
	and review_count >= 400000
	--and primary_genre ilike 'sports'
GROUP BY name, primary_genre, content_rating, price
--order by  avg_review_count DESC
----
union all
----
SELECT name, price, genres, ROUND(AVG(rating) * 2, 0)/2 AS avg_rating, round(AVG(review_count)) AS avg_review_count, 'google' AS app_store, content_rating
FROM play_store_apps as p
WHERE rating >= 3
	and price <= '$1.00'
	and review_count >= 5000000
	--and genres ilike 'sports'
GROUP BY name, genres, content_rating, price
order by name, avg_review_count DESC

SELECT name,
       ROUND(AVG(CAST(review_count AS INT)),2) AS avg_numeric_review_count,
	   rating,
	   price
FROM app_store_apps
WHERE rating >= 4.5 AND name IN (
	Select name
	FROM play_store_apps
	WHERE rating >= 4.5)
GROUP BY name, rating, price
order by avg_numeric_review_count desc

SELECT name,(ROUND(AVG(rating)*2,0)/2) AS avg_rating,price,AVG(CAST(review_count AS INT)) AS review_count_avg,content_rating,primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE rating >=3.5
AND price <= '1.00'
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name,(ROUND(AVG(rating)*2,0)/2) AS avg_rating,(CAST(REPLACE(price, '$', '') AS NUMERIC)),AVG(review_count) AS review_count_avg,content_rating,genres, 'google' AS app_store
FROM public.play_store_apps
WHERE rating >=3.5
AND price <= '1.00'
GROUP BY name, price, content_rating, genres
ORDER BY name;

SELECT name, rating, CAST(price AS MONEY), AVG(CAST(review_count AS INT)) AS review_count_avg, 'apple' AS app_store, primary_genre
FROM app_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price, primary_genre
UNION ALL
SELECT name, rating, CAST(price AS MONEY), AVG(CAST(review_count AS INT)) AS review_count_avg, 'google' AS app_store, genres
FROM play_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM app_store_apps)
GROUP BY name, rating, price, genres
ORDER BY name, rating

SELECT name, ROUND((ROUND(AVG(avg_rating)*2,0)/2),2) AS avg_app_rating_combined, ROUND(AVG(review_count_avg),2) AS avg_review_count
FROM
(SELECT name, AVG(rating) AS avg_rating, price, AVG(review_count) AS review_count_avg, content_rating, primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE rating >=3.5
AND price <= '1.00'
AND name IN
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name, AVG(rating) AS avg_rating, price, AVG(review_count) AS review_count_avg, content_rating, genres, 'google' AS app_store
FROM public.play_store_apps
WHERE rating >=3.5
AND price <= '1.00'
AND name IN
	(SELECT name
		FROM public.app_store_apps)
GROUP BY name, price, content_rating, genres
ORDER BY name)
GROUP BY name
ORDER BY avg_app_rating_combined DESC, avg_review_count DESC;

SELECT name, ROUND((ROUND(AVG(avg_rating)*2,0)/2),2) AS avg_app_rating_combined, ROUND(AVG(review_count_avg),2) AS avg_review_count, price
FROM
(SELECT name, AVG(rating) AS avg_rating, price, AVG(review_count) AS review_count_avg, content_rating, primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE name IN
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name, AVG(rating) AS avg_rating, price, AVG(review_count) AS review_count_avg, content_rating, genres, 'google' AS app_store
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



