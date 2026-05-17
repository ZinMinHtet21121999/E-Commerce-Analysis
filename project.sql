-- Checking the Dataset  --
SELECT * 
From clean_project;
-- Checking Row Count of the Dataset ----
SELECT count(*) 
From clean_project;
-- Total Revenue --
SELECT sum(quantity * unitprice) as revenue
From clean_project;

-- Revenue by Product --
-- Top 5 Products by Revenue using CTE method --

with product_revenue as (
SELECT productname,sum(quantity * unitprice) as revenue
From clean_project 
GROUP by productname
order by revenue desc),

rank_table as (
SELECT *,
		rank() over(order by revenue desc) as rank
From product_revenue) 

SELECT * 
From rank_table 
where rank < 6; 

-- Top 5 Products by Revenue using groupby and limit method --
SELECT productname,sum(quantity * unitprice) as revenue
From clean_project 
GROUP by productname
order by revenue desc
limit 5;

-- Revenue by Category --
select productcategory,sum(unitprice * quantity) as revenue 
from clean_project
group by productcategory
order by revenue DESC;

-- Monthly Revenue --- 
-- month split from orderdate using CTE ---
with monthly_revenue_table as (
SELECT strftime('%Y-%m',orderdate) as year_month,
		sum(unitprice * quantity) as revenue
From clean_project
group by year_month
order by revenue desc) 
SELECT *,
        rank() over(order by revenue desc) as rank
From monthly_revenue_table;

--- Average Order Value --- 
SELECT sum(unitprice * quantity) as revenue,
		count(*) as total_quantity,
        (sum(unitprice * quantity))/count(*) as avg_oreder_value
 From clean_project;

--- Customer Spending Category using CTE and Case When -- 
with customer_spent_table as (
SELECT customerid,
	sum(unitprice * quantity) as spent
From clean_project
GROUP by customerid)

SELECT * ,
		case 
        	WHEN spent > 4000 then 'High Value' 
            WHEN spent > 2000 then 'Medium Value'
            else 'Low Value'
        end as customer_segment
From customer_spent_table;
