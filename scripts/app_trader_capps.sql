SELECT *
FROM play_store_apps;

SELECT *
FROM app_store_apps;

SELECT name,review_count,
       CAST(review_count AS INT) AS numeric_review_count
FROM app_store_apps
where rating >= 4.5
order by numeric_review_count desc;
