create database bookshop
CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    price DECIMAL(6,2),
    stock INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    book_id INT,
    customer_id INT,
    rating INT,
    comment TEXT,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO authors (author_id, name) VALUES
(1, 'George Orwell'),
(2, 'J.K. Rowling'),
(3, 'J.R.R. Tolkien'),
(4, 'Agatha Christie'),
(5, 'Stephen King');
INSERT INTO books (book_id, title, author_id, price, stock) VALUES
(1, '1984', 1, 15.99, 30),
(2, 'Animal Farm', 1, 12.99, 40),
(3, 'Harry Potter 1', 2, 29.99, 50),
(4, 'Harry Potter 2', 2, 27.99, 35),
(5, 'The Hobbit', 3, 22.50, 25),
(6, 'LOTR: Fellowship', 3, 25.00, 20),
(7, 'Murder on the Orient Express', 4, 18.75, 10),
(8, 'And Then There Were None', 4, 20.00, 15),
(9, 'The Shining', 5, 24.00, 18),
(10, 'It', 5, 26.50, 22);
INSERT INTO customers (customer_id, name, email) VALUES
(1, 'Alice Johnson', 'alice@example.com'),
(2, 'Bob Smith', 'bob@example.com'),
(3, 'Charlie Brown', 'charlie@example.com'),
(4, 'Diana Prince', 'diana@example.com'),
(5, 'Ethan Hunt', 'ethan@example.com'),
(6, 'Fiona Glenanne', 'fiona@example.com'),
(7, 'George Miller', 'george@example.com'),
(8, 'Hannah Baker', 'hannah@example.com'),
(9, 'Ian Malcolm', 'ian@example.com'),
(10, 'Jenny Holmes', 'jenny@example.com');
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2025-05-01'),
(2, 2, '2025-05-02'),
(3, 3, '2025-05-03'),
(4, 4, '2025-05-04'),
(5, 5, '2025-05-05'),
(6, 6, '2025-05-06'),
(7, 7, '2025-05-07'),
(8, 8, '2025-05-08'),
(9, 9, '2025-05-09'),
(10, 10, '2025-05-10');
INSERT INTO order_items (item_id, order_id, book_id, quantity) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 1),
(4, 4, 4, 2),
(5, 5, 5, 1),
(6, 6, 6, 1),
(7, 7, 7, 2),
(8, 8, 8, 1),
(9, 9, 9, 1),
(10, 10, 10, 1);
INSERT INTO reviews (review_id, book_id, customer_id, rating, comment) VALUES
(1, 1, 1, 5, 'A dystopian masterpiece.'),
(2, 2, 2, 4, 'Great political satire.'),
(3, 3, 3, 5, 'Loved the magic and adventure!'),
(4, 4, 4, 4, 'Exciting sequel.'),
(5, 5, 5, 5, 'Classic fantasy story.'),
(6, 6, 6, 5, 'Epic start to a journey.'),
(7, 7, 7, 4, 'Suspenseful and well-written.'),
(8, 8, 8, 5, 'Could not put it down.'),
(9, 9, 9, 3, 'Creepy but compelling.'),
(10, 10, 10, 4, 'Long but interesting.');
#Retrieve all books with their titles, prices, and available stock.
select book_id, title, price, stock from books;
#update the stock of a book
update books set stock = 40 ;
select * from books;
update books set stock = stock+5 where book_id=4;
#DELETE reviews  with rating < 2
delete from reviews 
where rating < 4;
select* from reviews;
#List all books sorted by price in descending order.
select title, price from books 
order by price desc
limit 3;
#count of total no of books
select count(title) from books;
select sum(stock) from books;
#Show how many books each author has written; filter only those who wrote more than 2 books.
select author_id, count(*) as sumofbook from books
group by author_id
having sumofbook>1;
#Find books where the title starts with “Harry”.
select title from books 
where title like "Harry%";
#Find books whose price is above the average book price.
select title, price from books
where price > (select avg(price) from books); 
#Display book titles along with their respective author names.
select b.title, a.name 
from books b 
inner join  authors a 
on b.author_id=a.author_id;
-- Show all customers and their order dates, including those who haven’t placed any orders
SELECT c.customer_id, c.name AS customer_name, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_id, c.name AS customer_name, o.order_date
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- List all unique pairs of authors
SELECT a1.name AS author_1, a2.name AS author_2
FROM authors a1
JOIN authors a2 ON a1.author_id < a2.author_id;
-- Convert all customer names to uppercase
SELECT customer_id, UPPER(name) AS uppercase_name, email
FROM customers;
-- Find all orders placed in the last 30 days
SELECT * 
FROM orders
WHERE order_date >= CURDATE()-INTERVAL 30 DAY;
-- Round off book prices to the nearest whole number
SELECT book_id, title, ROUND(price) AS rounded_price
FROM books;

DELIMITER //

CREATE PROCEDURE GetBooksAbovePrice(IN min_price DECIMAL(6,2))
BEGIN
    SELECT * FROM books
    WHERE price > min_price;
END //

DELIMITER ;
CALL GetBooksAbovePrice(20.00);


