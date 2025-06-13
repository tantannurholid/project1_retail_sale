# Projek Retail Sales

## Gambaran Umum Projek

**Nama Projek**: Analisis Retail Sales   
**Level**: Pemula  
**Database**: `latihan_sql`

Projek ini dirancang untuk menunjukkan keterampilan dan teknik SQL yang umumnya digunakan oleh seorang Data Analyst dalam data cleaning, data exploration, dan analisa data retail sales. Projek ini melibatkan pembuatan basis data penjualan, melakukan analisis dan eksplorasi (Exploratory Data Analysis), dan menjawab pertanyaan bisnis melalui query SQL. Projek ini ideal untuk pemuladalam membangun dasar yang kuat dalam SQL. 

## Tujuan

1. **Menyiapkan Database Ritel Sales**: Membuat dan mengisi database Ritel Sales dengan data penjualan yang telah disiapkan.
2. **Data Cleaning**: Mengidentifikasi dan menghapus data yang kosong (Null Values)
3. **Exploratory Data Analysis (EDA)**: Melakukan eksplorasi data untuk memahami kumpulan data.
4. **Business Analysis**: Menggunakan SQL untuk menjawab pertanyaan bisnis dan mendapatkan wawasan dari data penjualan.

## Struktur Projek

### 1. Menyiapkan Database

- **Membuat Database**: Projek ini diawali dengan pembuatan database `latihan_sql`.
- **Membuat Tabel**: Dibuat tabel bernama `retail_sales` untuk menyimpan data penjualan. Struktur tabel mencakup kolom transactions_id,	sale_date,	sale_time,	customer_id, gender, age, category,	quantiy, price_per_unit,	cogs, dan total_sale.

```sql
CREATE DATABASE latihan;

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

```

### 2. Data Exploration & Data Cleaning

- **Record Count**: Mengetahui jumlah data yang terekam dalam dataset.
- **Customer Count**: Mengetahui berapa customer unik yang ada di dalam dataset.
- **Category Count**: MEngidentifikasi semua kategori produk di dalam dataset.
- **Null Value Check**: Mengecek semua null values yang ada di dalam dataset dan menhapus semua data yang tidak lengkap.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analisis

Query yang dibuat di bawah ini adalah untuk menjawab pertanyaan basic bisnis:

1. **P1. menampilkan semua kolom sales dari tanggal '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **P2. menampilkan semua transaksi dengan category clothing dan quantity yang terjual lebih dari 10 di november 2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **P3. menghitung total sales per masing-masing kategori**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **P4. menemukan rata-rata usia customer yang membeli item beauty**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **P5. menampilkan semua transaksi yang memiliki total_sales lebih dari 1000**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **P6. total jumlah transaksi tiap gender per kategori**:
```sql
select 
	category,
	gender,
	count(transactions_id)
from retail_sales
group by 1, 2
order by 2
```

7. **P7. menampilkan rata-rata sale tiap bulannya dan menemukan best selling month in year**:
```sql
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
```

8. **P8. mencari top 5 customer berdasarkan total_sales tertinggi**:
```sql
select 
	customer_id,
	sum(total_sales) as tot_sale
from retail_sales
group by 1 
order by 2 desc
limit 5
```

9. **P9. menemukan jml customer_id berdasarkan masing-masing kategori**:
```sql
select 
	category,
	count(distinct customer_id) as jml_customer
from retail_sales
group by 1 
```

10. **P10. menemukan shift pada pembelian dan jml ordernya ( morning <= 12, afternoon between 12 & 17, evening >17)**:
```sql
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
```

## Findings

- **Demografi Customer**: Dataset ini mencakup pelanggan dari berbagai kelompok usia, dengan penjualan yang didistribusikan di berbagai kategori seperti Pakaian dan Kecantikan.
- **Transaksi Nilai Tinggi**: Beberapa transaksi memiliki jumlah total penjualan lebih besar dari 1000, yang mengindikasikan pembelian premium.
- **Tren Penjualan**: Analisis bulanan menunjukkan variasi dalam penjualan, membantu mengidentifikasi musim puncak.
- **Insights Customer**: Analisis ini mengidentifikasi pelanggan dengan pembelanjaan tertinggi dan kategori produk terpopuler.

## Reports

- **Rangkuman Sales**:Laporan terperinci yang merangkum total penjualan, demografi pelanggan, dan kinerja kategori.
- **Analisis Tren**: Wawasan tentang tren penjualan di berbagai bulan dan shift.
- **Insights Customer**: Laporan tentang pelanggan teratas dan jumlah pelanggan unik per kategori.

## Kesimpulan

Proyek ini berfungsi sebagai pengenalan komprehensif terhadap SQL untuk analis data, yang mencakup penyiapan basis data, data cleaning, analisis data eksploratif, dan query SQL yang menjawab pertanyaan bisnis. Temuan dari proyek ini dapat membantu mendorong keputusan bisnis dengan memahami pola penjualan, perilaku pelanggan, dan kinerja produk.
