# Data-Engineering-SQL-
Mastering CTEs.
Mastering CTEs, Window Functions, and Indexes in SQL
________________________________________
Objective
•	Write clean, modular SQL queries using Common Table Expressions (CTEs)
•	Perform analytical tasks using SQL Window Functions
•	Improve query performance through Indexing
________________________________________
Dataset: sales_data
Create the following table in your SQL environment (e.g., PostgreSQL, MySQL 8+, SQL Server):
CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT,
    region TEXT,
    sale_amount DECIMAL(10,2),
    sale_date DATE
);
Insert at least 20 sample rows to simulate real-world data.
________________________________________
Tasks
Part A: Common Table Expressions (CTEs)
1.	Write a CTE to calculate total sales per employee. Display only employees whose total sales exceed $10,000.
2.	Write a recursive CTE to generate a sequence of numbers from 1 to 10.
3.	Use a CTE to find the monthly average sales across all regions. Return the results with month and year.
________________________________________



Part B: Window Functions
4.	Use ROW_NUMBER() to assign a unique rank to each sale per employee, ordered by sale_amount descending.
5.	Use RANK() to find the top 3 sales per region.
6.	Use SUM() as a window function to calculate the running total of sales per employee, ordered by sale_date.
7.	Calculate the average sale per region using AVG() over a partitioned window. List each sale along with its regional average.
________________________________________
Part C: Indexes
8.	Choose a query from above that would be slow on a large dataset. Explain why it could be inefficient.
9.	Propose and create an index to optimize the performance of that query. Justify your choice of column(s).
10.	Compare the performance before and after creating the index:
o	Run EXPLAIN or the equivalent to capture execution plans
o	Briefly explain the improvement
________________________________________
