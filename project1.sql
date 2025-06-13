-- MEMBUAT TABEL
create table retail_sales 
(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age	int,
	category varchar(15),	
	quantiy int,
	price_per_unit float,
	cogsf float,
	total_sale float
);

-- DATA CLEANING
-- mengecek jumlah data yang telah termuat
select 
	count(*)
from retail_sales

-- menghapus baris yang mempunyai null value
delete from retail_sales
where 
transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogsf is null
	or
	total_sale is null

-- mengubah nama kolom yang salah
alter table retail_sales
rename column quantiy to quantity

alter table retail_sales
rename column cogsf to cogs

alter table retail_sales
rename column total_sale to total_sales

select *
from retail_sales
limit 5

-- DATA EXPLORATION
-- data analys and business key problem & answer

-- P1. menampilkan semua kolom sales dari tanggal '2022-11-05'
select 
	*
from retail_sales 
where sale_date = '2022-11-05'

-- P2. menampilkan semua transaksi dengan category clothing dan quantity yang terjual lebih dari 10 di november 2022
select 
*
from retail_sales
where 
	category = 'Clothing'
	and 
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and
	quantity >= 4

-- P3. menghitung total sales per masing-masing kategori
select 
	category,
	sum(total_sales) as total_sales
from retail_sales
group by 1

--P4. menemukan rata-rata usia customer yang membeli item beauty
select 
	round(avg(age), 2)
from retail_sales
where category = 'Beauty'

-- P5. menampilkan semua transaksi yang memiliki total_sales lebih dari 1000
select 
	*
from retail_sales
where total_sales >= 1000

-- P6. total jumlah transaksi tiap gender per kategori
select 
	category,
	gender,
	count(transactions_id)
from retail_sales
group by 1, 2
order by 2

--P7. menampilkan rata-rata sale tiap bulannya dan menemukan best selling month in year
select 
	extract(year from sale_date) as tahun,
	extract(month from sale_date) as bulan,
	avg(total_sales) avg sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sales) desc)
from retail_sales
group by 1, 2

-- dengan memakai cte bisa seperti ini 
select
	tahun, 
	bulan,
	avg_sale
from 
(
	select 
	extract(year from sale_date) as tahun,
	extract(month from sale_date) as bulan,
	avg(total_sales) avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sales) desc) as rank
from retail_sales
group by 1, 2
)
where rank = 1
	
-- P8. mencari top 5 customer berdasarkan total_sales tertinggi
select 
	customer_id,
	sum(total_sales) as tot_sale
from retail_sales
group by 1 
order by 2 desc
limit 5

--P9. menemukan jml customer_id berdasarkan masing-masing kategori
select 
	category,
	count(distinct customer_id) as jml_customer
from retail_sales
group by 1 

-- P10. menemukan shift pada pembelian dan jml ordernya ( morning <= 12, afternoon between 12 & 17, evening >17)
with hourly as
(
select 
	*,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as tot_order
from hourly
group by 1
	