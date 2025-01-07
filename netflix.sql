-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
-- 1. Count the number of Movies vs TV Shows 
select type, count(*) as total_numbers  from netflix
group by 1;

-- 2. Find the most common rating for movies and TV shows
select type, rating from (
select type, rating,  dense_rank() over(partition by type order by count(*) desc) as ranking
 from netflix
 group by 1,2) sub 
 where ranking = 1;
 
 -- 3. List all movies released in a specific year (e.g., 2020)
 select  * from netflix
 where release_year =2020;
 
 
-- 4. Find the top 5 countries with the most content on Netflix
 CREATE TABLE numbers (n INT);
INSERT INTO numbers (n) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
select count(*) as total_content , name from (
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1) AS name
FROM netflix
JOIN numbers 
ON numbers.n <= LENGTH(country) - LENGTH(REPLACE(country, ',', '')) + 1) sub
where name != ''
group by 2
order by 1 desc
limit 5;


-- 5. Identify the longest movie
select * from netflix 
where type = 'Movie'
and  duration = (select max(duration) from netflix);

-- 6. Find content added in the last 5 years
SELECT * from netflix
where str_to_date(date_added, '%M %d, %Y') >= current_date  - interval 5 year;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix
where director like '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
select * from netflix
where type ='TV Show'
having left(duration,1) >= 5;
 
-- 9. Count the number of content items in each genre
SELECT count(*) as total_items,
    SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1) AS name
FROM netflix
JOIN numbers 
ON numbers.n <= LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) + 1
group by 2;
 
-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
select  extract(year from str_to_date(date_added, '%M %d, %Y')) as year
 ,count(show_id) as total_release,
count(show_id)*100/(select count(*) from netflix where country ='India') as average
 from netflix
where country = 'India'
group by 1
order by 3 desc 
limit 5;

-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director ='';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	cast LIKE '%Salman Khan%'
	AND 
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT count(*) as total_items,
    SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1) AS name
FROM netflix
JOIN numbers 
ON numbers.n <= LENGTH(cast) - LENGTH(REPLACE(cast, ',', '')) + 1
where SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1) != ''
and country = 'India'
group by 2
order by 1 desc limit 10;


/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
SELECT 
    category, TYPE, COUNT(*) AS content_count
FROM (SELECT 
		*,CASE WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'END AS category
    FROM netflix) AS categorized_content
GROUP BY 1,2
ORDER BY 2
















 