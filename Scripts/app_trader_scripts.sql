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
SELECT name,review_count,
       CAST(review_count AS INT) AS numeric_review_count
FROM app_store_apps
where rating >= 4.5
order by numeric_review_count desc

/*What is the highest rating available? 5.0
Review count?
Null values
In development?
Top free apps?
What demographic?
Top paid apps?
What apps have the most downloads?
Marketing expense (1,000*12)*lifespan of app*/