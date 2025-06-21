--Creating a schma
create schema minutemall;
--Insert table
CREATE TABLE minutemall.sales_data ( 
    sale_id SERIAL PRIMARY KEY, 
    employee_id INT, 
    region TEXT, 
    sale_amount DECIMAL(10,2), 
    sale_date DATE 
); 

---insert data
insert into minutemall.sales_data(employee_id,region, sale_amount,sale_date)
values
(001,'Garisa', 20000,'12/04/2025'),
(101,'Kakamega',1540.75,'2025-05-01'),
(102,'Kuresoi',980.00,'2025-07-01'),
(103,'Meru',11750.25,'2025-05-02'),
(104,'Nakuru',13400.90,'2025-10-02'),
(105,'Mombasa',1650.00,'2025-08-03'),
(106,'Kitale',850.50,'2025-05-03'),
(107,'Kilifi',1230.40,'2025-05-04'),
(108,'Nakuru',11000.00,'2025-07-04'),
(109,'Kitale',1745.90,'2025-05-05'),
(110,'Meru',920.00,'2025-05-05'),
(101,'Kuresoi',1380.00,'2025-04-06'),
(102,'Kakamega',11250.25,'2025-05-06'),
(103,'Kilifi',15900.00,'2025-04-07'),
(104,'Meru',800.00,'2025-05-07'),
(105,'Embu',14250.30,'2025-05-08'),
(106,'Meru',1090.60,'2025-03-08'),
(107,'Nakuru',17750.00,'2025-07-09'),
(108,'Mombasa',950.00,'2025-11-09'),
(109,'Kilifi',12100.75,'2025-05-10'),
(110,'Nakuru',1300.00,'2025-05-10');

--view the generated data
select *from minutemall.sales_data s

--Begining of the Task
select *
from minutemall.sales_data s

with Totalsales as (
select employee_id, sum(sale_amount) as receivables
from minutemall.sales_data s
group by employee_id
)
select * from Totalsales
where  receivables >= 10000
order by employee_id asc ;

-- recursive CTE to generate a sequence of numbers from 1 to 10
with recursive sequence_of_numbers(y) as (
select 1 -- Anchor member
union all
select y+1
from sequence_of_numbers
where y< 10
)
select y
from sequence_of_numbers;

--alternatively
select sale_id from minutemall.sales_data;
---running
with recursive u as (
    select  sale_id--- Anchor member
    from minutemall.sales_data
    union all
    select sale_id + 1
    from u
    where sale_id < 10
)
select sale_id
from u;
---No Idea of its use
option(maxrecursion 0);

---Monthly average

--alternative 1

with monthly_sales as (
 SELECT TO_CHAR(sale_date, 'YYYY-MM') AS year_month,AVG(sale_amount) AS avg_sales
    from minutemall.sales_data
    GROUP BY
        TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    year_month,
    avg_sales
FROM 
    monthly_sales
ORDER BY
    year_month;

---adding the region
with monthly_sales as (
 SELECT 
 region,
 TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
 round(AVG(sale_amount),2) AS avg_sales
    from minutemall.sales_data
    GROUP BY
        region,year_month
)
SELECT 
    region,
    year_month,
    avg_sales
FROM 
    monthly_sales
ORDER BY
    region;

--Window Functions
--Did not run
select *
from minutemall.sales_data s

SELECT 
    employee_id,
    department,
    sale_amount,
    RANK() OVER (
        PARTITION BY department
        ORDER BY sale_amount DESC
    ) AS rank_in_department
FROM 
    sales;

--Alternatively
SELECT 
    employee_id,
    region,
    sale_amount,
    sale_date,
    ROW_NUMBER() OVER (
        PARTITION BY employee_id 
        ORDER BY sale_amount DESC
    ) AS sale_rank
FROM 
    minutemall.sales_data s;

--Use RANK() to find the top 3 sales per region.

with topsalePerRegion as (
select
     region,
     sale_date,
     sale_amount,
     rank() over(partition by region
     order by sale_amount desc) as sales_rank
 from minutemall.sales_data 
)  
select * from topsalePerRegion
where sales_rank <= 3;
     

--Alternive 1 to rank
SELECT 
    employee_id,
    region,
    sale_amount,
    sale_date,
    RANK() OVER (
        PARTITION BY region 
        ORDER BY sale_amount DESC
    ) AS sale_rank
FROM 
    minutemall.sales_data s
WHERE 
    region IS NOT NULL;
--Alternive 2 to rank
SELECT *
FROM (
    SELECT 
        employee_id,
        region,
        sale_amount,
        sale_date,
        RANK() OVER (
            PARTITION BY region 
            ORDER BY sale_amount DESC
        ) AS sale_rank
    FROM 
        minutemall.sales_data s
) AS ranked_sales
WHERE sale_rank <= 3;

--SUM() as a window function to calculate the running total of sales per employee, 
--ordered by sale_date.
--altrnative 1:doesn't implement
SELECT
    employee_id,
    sale_date,
    sale_amount,
    SUM(sale_amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS running_total
FROM
    minutemall.sales_data s;

--alternative 2
SELECT 
    employee_id,
    region,
    sale_amount,
    sale_date,
    SUM(sale_amount) OVER (
        PARTITION BY employee_id
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM 
    minutemall.sales_data s;
--Alternative 3
select 
	employee_id,
	sale_date,
	sale_amount,
	sum(sale_amount) over(partition by employee_id order by sale_date asc
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as running_total
from minutemall.sales_data s;
--Alternative 4 --no cummulative effect
select 
    employee_id,
    sale_date,
    sale_amount,
  SUM(sale_amount) OVER(PARTITION BY employee_id order by sale_date) as Runningtotal
  from  minutemall.sales_data s;

---Calculate the average sale per region using AVG()
--Alternative 1
select *, avg(sales) over 
  (PARTITION BY item ORDER BY week_num DESC ROWS BETWEEN current row 
  and 3 following ) as Avg_sales_4_weeks

--Alternative 2
  select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--alternative 3
SELECT 
       employee_id, sale_date,region, sale_amount,
       AVG(sale_amount) OVER (PARTITION BY region ORDER BY region) AS avg_sales
FROM minutemall.sales_data s;

--INDEXING 
--Choose a query from above that would be slow on a large dataset. Explain why it could 
--be inefficient. 
--Begining of the Task
select *
from minutemall.sales_data s
--We will optimise th following querry

 select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;

--RUNNING THE SELECT* TAKES Time, so we use indexing to optimise the querry.

--We first explore how the query was ran
explain select *
from minutemall.sales_data s
--add analyze(tells us how long it took to run the query)
explain analyze select *
from minutemall.sales_data s
--It is a clustered index
 explain select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
---The above query is slow to execute as the database is large and the querry has to check all average
-- sales across in the regional column and the sales amount column.
explain analyze select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
-- Propose and create an index to optimize the performance of that query. Justify your 
--choice of column(s). 
--since the qurry involves 2 columns, we ar going to create an index for
--Index scan
--create idx_department on queries.park(department)

explain analyze select * from queries.park p where department ='HR';

create index idx_net_proceeds on minutemall.sales_data(sale_amount)
explain analyze  create index idx_net_proceeds on minutemall.sales_data(sale_amount)
--Testing 
select *
employee_id, sale_date,region, sale_amount,
from minutemall.sales_data;


--Alternatively
--since the qurry involves 2 columns, we ar going to create an index for
--Index scan
--column of focus; region
create index idx_local_region on minutemall.sales_data(region)
--Checking the data
select * from minutemall.sales_data s where region ='location';
---Add explain
explain select * from minutemall.sales_data s where region ='location';
---add analyze
explain analyze select * from minutemall.sales_data s where region ='location';
--Planning Time 0.081ms
--Execution Time 0.050ms
--10. Testing before and after indexing
select *
from minutemall.sales_data s;

select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--Adding explain
explain select *
from minutemall.sales_data s
--the querry
 explain select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--Adding explain
explain analyze select *
from minutemall.sales_data s
--Planning tim 0.048ms
--Excution time 0.100ms
explain analyze select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
 --Planning time 0.067ms
--Execution Time 0.506ms
---The above query is slow to execute as the database is large and the querry has to check all average
--Testing the index
select *
from minutemall.sales_data s

select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--Adding explain
explain select *
from minutemall.sales_data s

explain select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--Adding explain analyze
explain analyze select *
from minutemall.sales_data s

explain analyze select
	employee_id, sale_date,region, sale_amount,
	AVG(sale_amount) OVER(partition by region) as regional_sale_avg
from minutemall.sales_data s;
--Planning Time 0.088ms
--Excution Time 0.359ms