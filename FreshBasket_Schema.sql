-- FreshBasket Database Schema
-- Run this in MySQL Workbench

CREATE DATABASE IF NOT EXISTS freshbasket;
USE freshbasket;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Addresses table
CREATE TABLE IF NOT EXISTS addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    street_address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (user_email) REFERENCES users(email) ON DELETE CASCADE
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('placed', 'shipped', 'delivered') DEFAULT 'placed',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_email) REFERENCES users(email) ON DELETE CASCADE
);

-- Order Items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price_at_time DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    stock INT DEFAULT 0,
    img TEXT,
    `desc` TEXT
);

-- Insert initial products
INSERT INTO products (name, category, price, rating, stock, img, `desc`) VALUES
('Banana (1 dozen)', 'Fruits', 60, 4.5, 50, 'https://m.media-amazon.com/images/I/51W9iO9AwhL._AC_UF1000,1000_QL80_.jpg', 'Sweet ripe bananas, perfect for breakfast and smoothies.'),
('Tomato (1kg)', 'Vegetables', 40, 4.2, 30, 'https://media.istockphoto.com/id/1132371208/photo/three-ripe-tomatoes-on-green-branch.jpg?s=612x612&w=0&k=20&c=qVjDb5Tk3-UccV-E9gqvoz97PTsP1QmBftw27qA9kEo=', 'Fresh juicy tomatoes, farm-picked daily.'),
('Cow Milk (1L)', 'Dairy', 55, 4.8, 100, 'https://media.istockphoto.com/id/1297005860/photo/raw-milk-being-poured-into-container.jpg?s=612x612&w=0&k=20&c=5Xumh49_zYs9GjLkGpZXM41tS17K8M-svN9jLMv0JpE=', 'Fresh full-cream cow milk sourced locally every morning.'),
('Potato (1kg)', 'Vegetables', 35, 4.0, 60, 'https://cdn.mos.cms.futurecdn.net/iC7HBvohbJqExqvbKcV3pP.jpg', 'Starchy potatoes, versatile in cooking.'),
('Apples (1kg)', 'Fruits', 200, 4.6, 25, 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?q=80&w=800&auto=format&fit=crop', 'Crisp sweet apples, great for snacking.'),
('Paneer (200g)', 'Dairy', 90, 4.7, 15, 'https://umamigirl.com/wp-content/uploads/2023/04/How-to-Make-Paneer-at-Home-Umami-Girl.jpg', 'Fresh soft paneer, perfect for curries and grills.'),
('Snacks Pack', 'Snacks', 45, 3.8, 80, 'https://cdnimg.webstaurantstore.com/uploads/seo_category/2023/11/Individually-Wrapped-Snacks/wrapped-snacks_one.jpg', 'Tasty crunchy assorted snack pack.'),
('Orange Juice (1L)', 'Beverages', 120, 4.3, 40, 'https://media.istockphoto.com/id/1158980367/photo/woman-hand-pouring-orange-juice-on-glasses-with-slice-orange-on-wooden-background.jpg?s=612x612&w=0&k=20&c=7eariYAOV0LRcYtl3u05K4vnSN7IJ5X7egV1gu1ALF0=', 'Fresh-squeezed orange juice, no added sugar.'),
('Spinach (250g)', 'Vegetables', 25, 4.1, 35, 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=800&auto=format&fit=crop', 'Fresh organic baby spinach, rich in iron.'),
('Mango (1kg)', 'Fruits', 150, 4.9, 20, 'https://images.unsplash.com/photo-1591073113125-e46713c829ed?q=80&w=800&auto=format&fit=crop', 'Sweet Alphonso mangoes - the king of fruits.'),
('Curd (500g)', 'Dairy', 45, 4.5, 55, 'https://tiimg.tistatic.com/fp/1/007/868/good-source-of-minerals-calcium-chemical-free-fresh-white-curd-443.jpg', 'Thick creamy dahi, perfect with meals.'),
('Green Tea (25 bags)', 'Beverages', 180, 4.4, 30, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=800&auto=format&fit=crop', 'Premium antioxidant-rich green tea bags.'),
('Whole Wheat Bread', 'Bakery', 55, 4.3, 25, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=800&auto=format&fit=crop', 'Freshly baked whole wheat bread, no preservatives.'),
('Basmati Rice (5kg)', 'Pantry', 450, 4.6, 18, 'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=800&auto=format&fit=crop', 'Premium aged Basmati rice, long-grain and aromatic.');
