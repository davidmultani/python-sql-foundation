use classicmodels;
# 1. 1) List all customers (first 10)
select * from customers limit 10;

# 2. Products cheaper than $50
select * from products where buyPrice<50 order by buyPrice;

# 3. List all distinct customer countries.
select distinct country from customers order by country;

# 4. Show all orders placed in the year 2004.
select * from orders where year(orderDate) = 2004 order by orderNumber;

#5. show payments above $5000
select * from payments where amount > 5000 order by amount;

#6. Display employees sorted by job title
select * from employees order by jobTitle;

#7. Show products with quantity in stock less than 100
select * from products where quantityInStock <100;

#8. List all offices located in USA
select * from offices where country = 'USA';

#9. Show orderNumber, orderDate, and status for all orders.
select orderNumber, orderDate, status from orders;

#10. Display product names and msrp values sorted highest to lowest
select productName, msrp from products order by msrp desc;

#11. List customers along with the names of their sales representatives.
select customerName, concat(firstName,' ',lastName) as RepresentativeName from customers c inner join employees e on c.salesRepEmployeeNumber=e.employeeNumber;

#12. Show orders along with the customer name who placed them.
select orderNumber,customerName from orders inner join customers using (customerNumber);

#13. Show product line details along with product names.
select productName, productLine from products inner join productlines using (productLine);

#14. Calculate total amount for each order (quantity * price)
select orderNumber, quantityOrdered*buyPrice as totalOrderAmount from orderdetails inner join products using (productCode);

#15. List customers with more than 3 orders.
select customerName 
from customers 
where customerNumber IN (select distinct customerNumber from orders group by customerNumber having count(*) > 3);

#16. Count how many products belong to each product line.
select count(*), productLine 
from products 
group by productLine;

#17. Show the top 10 customers by total payments.
select customerName, sum(amount) as total
from customers inner join payments using (customerNumber)
group by customerName
order by total desc;

#18. List orders that have not yet been shipped.
select * 
from orders
where status = 'In Process';

#19. Find all products that have never been ordered.
select * from products where productCode not in (select productCode from orderdetails);

#20. Find the inventory value (quantityInStock × buyPrice) per product line.
select productLine , sum(quantityInStock * buyPrice) as InventoryValue 
from products 
group by productLine
order by InventoryValue desc;

#21. List all orders that were shipped late (shippedDate > requiredDate).
select * 
from orders
where shippedDate > requiredDate;

#22. Show total revenue generated per customer.
select customerNumber, sum(quantityOrdered * priceEach) as RevenueGenerated
from orders inner join orderdetails
using (orderNumber)
group by customerNumber
order by RevenueGenerated desc;

#23. Find employees along with the number of customers they manage.
select e.employeeNumber, concat(e.firstName, ' ',e.lastName) as EmployeeName, count(*)
from employees e inner join customers c
on e.employeeNumber = c.salesRepEmployeeNumber
group by e.employeeNumber
order by count(*) desc;

#24. List customers who have made no payments.
select * 
from customers 
left join payments 
using (customerNumber)
where amount is null;

#25. Show the number of orders placed per year.
select year(orderDate), count(orderNumber) as NoOfOrders
from orders
group by year(orderDate)
order by year(orderDate);

#26. Find the top 3 revenue-generating products within each product line.
with revenue as (
select productLine, productCode, productName, sum(priceEach*QuantityOrdered) as total
from productlines 
inner join products using (productLine)
inner join orderdetails using (productCode)
group by productLine,productCode,productName
order by productLine,total desc
)
select productLine,productCode,productName,total
from ( select r.*, dense_rank() over (partition by productLine order by total desc) as rnk
	   from revenue r
) x
where rnk <=3;

#27. Show monthly revenue for all orders (YYYY-MM)
select year(o.orderDate) as yr, month(o.orderDate) as mth, sum(quantityOrdered*priceEach) as revenue
from orderdetails od inner join orders o using(orderNumber)
group by year(o.orderDate), month(o.orderDate);

#28. Compute a 3-month rolling revenue trend.
with rev as (select DATE_FORMAT(o.orderDate,'%Y-%m-01') as monthStart, sum(od.quantityOrdered*od.priceEach) as revenue
from orderdetails od inner join orders o using(orderNumber)
group by monthStart
)
select rev.*,sum(revenue) over (order by monthStart rows between 2 preceding and current row) as rolling3MonthsRevenue
from rev
order by monthStart;

#29. Calculate customer lifetime value (total orders − total payments).
with order_total as (
select o.customerNumber,sum(od.quantityOrdered * od.priceEach) as orderValue
from orders o inner join orderdetails od using (orderNumber) 
group by o.customerNumber
),
payment_total as (
select customerNumber, sum(amount) as paid
from payments
group by customerNumber
)
select c.customerNumber,c.customerName,ot.orderValue as totalOrdered ,pt.paid as totalPaid,
ROUND(ot.orderValue - COALESCE(pt.paid,0),2) as balance
from customers c left join order_total ot using(customerNumber)
left join payment_total pt using (customerNumber)
order by balance desc;

#30. Identify the best sales representative based on total customer payments.
with info as (
select employeeNumber,customerNumber, sum(od.quantityOrdered * od.priceEach) as customerTotalOrderAmount
from employees e inner join customers c on e.employeeNumber = c.salesRepEmployeeNumber
inner join orders o using (customerNumber) 
inner join orderdetails od using (orderNumber)
group by employeeNumber,customerNumber
order by employeeNumber,customerNumber
)
select employeeNumber,sum(customerTotalOrderAmount) as total
from info
group by employeeNumber
order by total desc limit 5;

#31. Compute total revenue generated per office.
with info as (
select ofs.officeCode, ofs.city, ofs.country, e.employeeNumber, c.customerNumber, sum(od.quantityOrdered * od.priceEach) as totalCustomerAmount
from offices ofs inner join employees e using (officeCode)
inner join customers c on e.employeeNumber = c.salesRepEmployeeNumber 
inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by ofs.officeCode, e.employeeNumber, c.customerNumber, ofs.city, ofs.country
order by 1,2,3
)
select officeCode, city, country, sum(totalCustomerAmount) as officeTotalRevenue
from info
group by officeCode
order by officeTotalRevenue desc;

#32. Find products with high sales volume but low stock (reorder candidates)
with info as(
select od.productCode, sum(quantityOrdered) as totalQuantityOrdered
from orderdetails od inner join products p
using (productCode)
group by od.productCode
)
select info.productCode, totalQuantityOrdered, quantityInStock
from info inner join products using (productCode)
where quantityInStock <=100
order by totalQuantityOrdered desc;

#33. Rank customers by revenue within each country.
with info as(
select c.customerNumber, c.country,sum(amount) as revenue
from customers c inner join payments p
using (customerNumber)
group by c.customerNumber,c.country)
select info.*,dense_rank() over (partition by country order by revenue desc)
from info;

#34. Compute average lead time (shippedDate − orderDate) per year.
with info as(
select year(orderDate) as yr, orderNumber, datediff(shippedDate,orderDate) as pr_lead
from orders
)
select yr,avg(pr_lead) as avgLeadTime
from info
group by yr;

#35. For each customer, show their first and most recent order date.
select distinct c.customerNumber, c.customerName,
       MIN(orderDate) over (partition by customerNumber) as firstOrder,
       MAX(orderDate) over (partition by customerNumber) as latestOrder
from customers c
inner join orders o on c.customerNumber = o.customerNumber
order by customerNumber;

#36. customers who placed 2 or more orders.
select c.customerNumber, c.customerName,count(o.orderNumber) as NoOfOrders
from customers c inner join orders o using (customerNumber)
group by 1,2
having NoOfOrders >=2
order by 1;

#37.Find the customer who generated the highest revenue in each country.
with info as(
select c.customerNumber,c.customerName, c.country,sum(od.quantityOrdered*od.priceEach) as totalRevenue,
dense_rank() over (partition by c.country order by sum(od.quantityOrdered*od.priceEach) desc) as rnk
from customers c inner join orders o using (customerNumber)
inner join orderdetails od using (orderNumber)
group by 1,2,3
order by c.country,totalRevenue desc)
select customerNumber,customerName, country, totalRevenue 
from info 
where rnk=1
order by country, totalRevenue desc;

#38. Find which product line contributes the most to total revenue.
select p.productLine, sum(od.quantityOrdered*od.priceEach) as totalRevenue
from products p inner join orderdetails od 
group by 1
order by totalRevenue desc
limit 1;

#39. Identify the employee who supports the most high-value customers (>50k payments).
select concat(e.firstName,' ',e.lastName) as employeeName, 
c.customerName, sum(p.amount) as payment 
from employees e inner join customers c on e.employeeNumber = c.salesRepEmployeeNumber
inner join payments p using (customerNumber)
group by 1,2
having payment > 50000
order by payment desc limit 1;

#40.Determine sales reps whose customers have not placed any orders.
select concat(e.firstName,' ',e.lastName) as employee_Name, c.customerName,o.orderNumber
from employees e inner join customers c on e.employeeNumber = c.salesRepEmployeeNumber
left join orders o using (customerNumber)
where o.orderNumber is null
order by 1,2;








 
