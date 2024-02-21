SELECT *
FROM public.app_store_apps
SELECT *
FROM public.play_store_apps

SELECT name,size_bytes,rating,price,CAST(review_count AS INT),content_rating,primary_genre,'apple' AS app_store
FROM public.app_store_apps
UNION ALL
SELECT name,size,rating,CAST(REPLACE(price, '$', '')::NUMERIC),review_count,content_rating,genres,'google' AS app_store
FROM public.play_store_apps;

SELECT name,review_count,
       CAST(review_count AS INT) AS numeric_review_count
FROM app_store_apps
where rating >= 4.5
order by numeric_review_count desc