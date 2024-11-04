Pizza Sales Portfolio Project – SQL

Project Overview
In this project, I utilized SQL and Power BI to analyze a year’s worth of sales data from a pizza outlet. The objective was to uncover valuable insights to help the outlet make informed decisions to increase sales. The data is sourced from four CSV files and is analyzed using MySQL.

Data Source
 [Pizza Place Sales Dataset](https://www.kaggle.com/datasets/mysarahmadbhat/pizzaplacesales)

Step 1: Data Preview
The raw data consists of four tables:
 `order_details`
 `orders`
 `pizza_types`
 `pizzas`

```sql
SELECT  FROM order_details;
SELECT  FROM orders;
SELECT  FROM pizza_types;
SELECT  FROM pizzas;
```

 Step 2: SQL Queries
 Key Performance Indicators (KPIs)
1. Total Revenue
   ```sql
   SELECT SUM(quantity  price) AS total_revenue
   FROM order_details AS ord
   JOIN pizzas AS piz ON ord.pizza_id = piz.pizza_id;
   ```

2. Average Order Value
   ```sql
   SELECT SUM(quantity  price) / COUNT(DISTINCT order_id) AS average_order_value
   FROM order_details AS ord
   JOIN pizzas AS piz ON ord.pizza_id = piz.pizza_id;
   ```

3. Total Pizzas Sold
   ```sql
   SELECT SUM(quantity) AS total_pizzas_sold
   FROM order_details;
   ```

4. Total Orders
   ```sql
   SELECT COUNT(order_id) AS total_orders 
   FROM orders;
   ```

5. Average Pizzas per Order
   ```sql
   SELECT SUM(quantity) / COUNT(DISTINCT orders.order_id) AS average_pizzas_per_order
   FROM order_details
   JOIN orders ON order_details.order_id = orders.order_id;
   ```

 Questions to Answer
1. Daily Trends for Total Orders
   ```sql
   ALTER TABLE orders MODIFY COLUMN `date` DATE; 
   
   SELECT DAYNAME(`date`) AS weekday, COUNT(DISTINCT order_id) AS total_orders 
   FROM orders
   GROUP BY weekday
   ORDER BY total_orders DESC;
   ```

2. Hourly Trend for Total Orders
   ```sql
   ALTER TABLE orders MODIFY COLUMN `time` TIME;

   SELECT HOUR(time) AS hour_of_day, COUNT(DISTINCT order_id) AS total_orders 
   FROM orders
   GROUP BY hour_of_day
   ORDER BY total_orders DESC;
   ```

3. Percentage of Sales by Pizza Category
   ```sql
   SELECT 
       category,
       ROUND(SUM(quantity  price), 2) AS revenue,
       ROUND(SUM(quantity  price)  100.0 / (SELECT SUM(quantity  price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
   FROM 
       pizzas AS p
   JOIN 
       pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
   JOIN 
       order_details AS od ON od.pizza_id = p.pizza_id
   GROUP BY 
       category;
   ```

4. Percentage of Sales by Pizza Size
   ```sql
   SELECT 
       size,
       ROUND(SUM(quantity  price), 2) AS revenue,
       ROUND(SUM(quantity  price)  100.0 / (SELECT SUM(quantity  price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
   FROM 
       pizzas AS p
   JOIN 
       pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
   JOIN 
       order_details AS od ON od.pizza_id = p.pizza_id
   GROUP BY 
       size;
   ```

5. Total Pizzas Sold by Pizza Category
   ```sql
   SELECT category, SUM(quantity) AS total_pizzas_sold
   FROM order_details AS ord
   JOIN pizzas AS piz ON ord.pizza_id = piz.pizza_id
   JOIN pizza_types AS pity ON piz.pizza_type_id = pity.pizza_type_id
   GROUP BY category; 
   ```

6. Top 5 Best Sellers by Total Pizzas Sold
   ```sql
   SELECT name, SUM(quantity) AS total_pizzas_sold
   FROM order_details AS ord
   JOIN pizzas AS piz ON ord.pizza_id = piz.pizza_id
   JOIN pizza_types AS pity ON piz.pizza_type_id = pity.pizza_type_id
   GROUP BY name
   ORDER BY total_pizzas_sold DESC
   LIMIT 5;
   ```

7. Bottom 5 Worst Sellers by Total Pizzas Sold
   ```sql
   SELECT name, SUM(quantity) AS total_pizzas_sold
   FROM order_details AS ord
   JOIN pizzas AS piz ON ord.pizza_id = piz.pizza_id
   JOIN pizza_types AS pity ON piz.pizza_type_id = pity.pizza_type_id
   GROUP BY name
   ORDER BY total_pizzas_sold
   LIMIT 5;
   ```

 Step 3: Findings
 KPIs
1. Total Revenue for the Year: $817,860
2. Average Order Value: $38.31
3. Total Pizzas Sold: 50,000
4. Total Orders: 21,000
5. Average Pizzas per Order: 2

 Insights
1. Busiest Days: 
    Thursday (3,239 orders)
    Friday (3,538 orders)
    Saturday (3,158 orders)
    Most sales recorded on Fridays.

2. Order Timing: 
    Peak orders between 12 PM to 1 PM and 5 PM to 7 PM.

3. Sales by Pizza Category: 
    Classic pizza leads sales at 26.91%, followed by Supreme (25.46%), Chicken (23.96%), and Veggie (23.68%).

4. Sales by Pizza Size: 
    Large pizzas account for 45.89% of sales, followed by medium (30.49%) and small (21.77%).

5. TopSelling Pizzas: 
    Classic Pizza: 14,888 pizzas
    Supreme: 11,987 pizzas
    Veggie: 11,649 pizzas
    Chicken: 11,050 pizzas.

6. Top 5 Best Sellers: 
    Classic Deluxe (2,453 pizzas)
    Barbecue Chicken (2,432 pizzas)
    Hawaiian (2,422 pizzas)
    Pepperoni (2,418 pizzas)
    Thai Chicken (2,371 pizzas).

7. Bottom 5 Worst Sellers: 
    Brie Carre (490 pizzas)
    Mediterranean (934 pizzas)
    Calabrese (937 pizzas)
    Spinach Supreme (950 pizzas)
    Soppressata (961 pizzas).

Step 4: Conclusion and Recommendations
Conclusion
The analysis has provided actionable insights into sales trends, customer preferences, and overall business performance.

Recommendations
1. Promotional Strategies: Focus on Fridays for special promotions.
2. Inventory Management: Adjust inventory for large pizzas and consider menu changes for underperformers.
3. Operational Adjustments: Increase staffing during peak order times.
4. Continued Monitoring: Regularly update data and track the impact of changes.
