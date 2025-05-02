-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
copy books(book_id,title,author,genre,published_year,price,stock)
from 'C:/Users/akshat bhatnagar/Desktop/SQL'
csv header;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\Course Updates\30 Day Series\SQL\CSV\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\Course Updates\30 Day Series\SQL\CSV\Orders.csv' 
CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where genre='Fiction'; 

-- 2) Find books published after the year 1950:
select * from books
where published_year>1950;

-- 3) List all customers from the Canada:
select * from customers
where country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(stock) over(order by price asc) as running_total
from books;

--6) Find the details of the most expensive book:
select * from books
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1
select * from orders
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount>20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books
order by stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select 
	sum(total_amount) as running_total
from orders;

-- 1) Retrieve the total number of books sold for each genre:
select b.genre,sum(o.quantity) as running_total
from orders o
join
books b on o.book_id=b.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select * from books;
select * from orders;

select avg(price) as avg_price
from books
where genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
select * from orders;
select * from customers;

select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
join
customers c on o.customer_id=c.customer_id
group by o.customer_id,c.name
having count(order_id)>=2;

-- 4) Find the most frequently ordered book:
select * from orders;
select * from books;

select o.book_id, b.title, count(o.book_id) as total
from orders o
join 
books b on o.book_id=b.book_id
group by o.book_id,b.title
order by total desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books;
select * from orders;

select books.title,sum(books.price) as total_price from books
where genre='Fantasy'
group by books.title,books.price
order by total_price desc
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select * from books;
select * from orders;

select b.author,sum(o.quantity) over(partition by author) as total_books 
from books b
join orders o on b.book_id=o.book_id
group by b.author,o.quantity;

-- 7) List the cities where customers who spent over $30 are located:
select * from customers;
select * from orders;

select c.city
from customers c
join orders o on c.customer_id=o.customer_id
group by c.city,o.total_amount
having o.total_amount>30;

-- 8) Find the customer who spent the most on orders:
select * from customers;
select * from orders;

select c.name,sum(o.total_amount) over(partition by c.name) as total
from customers c
join orders o on c.customer_id=o.customer_id
group by c.name,o.total_amount
order by o.total_amount desc
limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
select * from orders;
select * from books;

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_stock
from orders o
left join books b on o.book_id=b.book_id
group by b.book_id
order by b.book_id;




