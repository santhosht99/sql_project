# Famous Paintings & Museum -Data Analysis with SQL

## Project Overview
This project involves solving a series of SQL queries using the **Famous Paintings & Museum** dataset. The goal is to explore and analyze data related to paintings and museums, focusing on various aspects such as pricing, availability, and popularity.

## Dataset

The project utilizes the **Famous Paintings & Museum dataset** sourced from Kaggle. You can find the dataset at the following link:

- [Dataset Link](<https://www.kaggle.com/datasets/mexwell/famous-paintings>)


## Dataset Description
The dataset contains information about:
- Paintings
- Museums
- Artists
- Canvas sizes
- Museum hours

### Key Tables
1. **Paintings**: Contains details about various paintings, including their titles, artists, and pricing.
2. **Museums**: Includes information about different museums and their locations.
3. **Artists**: Provides details about the artists who created the paintings.
4. **Canvas Sizes**: Lists the different canvas sizes available.
5. **Museum Hours**: Contains the operating hours for each museum.

## SQL Problems Solved
### 1. Fetch all the paintings which are not displayed on any museums?
```sql
select name as paintings from work where museum_id is null;
```
### 2. Are there museums without any paintings?
```sql
select * from museum m
where not exists (select 1 from work w
where w.museum_id=m.museum_id);
``
### 3. How many paintings have an asking price of more than their regular price?
```sql
select * from product_size where sale_price > regular_price;
```

### 4. Identify the paintings whose asking price is less than 50% of its regular price
```sql
select * from product_size where sale_price < (regular_price * 0.5);
```
### 5. Which canva size costs the most?
```sql
select cs.label as canva, ps.sale_price
	from (select *
		  , rank() over(order by sale_price desc) as rnk 
		  from product_size) ps
	join canvas_size cs on cs.size_id::text=ps.size_id
	where ps.rnk=1;	
```
### 6. Delete duplicate records from work table
```sql
select work_id ,count(work_id) from work group by work_id; -- NO DUPLICATE

delete from work where work_id not in (select min(work_id) from work group by work_id); --IF ANY DUPLICATES
```

### 7. Identify the museums with invalid city information in the given dataset
```sql
select * from museum where city ~ '[0-9]';
```
### 8. Museum_Hours table has 1 invalid entry. Identify it and remove it.
```sql
delete from museum_hours 
	where ctid not in (select min(ctid)
 	from museum_hours
	group by museum_id, day );
```
### 9. Fetch the top 10 most famous painting subject
```sql
select * 
	from (	select s.subject,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as ranking
		from work w
		join subject s on s.work_id=w.work_id
		group by s.subject ) x
	where ranking <= 10;
```
### 10. Identify the museums which are open on both Sunday and Monday. Display
museum name, city.
```sql
select distinct m.name as museum_name, m.city, m.state,m.country
	from museum_hours mh 
	join museum m on m.museum_id=mh.museum_id
	where day='Sunday'
	and exists (select 1 from museum_hours mh2 
				where mh2.museum_id=mh.museum_id 
			    and mh2.day='Monday');
```
### 11. How many museums are open every single day?
```sql
select count(1)
	from (select museum_id, count(1)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;
```
### 12. Which are the top 5 most popular museum? (Popularity is defined based on most
no of paintings in a museum)
```sql
select m.name as museum, m.city,m.country,x.no_of_painintgs
	from (	select m.museum_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			group by m.museum_id) x
	join museum m on m.museum_id=x.museum_id
	where x.rnk<=5;
```

### 13. Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
```sql
select a.full_name as artist, a.nationality,x.no_of_painintgs
	from (	select a.artist_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
			group by a.artist_id) x
	join artist a on a.artist_id=x.artist_id
	where x.rnk<=5;
```
### 14. Display the 3 least popular canva sizes
```sql
select label,ranking,no_of_paintings
	from (
		select cs.size_id,cs.label,count(1) as no_of_paintings
		, dense_rank() over(order by count(1) ) as ranking
		from work w
		join product_size ps on ps.work_id=w.work_id
		join canvas_size cs on cs.size_id::text = ps.size_id
		group by cs.size_id,cs.label) x
	where x.ranking<=3;
```
### 15. Which country has the 5th highest no of paintings?
```sql
with cte as 
		(select m.country, count(1) as no_of_Paintings
		, rank() over(order by count(1) desc) as rnk
		from work w
		join museum m on m.museum_id=w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;
```
## Conclusion

In this project, I successfully explored and analyzed the **Famous Paintings & Museum dataset** to address various SQL problems. Through a series of queries, I uncovered valuable insights into the relationships between paintings and museums, pricing discrepancies, and the popularity of different artists and canvases.

### Key Findings

- I identified paintings that are not displayed in any museums, as well as museums that lack any paintings.
- Analysis of pricing revealed numerous instances where the asking price exceeded the regular price, highlighting potential pricing strategies.
- I discovered the most expensive canvas sizes and the least popular ones, which could inform future inventory decisions for artists and galleries.
- The project also involved cleaning the dataset by removing duplicates and identifying invalid entries, ensuring the integrity of the data for further analysis.

Overall, this project provided an opportunity to enhance my SQL skills while gaining practical experience in data analysis and database management. The findings could be beneficial for museum curators, art collectors, and analysts in the art industry, aiding in decision-making and strategic planning.

