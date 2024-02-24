ALTER TABLE play_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY
ALTER TABLE app_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY
ALTER TABLE app_store_apps
ALTER COLUMN review_count TYPE integer USING review_count :: integer
------




----
SELECT name, primary_genre, rating, round(AVG(review_count)) AS avg_review_count, 'apple' AS app_store,
	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as content_rating
FROM app_store_apps as a
WHERE rating >= 4.2
	and price <='$1.00'
	and review_count >= 400000
	--and primary_genre ilike 'sports'
GROUP BY name, rating, primary_genre, content_rating
--order by  avg_review_count DESC
----
union all
----
SELECT name, genres, rating, round(AVG(review_count)) AS avg_review_count, 'google' AS app_store, content_rating
FROM play_store_apps as p
WHERE rating >= 4.2
	and price <= '$1.00'
	and review_count >= 500000
	--and genres ilike 'sports'
GROUP BY name, rating, genres, content_rating
order by name, rating DESC, avg_review_count DESC

--

SELECT name, primary_genre, rating, price, round(AVG(review_count)) AS avg_review_count, 'apple' AS app_store,

--

	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as content_rating
FROM app_store_apps as a
WHERE rating >= 4.5
	and price <= '$1.00'
	and review_count >= 400000
	--and primary_genre ilike 'sports'
GROUP BY name, rating, primary_genre, content_rating, price
--order by  avg_review_count DESC
----
union all
----
SELECT name, genres, rating, price, round(AVG(review_count)) AS avg_review_count, 'google' AS app_store, content_rating
FROM play_store_apps as p
WHERE rating >= 4.5
	and price <= '$1.00'
	and review_count >= 10000000
	--and genres ilike 'sports'
GROUP BY name, rating, genres, content_rating, price
order by rating DESC, avg_review_count DESC



SELECT DISTINCT t1.name
FROM app_store_apps t1
WHERE EXISTS (
    SELECT 1
    FROM play_store_apps t2
    WHERE t1.name <> t2.name
      AND CHARINDEX(t1.name, t2.name) > 0)
	  
----

SELECT name, price, primary_genre, ROUND(AVG(rating) * 2, 0)/2, round(AVG(review_count)) AS avg_review_count, 'apple' AS app_store,
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
SELECT name, price, genres, ROUND(AVG(rating) * 2, 0)/2, round(AVG(review_count)) AS avg_review_count, 'google' AS app_store, content_rating
FROM play_store_apps as p
WHERE rating >= 3
	and price <= '$1.00'
	and review_count >= 5000000
	--and genres ilike 'sports'
GROUP BY name, genres, content_rating, price
order by name, avg_review_count DESC
	  
-----
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
ORDER BY name

--

SELECT name, rating, CAST(price AS MONEY), AVG(CAST(review_count AS INT)), 'apple' AS app_store
FROM app_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price
UNION ALL
SELECT name, rating, CAST(price AS MONEY), AVG(CAST(review_count AS INT)), 'google' AS app_store
FROM play_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM app_store_apps)
GROUP BY name, rating, price
ORDER BY name, rating


select round(avg(review_count)), primary_genre, count(primary_genre)		
from app_store_apps
where rating >=3.5 and price = '$0.00'
group by primary_genre
order by count(primary_genre) DESC, avg(review_count) DESC

--

select round(avg(review_count)), genres, count(genres)	        	
from play_store_apps
where rating >=3.5 and price = '$0.00'
group by genres
order by count(genres) DESC, avg(review_count) DESC

---

SELECT name, (ROUND(AVG(avg_rating)*2,0)/2) AS avg_app_rating_combined
FROM
(SELECT name, AVG(rating) AS avg_rating, price,   content_rating, primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE rating >=3.5
AND price <= '1.00'
AND name IN
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name, AVG(rating) AS avg_rating,  AVG(review_count) AS review_count_avg, content_rating, genres, 'google' AS app_store
FROM public.play_store_apps
WHERE rating >=3.5

AND name IN
	(SELECT name
		FROM public.app_store_apps)
GROUP BY name, price, content_rating, genres
ORDER BY name)
GROUP BY name
ORDER BY avg_app_rating_combined DESC;

--


SELECT name, round((ROUND(AVG(avg_rating)*2,0)/2),2) AS avg_app_rating_combined
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
ORDER BY avg_app_rating_combined DESC, name;
