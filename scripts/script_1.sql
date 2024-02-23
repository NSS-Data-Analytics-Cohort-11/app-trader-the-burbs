SELECT name,(ROUND(AVG(rating)*2,0)/2) AS avg_rating,price,AVG(CAST(review_count AS INT)) AS review_count_avg,content_rating,primary_genre, 'apple' AS app_store
FROM public.app_store_apps
WHERE rating >=3.5
AND price <= '1.00'
AND name IN 
	(SELECT name
		FROM public.play_store_apps)
GROUP BY name, price, content_rating, primary_genre
UNION ALL
SELECT name,(ROUND(AVG(rating)*2,0)/2) AS avg_rating,(CAST(REPLACE(price, '$', '') AS NUMERIC)),AVG(review_count) AS review_count_avg,content_rating,genres, 'google' AS app_store
FROM public.play_store_apps
WHERE rating >=3.5
AND (CAST(REPLACE(price, '$', '') AS NUMERIC)) <= '1.00'
AND name IN 
	(SELECT name
		FROM public.app_store_apps)
GROUP BY name, price, content_rating, genres
ORDER BY name;

