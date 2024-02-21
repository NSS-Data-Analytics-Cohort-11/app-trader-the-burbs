select *
from public.app_store_apps
where name ilike 'instagram'

select * --distinct name
from play_store_apps
where name IN (select distinct name
			  from play_store_apps
			  where name ilike 'instagram')
	

SELECT name,review_count,
       CAST(review_count AS INT) AS numeric_review_count
FROM app_store_apps
where rating >= 4.5
order by numeric_review_count desc


select distinct name, size_bytes, rating, content_rating, primary_genre, CAST(review_count AS INT), 'apple' AS app_store
from app_store_apps
where name ilike 'instagram'
union
select  name, size, rating, review_count, content_rating, genres, 'google' AS app_store
FROM play_store_apps
where name ilike 'instagram'
where review_count =
				(select review_count, avg(review_count)
				 from play_store_apps
				 where name ilike 'instagram'
				group by review_count)

