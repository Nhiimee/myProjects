select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- KPIs
-- 1) Total Revenue (How much money did we make this year?)
select sum(quantity * price) as avg_order_price
from order_details as ord
join pizzas as piz
	on ord.pizza_id = piz.pizza_id;


-- 2) Average Order Value
select sum(quantity * price) / count(DISTINCT order_id) average_per_order
from order_details as ord
join pizzas as piz
	on ord.pizza_id = piz.pizza_id;

-- 3) Total Pizzas Sold
select sum(quantity) as total_pizzas_sold
from order_details;


-- 4) Total Orders
select count(order_id) as total_orders 
from orders;

-- 5) Average Pizzas per Order
select sum(quantity) / count(DISTINCT orders.order_id) average_per_order
from order_details
join orders
	on order_details.order_id = orders.order_id;
    

-- QUESTIONS TO ANSWER 

-- 1) Daily Trends for Total Orders
-- change the data type of the date column first
alter table orders
MODIFY column `date` date; 

select dayname(`date`) as weekday, count(distinct order_id) as total_orders 
from orders
GROUP BY weekday
ORDER BY total_orders desc;
-- 2) Hourly Trend for Total Orders
-- change the data type of the date column first
alter table orders
modify column `time` time;


select hour(time) as hour_of_day, count(distinct order_id) as total_orders 
from orders
GROUP BY hour_of_day
ORDER BY total_orders desc;

-- 3) Percentage of Sales by Pizza Category
SELECT 
    category,ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100.0 /
    (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    category;


-- 4) Percentage of Sales by Pizza Size
SELECT 
    size,
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    size;

-- 5) Total Pizzas Sold by Pizza Category
select category, sum(quantity) as total_pizzas_sold
from order_details as ord
join pizzas as piz
	on ord.pizza_id = piz.pizza_id
join pizza_types as pity
	on piz.pizza_type_id = pity.pizza_type_id
GROUP BY category; 


-- 6) Top 5 Best Sellers by Total Pizzas Sold
select name, sum(quantity) as total_pizzas_sold
from order_details as ord
join pizzas as piz
	on ord.pizza_id = piz.pizza_id
join pizza_types as pity
	on piz.pizza_type_id = pity.pizza_type_id
GROUP BY name
ORDER BY total_pizzas_sold desc
limit 5;


-- 7) Bottom 5 Worst Sellers by Total Pizzas Sold
select name, sum(quantity) as total_pizzas_sold
from order_details as ord
join pizzas as piz
	on ord.pizza_id = piz.pizza_id
join pizza_types as pity
	on piz.pizza_type_id = pity.pizza_type_id
GROUP BY name
ORDER BY total_pizzas_sold
limit 5;
