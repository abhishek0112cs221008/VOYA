CREATE DATABASE VOYA;
USE VOYA;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role ENUM('admin', 'customer') DEFAULT 'customer'
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    quantity INT,
    image_url VARCHAR(255),
    description TEXT
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100),
    product_id INT,
    quantity INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE orders ADD payment_id VARCHAR(100);
ALTER TABLE orders ADD COLUMN status ENUM('Pending', 'Shipped', 'Delivered') DEFAULT 'Pending';

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_email VARCHAR(100),
    user_name VARCHAR(100),
    rating INT,
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100),
    full_name VARCHAR(100),
    phone VARCHAR(15),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    country VARCHAR(50) DEFAULT 'India',
    is_default BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_email) REFERENCES users(email)
);

CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100), -- or use user_id INT if preferred
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_email) REFERENCES users(email),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

SELECT * FROM users;
ALTER TABLE users ADD is_mem22ber BOOLEAN DEFAULT FALSE;
UPDATE users SET role = "admin" where id = 1; -- admin pannel =>  pass = voya 


INSERT INTO products (name, category, price, quantity, image_url, description) VALUES
('Red Gift Bag', 'Gift Bags', 489.00, 9, 'https://images.pexels.com/photos/5625131/pexels-photo-5625131.jpeg', 'Vibrant red gift bag made from premium paper with sturdy soft handles, perfect for birthdays, celebrations, and gifting special items.'),
('Classic Canvas Tote', 'Eco-Friendly Bags', 249.00, 30, 'https://images.pexels.com/photos/17905243/pexels-photo-17905243.jpeg', 'Beige canvas tote bag, spacious, durable, and stylish. Ideal for daily errands, shopping, and eco-conscious living.'),
('White Woven Shopping Bag', 'Shopping Bags', 799.00, 0, 'https://images.pexels.com/photos/5872361/pexels-photo-5872361.jpeg', 'Elegant white woven bag, perfect for shopping or carrying flowers and gifts. Features a sophisticated braided design and strong handles.'),
('Woven Bag', 'Shopping Bags', 359.00, 4, 'https://images.pexels.com/photos/1214212/pexels-photo-1214212.jpeg', 'Recyclable brown kraft paper bag set, sturdy. Features a sophisticated braided design and strong handles.'),
('Brown Kraft Paper Bag Set', 'Shopping Bags', 309.00, 40, 'https://images.pexels.com/photos/4068314/pexels-photo-4068314.jpeg', 'Recyclable brown kraft paper bag set, sturdy, eco-friendly, and ideal for groceries, takeaway, or retail gifts.'),
('Classic Black Leather Tote', 'Leather Bags', 2199.00, 10, 'https://images.pexels.com/photos/157888/fashion-glasses-go-pro-female-157888.jpeg', 'Sophisticated black leather tote bag with gold accents, perfect for work or casual outings. Durable design with modern minimalist style.'),
('Urban Tan Messenger Bag', 'Leather Bags', 1499.00, 12, 'https://images.pexels.com/photos/1152077/pexels-photo-1152077.jpeg', 'Smart tan leather messenger bag, ideal for professionals. Features multiple compartments for easy organization of gadgets and stationery.'),
('Royal Blue City Bag', 'Leather Bags', 1799.00, 8, 'https://images.pexels.com/photos/1228624/pexels-photo-1228624.jpeg', 'Fashion-forward royal blue leather city bag, stylish and functional for daily commutes. Spacious interior with chic hardware detailing.'),
('Elegant Travel Sling', 'Leather Bags', 1299.00, 15, 'https://images.pexels.com/photos/2002717/pexels-photo-2002717.jpeg', 'Elegant dual-tone travel sling with adjustable strap. Great for keeping essentials secure while on the move, with a timeless aesthetic.'),
('Mint Bow Gift Bag', 'Gift Bags', 129.00, 8, 'https://images.pexels.com/photos/7318915/pexels-photo-7318915.jpeg', 'Elegant mint-colored gift bag adorned with a soft pink bow and decorative tag. Perfect for weddings, birthdays, and special occasions.'),
('Black Friday Red Gift Bag', 'Gift Bags', 99.00, 29, 'https://images.pexels.com/photos/5868241/pexels-photo-5868241.jpeg', 'Bold red gift bag featuring a Black Friday tag, ideal for promotional sales, events, and holiday gifting.'),
('Sale Celebration Gift Bag Set', 'Gift Bags', 149.00, 27, 'https://images.pexels.com/photos/5868741/pexels-photo-5868741.jpeg', 'Stylish red, white, and brown gift bag set designed for sale events and festive celebrations. Roomy and sturdy to hold various gift items.'),
('Eco Kraft Gift Bags', 'Gift Bags', 269.00, 31, 'https://images.pexels.com/photos/1474958/pexels-photo-1474958.jpeg', 'Natural brown kraft gift bags with twisted handles. Sustainable choice for parties, retail, and everyday gifting needs.'),
('Eco Friendly Cotton Tote', 'Eco-Friendly Bags', 299.00, 20, 'https://images.pexels.com/photos/5709651/pexels-photo-5709651.jpeg', 'Durable and reusable cotton tote bag, perfect for eco-conscious shopping and daily use.'),
('Reusable Jute Shopping Bag', 'Eco-Friendly Bags', 67.00, 15, 'https://images.pexels.com/photos/4792667/pexels-photo-4792667.jpeg', 'Strong jute fiber bag offering an environmentally friendly alternative to plastic bags.'),
('Plant-Based Biodegradable Bag', 'Eco-Friendly Bags', 399.00, 10, 'https://images.pexels.com/photos/7564204/pexels-photo-7564204.jpeg', 'Innovative plant-based biodegradable shopping bag designed for sustainability and style.');
