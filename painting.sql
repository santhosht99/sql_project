select * from artist;
select * from canvas_size;
select * from image_link;
select * from museum_hours;
select * from museum;
select * from product_size;
select * from subject;
select * from work;

1. Fetch all the paintings which are not displayed on any museums?

select name as paintings from work where museum_id is null;


2. Are there museums without any paintings?

select * from museum m
where not exists (select 1 from work w
where w.museum_id=m.museum_id)



3. How many paintings have an asking price of more than their regular price?

select * from product_size where sale_price > regular_price;


4. Identify the paintings whose asking price is less than 50% of its regular price

select * from product_size where sale_price < (regular_price * 0.5);

5. Which canva size costs the most?

select cs.label as canva, ps.sale_price
	from (select *
		  , rank() over(order by sale_price desc) as rnk 
		  from product_size) ps
	join canvas_size cs on cs.size_id::text=ps.size_id
	where ps.rnk=1;	

6. Delete duplicate records from work table

select work_id ,count(work_id) from work group by work_id; -- NO DUPLICATE

delete from work where work_id not in (select min(work_id) from work group by work_id); --IF ANY DUPLICATES


7. Identify the museums with invalid city information in the given dataset

select * from museum where city ~ '[0-9]';

8. Museum_Hours table has 1 invalid entry. Identify it and remove it.

delete from museum_hours 
	where ctid not in (select min(ctid)
						from museum_hours
						group by museum_id, day );

9. Fetch the top 10 most famous painting subject

select * 
	from (
		select s.subject,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as ranking
		from work w
		join subject s on s.work_id=w.work_id
		group by s.subject ) x
	where ranking <= 10;

10. Identify the museums which are open on both Sunday and Monday. Display
museum name, city.

select distinct m.name as museum_name, m.city, m.state,m.country
	from museum_hours mh 
	join museum m on m.museum_id=mh.museum_id
	where day='Sunday'
	and exists (select 1 from museum_hours mh2 
				where mh2.museum_id=mh.museum_id 
			    and mh2.day='Monday');



11. How many museums are open every single day?

select count(1)
	from (select museum_id, count(1)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;



12. Which are the top 5 most popular museum? (Popularity is defined based on most
no of paintings in a museum)

select m.name as museum, m.city,m.country,x.no_of_painintgs
	from (	select m.museum_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			group by m.museum_id) x
	join museum m on m.museum_id=x.museum_id
	where x.rnk<=5;


13. Who are the top 5 most popular artist? (Popularity is defined based on most no of
paintings done by an artist)

select a.full_name as artist, a.nationality,x.no_of_painintgs
	from (	select a.artist_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
			group by a.artist_id) x
	join artist a on a.artist_id=x.artist_id
	where x.rnk<=5;


14. Display the 3 least popular canva sizes

select label,ranking,no_of_paintings
	from (
		select cs.size_id,cs.label,count(1) as no_of_paintings
		, dense_rank() over(order by count(1) ) as ranking
		from work w
		join product_size ps on ps.work_id=w.work_id
		join canvas_size cs on cs.size_id::text = ps.size_id
		group by cs.size_id,cs.label) x
	where x.ranking<=3;

15. Which country has the 5th highest no of paintings?

with cte as 
		(select m.country, count(1) as no_of_Paintings
		, rank() over(order by count(1) desc) as rnk
		from work w
		join museum m on m.museum_id=w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;
