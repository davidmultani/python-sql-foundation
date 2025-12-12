use classicmodels;
# 1. Total revenue per month (YYYY-MM)
select year(o.orderDate) as yr, month(o.orderDate) as mth, sum(quantityOrdered * priceEach) as revenue
from orders o inner join orderdetails using (orderNumber)
group by year(o.orderDate), month(o.orderDate)
order by yr,mth;

#2. Total revenue per year
select year(o.orderDate) as yr, sum(quantityOrdered * priceEach) as revenue
from orders o inner join orderdetails using (orderNumber)
group by year(o.orderDate)
order by yr;

#3. For each customer, show: total orders , total amount spent, average order value
select c.customerNumber,c.customerName,count(*) as NoOfOrders,
sum(p.amount) as TotalAmountSpent, avg(od.quantityOrdered * od.priceEach) as AverageOrderValue
from customers c inner join payments p using (customerNumber)
inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by c.customerNumber,c.customerName
order by 1,2;

#4. Top 10 products by revenue
select p.productCode,p.productName,sum(quantityOrdered * priceEach) as revenue
from products p inner join orderdetails od using (productCode)
group by productCode,productName
order by revenue desc;

#5. Top 5 countries by revenue
select c.country, sum(od.quantityOrdered * od.priceEach) as revenue
from customers c inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by c.country
order by revenue desc;

#6. Average shipping delay per product line
select p.productLine, avg(abs(datediff(orderDate,shippedDate))) as averageShippingDelay
from products p inner join orderdetails od using (productCode)
inner join orders o using (orderNumber)
group by p.productLine;

#7. Use ROW_NUMBER() to rank customers by revenue
with info as(
select c.customerNumber,c.customerName,
sum(od.quantityOrdered * od.priceEach) as revenue
from customers c inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by c.customerNumber,c.customerName)
select customerNumber, customerName, revenue,
row_number() over (order by revenue desc) as rankCustomer
from info;

#8. Use DENSE_RANK() to rank product lines by revenue
with info as(
select p.productCode, p.productName, sum(od.quantityOrdered * od.priceEach) as revenue
from products p inner join orderdetails od using (productCode)
group by p.productCode, p.productName)
select info.*,dense_rank() over (order by revenue desc) as DenseRank
from info;

#9. For each order: find highest-priced product
select od.orderNumber, p.productCode, p.productName, od.priceEach
from orderdetails od inner join products p using (productCode)
order by od.priceEach desc;

#10. Find the percentage of late shipments per month
select date_format(orderDate, '%Y-%m') as month, count(*) as total_orders,
sum(case when shippedDate > requiredDate then 1 else 0 end) as late_orders,
round(sum(case when shippedDate > requiredDate then 1 else 0 end)/count(*) * 100, 2) as late_percentage
from orders
where shippedDate is not null
group by date_format(orderDate, '%Y-%m')
order by month;		



