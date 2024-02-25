-- ALTER TABLE play_store_apps
-- ALTER COLUMN price TYPE MONEY USING price :: MONEY 

-- ALTER TABLE app_store_apps
-- ALTER COLUMN price TYPE MONEY USING price :: MONEY

-- ALTER TABLE app_store_apps
-- ALTER COLUMN review_count TYPE integer USING review_count :: integer



-------------------------------------------------------------
-- SELECT
-- 	name,
-- 	round((ROUND(AVG(avg_rating)*2,0)/2),2) AS avg_app_rating_combined,
-- 	round(avg(review_count_avg),0) as avg_review_count,
-- 	price
-- FROM (
-- 	--------------- Start of Subquery --------------
-- 	SELECT 
-- 	 	name,
-- 	 	AVG(rating) AS avg_rating,
-- 	 	price,
-- 	 	AVG(review_count) AS review_count_avg,
-- 	 	content_rating,
-- 	 	primary_genre, 'apple' AS app_store
-- 	FROM 
-- 		public.app_store_apps
-- 	WHERE 
-- 		name IN(
-- 			SELECT
-- 			 	name
-- 			FROM 
-- 				public.play_store_apps)
-- 	GROUP BY
-- 	 	name,
-- 	 	price,
-- 	 	content_rating,
-- 	 	primary_genre
--     ----------
-- 	UNION ALL
--     ----------
-- 	SELECT 
-- 	 	name,
-- 	 	AVG(rating) AS avg_rating,
-- 	 	price,
-- 	 	AVG(review_count) AS review_count_avg, 
-- 	 	content_rating,
-- 	 	genres, 'google' AS app_store
-- 	FROM 
-- 	 	public.play_store_apps
-- 	WHERE 
-- 		name IN(
-- 			SELECT
-- 				name
-- 			FROM 
-- 				public.app_store_apps)
-- 	GROUP BY
-- 	 	name,
-- 	 	price, content_rating,
-- 	 	genres
-- 	ORDER BY
-- 		name
-- 		--------------- End of Subquery ---------------
-- 		)
-- GROUP BY
-- 	name,
-- 	price
-- having
-- 	round((ROUND(AVG(avg_rating)*2,0)/2),2) >= 4.5
-- 	and price <= '$1.00'
-- ORDER BY
-- 	avg_app_rating_combined DESC,
-- 	avg_review_count DESC,
-- 	name
-- limit 20;
--------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
select distinct
	name,
	--count(*) as duplicate_name,
	round((round(avg(avg_rating)*2,0)/2),2) as final_avg_rating,
	round(avg(avg_review_count)) as final_avg_review_count
from
--------
		(select distinct
			name,
			avg_rating,
			price,
			avg_review_count,
			app_store
		from 
		--------
				(select distinct
					name,
					round((round(avg(rating)*2,0)/2),2) as avg_rating,
					price,
					round(avg(review_count)) as avg_review_count,
					'google' as app_store
				from 
					play_store_apps
				 where
					rating >= 3.5 and
					price <= '$1.00'
				group by
					name,
					price,
					app_store
				order by
					name	 
				)as play_store_apps
		--------
		group by
			name,
			price,
			avg_rating,
			avg_review_count,
			app_store

		union all----------------

		select distinct
			name,
			avg_rating,
			price,
			avg_review_count,
			app_store
		from
		--------
				(select distinct
					name,
					round((round(avg(rating)*2,0)/2),2) as avg_rating,
					price,
					round(avg(review_count)) as avg_review_count,
					'apple' as app_store
				from
					app_store_apps
				where
					rating >= 3.5 and
					price <= '$1.00'
				group by
					name,
					price,
					app_store
				order by
					name
				)as app_store_apps
		--------
		where 
			avg_rating >=3.5 and
			avg_rating IS NOT NULL
		group by
			name,
			price,
			avg_rating,
			avg_review_count,
			app_store
		order by
			name
		) as both_app_stores
--------
group by
	name
having 
	count(*) = 2
order by final_avg_rating desc,
	final_avg_review_count desc,
	name
limit 20;


-----------------------TOP 20 APPS WITH THE HIGHEST RATING, FOLLOWED BY THE HIGHEST REVIEW COUNT -------------------------------

	"name"						"final_avg_rating"			"final_avg_review_count"

"Geometry Dash Lite"					5.00							3276005
"PewDiePie's Tuber Simulator"			5.00							795159
"Domino's Pizza USA"					5.00							645780
"Egg, Inc."								5.00							329617
"Fernanfloo"							5.00							264741
"The Guardian"							5.00							128084
"ASOS"									5.00							95768
"WhatsApp Messenger"					4.50							34701845
"Instagram"								4.50							34361028
"Clash of Clans"						4.50							23510250
----------------------------------------------------  TOP 10  ----------------------------------------------------------------
"Subway Surfers"						4.50							14214052
"Clash Royale"							4.50							11699748
"Candy Crush Saga"						4.50							11694693
"My Talking Tom"						4.50							7506751
"Shadow Fight 2"						4.50							5539831
"Hay Day"								4.50							5310265
"Pou"									4.50							5244367
"My Talking Angela"						4.50							4967709
"Hill Climb Racing"						4.50							4515680
"Asphalt 8: Airborne"					4.50							4289141
---------------------------------------------------------------------------------------------------------------------------------

	
	