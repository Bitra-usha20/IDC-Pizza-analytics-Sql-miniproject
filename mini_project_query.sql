use idc_pizza;
-- Phase 1: Foundation & Inspection
-- 1.List all unique pizza categories (DISTINCT).order_details
select distinct(category) from pizza_types;
-- 2.Display pizza_type_id, name, and ingredients, replacing NULL ingredients with "Missing Data". Show first 5 rows.
select pizza_type_id,name,coalesce(ingredients,'missing data') as ingredients from pizza_types
limit 5;
-- 3.Check for pizzas missing a price (IS NULL).
select * from pizzas where price is null;
-- **Phase 2: Filtering & Exploration**
-- 1. Orders placed on `'2015-01-01'` (`SELECT` + `WHERE`).
select * from orders where date='2015-01-01';
-- 2.List pizzas with price descending.
select pt.name,p.price from pizzas as p
inner join pizza_types as pt
on pt.pizza_type_id=p.pizza_type_id
order by p.price desc;
-- 3.Pizzas sold in sizes 'L' or 'XL'.
select pt.name,p.price,p.size from pizzas as p
inner join pizza_types as pt
on pt.pizza_type_id=p.pizza_type_id
where p.size='L' or p.size='XL';
-- 4.Pizzas priced between $15.00 and $17.00.
select pt.name,p.price from pizzas as p
inner join pizza_types as pt
on pt.pizza_type_id=p.pizza_type_id
where p.price between 15.00 and 17.00
order by p.price asc;
-- 5.Pizzas with "Chicken" in the name.
select name from  pizza_types
where  name like '%chicken%';
use idc_pizza;
-- 6.Orders on '2015-02-15' or placed after 8 PM.
select * from orders as o
inner join order_details as od
on od.order_id=o.order_id
where o.date ='2015-02-15' or  o.time>'20:00:00'
order by o.time asc;
-- **Phase 3: Sales Performance**
-- 1. Total quantity of pizzas sold (`SUM`).
select sum(quantity) as pizza_quantity from order_details;
-- 2.Average pizza price (AVG).
select round(avg(price),2)as average_price from pizzas;
-- 3.Total order value per order (JOIN, SUM, GROUP BY).
		select o.order_id,sum(p.price*od.quantity) as total_value
        from orders as o
         join order_details as od on o.order_id=od.order_id
        join pizzas as p on od.pizza_id=p.pizza_id
        group by o.order_id;
-- 4.Total quantity sold per pizza category (JOIN, GROUP BY).
select pt.category,sum(od.quantity) as total_quantity from pizza_types as pt
join pizzas as p on pt.pizza_type_id=p.pizza_type_id
join order_details as od on p.pizza_id=od.pizza_id
group by pt.category;
-- 5.categories with more than 5,000 pizzas sold(having)
 select pt.category,sum(od.quantity) as total_quantity from pizza_types as pt
 join pizzas as p on pt.pizza_type_id=p.pizza_type_id
 join order_details as od on p.pizza_id=od.pizza_id
 group by pt.category 
 having sum(od.quantity)>5000;
 -- 6.Pizzas never ordered (LEFT/RIGHT JOIN).
 SELECT * FROM pizzas AS p
LEFT JOIN pizza_types AS pt
ON p.pizza_type_id = pt.pizza_type_id
LEFT JOIN order_details AS od
ON p.pizza_id = od.pizza_id
WHERE od.order_id IS NULL;
 -- 7.Price differences between different sizes of the same pizza (SELF JOIN).
 SELECT pl.pizza_type_id, (MAX(p2.price) - MIN(pl.price)) AS price_difference
FROM pizzas AS pl
INNER JOIN pizzas AS p2 ON pl.pizza_type_id = p2.pizza_type_id
AND pl.size <> p2.size
GROUP BY pl.pizza_type_id;