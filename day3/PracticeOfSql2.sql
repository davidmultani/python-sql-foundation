use classicmodels;

#1. List customers with their sales rep names
select concat(e.firstName,' ',e.lastName) as employeeName, c.customerName 
from employees e inner join customers c 
on e.employeeNumber = c.salesRepEmployeeNumber;

#2. Top 5 customers by total order value
select c.customerNumber,c.customerName, sum(quantityOrdered*priceEach) as totalOrderValue
from customers c inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by c.customerNumber,c.customerName
order by totalOrderValue desc limit 5;

#3. Product line with most products
select productline, count(*) as NoOfProducts
from products p
group by productline
order by NoOfProducts desc
limit 3;

#4. Orders that contain more than 5 items
select *
from orderdetails od
where quantityOrdered > 5
order by quantityOrdered desc;

#5. Products with no orders
select p.productline,p.productName,p.productCode,od.orderNumber
from products p left join orderdetails od using (productCode)
where od.ordernumber is null;

#6. Total revenue per country
select c.country, sum(quantityOrdered*priceEach) as TotalRevenue
from customers c inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by c.country
order by TotalRevenue desc;

#7. Monthly order count (YYYY-MM)
select year(orderDate) as yr, month(orderDate) as Mth, count(orderNumber) as NoOfOrders
from orders 
group by 1,2
order by 1,2;

#8. Average processing time per order (shippedDate − orderDate)
select avg(datediff(shippedDate , orderDate)) as AverageProcessingTime
from orders;

#9. Top 5 products by revenue
select p.productCode,p.productName, sum(quantityOrdered*priceEach) as revenue 
from products p inner join orderdetails od using(productCode)
group by p.productCode,p.productName
order by revenue desc;

#10. Number of customers per sales rep
select e.employeeNumber,concat(e.firstName,' ',e.lastName) as employeeName, count(*) as NoOfCustomers
from employees e inner join customers c on e.employeeNumber = c.salesRepEmployeeNumber
group by 1,2
order by 1;

