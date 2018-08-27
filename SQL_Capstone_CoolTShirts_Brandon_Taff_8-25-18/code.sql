--1 Count Campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;

--Count sources
SELECT Count(DISTINCT utm_source) AS 'Source Count'
FROM page_visits;

--List sources per campaign
SELECT DISTINCT utm_campaign AS Campaigns,
	utm_source AS Sources
FROM page_visits;

--2 find unique pages that are on website
SELECT DISTINCT page_name AS 'Page Names'
FROM pag_visits;

--5 count first touches per campaign
--Create temp table that finds touches by user id
WITH first_touch AS (
	SELECT user_id, 
		MIN(timestamp) AS first_touch_at
			FROM page_visits
			GROUP BY user_id),
--Create 2nd temp table that adds source
--and campaign from page_visits and joins them on 
--user id & timestamps
ft_attr AS (
	SELECT ft.user_id,
	ft.first_touch_at,
	pv.utm_source,
	pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
ON ft.user_id = pv.user_id
AND ft.first_touch_at = pv.timestamp
)

--Select and Count Rows where first touch is associated
--with a campaign & source
SELECT ft_attr.utm_source AS Source,
	ft_attr.utm_campaign AS Campaign,
	COUNT(*) AS COUNT
FROM ft_attr
GROUP BY 1,2
ORDER BY 3 DESC;

--6 Count last touch per campaign--create temp table 
--that finds last touches bu user id
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS last_touch_at
	FROM page_visits
	GROUP BY user_id),

--Create 2nd temp table that ads source & campaign from page_visits 
--and join them on user_id & timestamp

ft_attr AS (
SELECT lt.user_id,
	lt.last_touch_at,
	pv.utm_source,
	pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
ON lt.user_id = pv.user_id
AND lt.last_touch_at = pv.timestamp
)
--Select and count rows where the first tocuh is
--associated with a campaign and source
SELECT ft_attr.utm_source AS Source,
	ft_attr.utm_campaign AS Campaign,
	COUNT(*) As COUNT
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--7 Count distinct users that made a purchase
SELECT COUNT(DISTINCT user_id) AS 'Customers that Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

--8 Count last touch per campaign that led to a purchase
--Create temp table that finds last touches bu user id
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS last_touch_at
	FROM page_visits
--add WHERE clause
WHERE page_name = '4 - purchase'
	GROUP BY user_id),
--Create 2nd temp table that adds source and campaign
--from page_visitsand joins on user_id & timestamp
ft_attr AS (
SELECT lt.user_id,
	lt.last_touch_at,
	pv.utm_source,
	pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
ON lt.user_id = pv.user_id
AND lt.last_touch_at = pv.timestamp
)
--Select and Count Rows where first touch is associated
--with a campaign & source
SELECT ft_attr.utm_source AS Source,
	ft_attr.utm_campaign AS Campaign,
	COUNT(*) AS COUNT
FROM ft_attr
GROUP BY 1,2
ORDER BY 3 DESC;
	


