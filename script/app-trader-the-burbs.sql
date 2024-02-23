ALTER TABLE play_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY 

ALTER TABLE app_store_apps
ALTER COLUMN price TYPE MONEY USING price :: MONEY

ALTER TABLE app_store_apps
ALTER COLUMN review_count TYPE integer USING review_count :: integer



select * --distinct content_rating
from public.app_store_apps
WHERE price > '$3.99'

select distinct name, review_count --distinct content_rating
from play_store_apps
order by review_count desc

-- SELECT name,review_count,
--        CAST(review_count AS INT) AS numeric_review_count
-- FROM app_store_apps
-- where rating >= 4.5
-- order by numeric_review_count desc


select name, size_bytes, rating, content_rating, primary_genre, CAST(review_count AS INT), 'apple' AS app_store
from app_store_apps
where name ilike 'instagram'
union
select name, size, rating, content_rating, genres, review_count, 'google' AS app_store
FROM play_store_apps
where name ilike 'instagram'



SELECT name, rating, review_count, price, primary_genre, 'apple' AS app_store
FROM app_store_apps
UNION
SELECT name, rating, review_count, price, genres, 'google' AS app_store
FROM play_store_apps
WHERE rating IS NOT NULL
ORDER BY review_count DESC, rating DESC--, review_count DESC




SELECT name, rating, price, AVG(review_count), 'apple' AS app_store
FROM app_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM play_store_apps)
GROUP BY name, rating, price
UNION ALL
SELECT name, rating, price, AVG(review_count), 'google' AS app_store
FROM play_store_apps
WHERE rating >= 4.5 AND price <= '1.00' AND name IN
	(SELECT name
	FROM app_store_apps)
GROUP BY name, rating, price
ORDER BY name, rating







SELECT name, primary_genre, round(avg(rating) *2,0)/2 as avg_rating, round(AVG(review_count)) AS avg_review_count, 'apple' AS app_store,
	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as content_rating
FROM app_store_apps as a
WHERE rating >= 4.3
	and price <= '$1.00'
	and review_count >= 400000
GROUP BY name, rating, primary_genre, content_rating, price
----
union all
----
SELECT name, genres, round(avg(rating) *2,0)/2 as avg_rating, round(AVG(review_count)) AS avg_review_count, 'google' AS app_store, content_rating
FROM play_store_apps as p
WHERE rating >= 4.3
	and price <= '$1.00'
	and review_count >= 10000000
GROUP BY name, rating, genres, content_rating, price
order by name, avg_review_count DESC

round(avg(rating) *2,0)/2


SELECT name,
       ROUND(avg(review_count)) AS avg_numeric_review_count,
	   round(avg(rating) *2,0)/2 AS avg_rating,
	   price
FROM app_store_apps
WHERE rating >= 3.5 AND name IN (
	Select name
	FROM play_store_apps)
GROUP BY name, price, rating
order by name, rating desc, avg_numeric_review_count desc
---
SELECT name,
       ROUND(AVG(review_count),0) AS avg_review_count,
	   rating,
	   price
FROM play_store_apps
WHERE rating >= 3.5 AND name IN (
	Select name
	FROM app_store_apps)
GROUP BY name, price, rating
order by rating desc, avg_review_count desc





select rating, name, review_count, primary_genre,			--top 20 highest review counts of app store
	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as text_content_rating
from app_store_apps  										   
where rating >= 3.5 
	and price <= '$1.00' 
	--and primary_genre = '4+'
order by price, review_count DESC
3.5	"Facebook"	2974676	"Social Networking"	"$0.00"	"Everyone"
4.5	"Instagram"	2161558	"Photo & Video"	"$0.00"	"Teen"
4.5	"Clash of Clans"	2130805	"Games"	"$0.00"	"Everyone 10+"
4.5	"Temple Run"	1724546	"Games"	"$0.00"	"Everyone 10+"
4.0	"Pandora - Music & Radio"	1126879	"Music"	"$0.00"	"Teen"
4.5	"Pinterest"	1061624	"Social Networking"	"$0.00"	"Teen"
4.5	"Bible"	985920	"Reference"	"$0.00"	"Everyone"
4.5	"Candy Crush Saga"	961794	"Games"	"$0.00"	"Everyone"
4.5	"Spotify Music"	878563	"Music"	"$0.00"	"Teen"
4.5	"Angry Birds"	824451	"Games"	"$0.00"	"Everyone"
4.5	"Subway Surfers"	706110	"Games"	"$0.00"	"Everyone 10+"
4.5	"Solitaire"	679055	"Games"	"$0.00"	"Everyone"
4.5	"CSR Racing"	677247	"Games"	"$0.00"	"Everyone"
4.5	"Crossy Road - Endless Arcade Hopper"	669079	"Games"	"$0.00"	"Everyone 10+"
4.5	"Injustice: Gods Among Us"	612532	"Games"	"$0.00"	"Teen"
4.5	"Hay Day"	567344	"Games"	"$0.00"	"Everyone"
4.5	"Calorie Counter & Diet Tracker by MyFitnessPal"	507706	"Health & Fitness"	"$0.00"	"Everyone"
4.5	"DragonVale"	503230	"Games"	"$0.00"	"Everyone"
3.5	"The Weather Channel: Forecast, Radar & Alerts"	495626	"Weather"	"$0.00"	"Everyone"
5.0	"Head Soccer"	481564	"Games"	"$0.00"	"Everyone"


select rating, name, 										--top 20 highest review counts of play store
	round(avg(review_count)) AS avg_review_count, genres, price, content_rating
from play_store_apps                           				 
where rating >= 3.5 and price = '$0.00'
group by name, genres, rating, price, content_rating
order by price, avg(review_count) DESC
4.1	"Facebook"	78143257	"Social"	"$0.00"	"Teen"
4.4	"WhatsApp Messenger"	69116101	"Communication"	"$0.00"	"Everyone"
4.5	"Instagram"	66560497	"Social"	"$0.00"	"Teen"
4.0	"Messenger – Text and Video Chat for Free"	56644091	"Communication"	"$0.00"	"Everyone"
4.6	"Clash of Clans"	44889695	"Strategy"	"$0.00"	"Everyone 10+"
4.7	"Clean Master- Space Cleaner & Antivirus"	42916526	"Tools"	"$0.00"	"Everyone"
4.5	"Subway Surfers"	27721993	"Arcade"	"$0.00"	"Everyone 10+"
4.3	"YouTube"	25639427	"Video Players & Editors"	"$0.00"	"Teen"
4.7	"Security Master - Antivirus, VPN, AppLock, Booster"	24900999	"Tools"	"$0.00"	"Everyone"
4.6	"Clash Royale"	23132575	"Strategy"	"$0.00"	"Everyone 10+"
4.4	"Candy Crush Saga"	22427591	"Casual"	"$0.00"	"Everyone"
4.5	"UC Browser - Fast Download Private & Secure"	17713565	"Communication"	"$0.00"	"Teen"
4.0	"Snapchat"	17011253	"Social"	"$0.00"	"Teen"
4.6	"360 Security - Free Antivirus, Booster, Cleaner"	16771865	"Tools"	"$0.00"	"Everyone"
4.5	"My Talking Tom"	14889643	"Casual"	"$0.00"	"Everyone"
4.5	"8 Ball Pool"	14198028	"Sports"	"$0.00"	"Everyone"
4.5	"DU Battery Saver - Battery Charger & Battery Life"	13479633	"Tools"	"$0.00"	"Everyone"
4.3	"BBM - Free Calls & Messages"	12843148	"Communication"	"$0.00"	"Everyone"
4.5	"Cache Cleaner-DU Speed Booster (booster & cleaner)"	12759739	"Tools"	"$0.00"	"Everyone"
4.3	"Twitter"	11664259	"News & Magazines"	"$0.00"	"Mature 17+"



select round(avg(review_count)), primary_genre, count(primary_genre)		--top 20 genres of app store
from app_store_apps
where rating >=3.5 and price = '$0.00'
group by primary_genre
order by count(primary_genre) DESC, avg(review_count) DESC
23477	"Games"	1772 in
13986	"Entertainment"	199 in
29258	"Photo & Video"	133  in
6697	"Education"	101 in
22390	"Shopping"	90 in
80035	"Social Networking"	89 in
18318	"Utilities"	77 in with tools & personalization
65073	"Music"	58
25988	"Health & Fitness"	58 in
21082	"Productivity"	56 in
17659	"Lifestyle"	47 in
34586	"Sports"	39 in
26563	"Travel"	39 in
32898	"Finance"	33 in
25114	"News"	33 in
33071	"Food & Drink"	26
63638	"Weather"	23
24379	"Book"	23
89930	"Reference"	15
8776	"Business"	14 in


select round(avg(review_count)), genres, count(genres)	        		 --top 20 genres of play store
from play_store_apps
where rating >=3.5 and price = '$0.00'
group by genres
order by count(genres) DESC, avg(review_count) DESC
473740	"Tools"	575
211478	"Entertainment"	464
36401	"Education"	425
1064397	"Action"	328
365113	"Productivity"	312
655231	"Sports"	294
2821343	"Communication"	289
61336	"Finance"	279
769878	"Photography"	277
147073	"Health & Fitness"	257
50056	"Lifestyle"	252
55251	"Business"	251
2525349	"Social"	246
368860	"Personalization"	241
6645	"Medical"	232
508839	"Shopping"	226
260041	"News & Magazines"	209
324133	"Travel & Local"	193
1849454	"Arcade"	182
198159	"Simulation"	173




select count(content_rating) as count_content_rating,      	 --------content_rating of app store DESC
	case when content_rating = '4+' then 'Everyone'
		 when content_rating = '9+' then 'Everyone 10+'
		 when content_rating = '12+' then 'Teen'
		 when content_rating = '17+' then 'Mature 17+'
	else 'unrated'
	end as text_content_rating
from app_store_apps
where rating >=3.5 and price = '$0.00'
group by text_content_rating
order by count(content_rating) DESC
1862 "Everyone"
513	 "Teen"
333	 "Everyone 10+"
236	 "Mature 17+"


select count(content_rating), content_rating                 ---------content_rating of play store DESC
from play_store_apps
where rating >=3.5 and price = '$0.00'
group by content_rating
order by count(content_rating) DESC
6284 "Everyone"
991	 "Teen"
405	 "Mature 17+"
354	 "Everyone 10+"
3	 "Adults only 18+"
1	 "Unrated"


select name, rating, content_rating, review_count, price, primary_genre
from app_store_apps
where name in (select name from play_store_apps) 
and primary_genre in (select genres from play_store_apps)
order by name
	--and content_rating in (select content_rating from play_store_apps)
	



SELECT avg(rating)
FROM app_store_apps
WHERE avg(rating) IN (
	Select avg(rating)
	FROM play_store_apps)
-- GROUP BY name, price, rating
-- order by name, rating desc, avg_numeric_review_count desc

select name, rating
from app_store_apps
intersect all
select name, rating
from play_store_apps
order by name


select name
from app_store_apps
inner join play_store_apps
using (name)

