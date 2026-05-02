-- CREATE DATABASE restaurant_management_system;
-- USE restaurant_management_system;

CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100)  NOT NULL,
    email       VARCHAR(150)  NOT NULL UNIQUE,
    username    VARCHAR(60)   NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL,  -- BCrypt hashed
    role        ENUM('ADMIN','STAFF','KITCHEN') NOT NULL DEFAULT 'STAFF',
    active      TINYINT(1)    NOT NULL DEFAULT 1,
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role     (role)
);

CREATE TABLE IF NOT EXISTS dining_tables (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    table_number VARCHAR(10)  NOT NULL UNIQUE,  
    capacity    INT           NOT NULL DEFAULT 4,
    status      ENUM('FREE','OCCUPIED','RESERVED') NOT NULL DEFAULT 'FREE',
    qr_token    VARCHAR(100)  UNIQUE,            
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
);

CREATE TABLE IF NOT EXISTS categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80)   NOT NULL UNIQUE,
    display_order INT         NOT NULL DEFAULT 0,
    active      TINYINT(1)    NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS menu_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT           NOT NULL,
    name        VARCHAR(120)  NOT NULL,
    description TEXT,
    price       DECIMAL(10,2) NOT NULL,
    emoji       VARCHAR(10)   DEFAULT '🍽️',
    image_url   VARCHAR(300),
    available   TINYINT(1)    NOT NULL DEFAULT 1,
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    INDEX idx_category (category_id),
    INDEX idx_available (available)
);

CREATE TABLE IF NOT EXISTS orders (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    order_code  VARCHAR(20)   NOT NULL UNIQUE,  -- ORD-2024-001
    table_id    INT           NOT NULL,
    waiter_id   INT,                            -- Staff who took/managed order
    status      ENUM('PENDING','PREPARING','READY','SERVED','CANCELLED')
                              NOT NULL DEFAULT 'PENDING',
    notes       TEXT,
    ordered_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id)  REFERENCES dining_tables(id) ON DELETE RESTRICT,
    FOREIGN KEY (waiter_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_table     (table_id),
    INDEX idx_status    (status),
    INDEX idx_ordered   (ordered_at)
);

CREATE TABLE IF NOT EXISTS order_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT           NOT NULL,
    menu_item_id INT          NOT NULL,
    quantity    INT           NOT NULL DEFAULT 1,
    unit_price  DECIMAL(10,2) NOT NULL,  -- snapshot at time of order
    special_note VARCHAR(255),
    FOREIGN KEY (order_id)     REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id)
);

CREATE TABLE IF NOT EXISTS bills (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT           NOT NULL UNIQUE,
    subtotal    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    vat_rate    DECIMAL(5,2)  NOT NULL DEFAULT 13.00,
    vat_amount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    service_rate  DECIMAL(5,2) NOT NULL DEFAULT 10.00,
    service_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_pct  DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    discount_amt  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    generated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_generated (generated_at)
);

CREATE TABLE IF NOT EXISTS payments (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    bill_id     INT           NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    method      ENUM('CASH','ESEWA','KHALTI','CARD') NOT NULL DEFAULT 'CASH',
    status      ENUM('PAID','UNPAID','PENDING')       NOT NULL DEFAULT 'PENDING',
    transaction_ref VARCHAR(100),
    processed_by INT,                                 -- staff user id
    paid_at     DATETIME,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bill_id)       REFERENCES bills(id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by)  REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_status  (status),
    INDEX idx_paid_at (paid_at)
);

CREATE TABLE IF NOT EXISTS reservations (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    guest_name   VARCHAR(100) NOT NULL,
    guest_phone  VARCHAR(20),
    guest_email  VARCHAR(150),
    table_id     INT,
    party_size   INT          NOT NULL DEFAULT 2,
    reserved_at  DATETIME     NOT NULL,
    status       ENUM('PENDING','CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    notes        TEXT,
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES dining_tables(id) ON DELETE SET NULL,
    INDEX idx_reserved_at (reserved_at),
    INDEX idx_status (status)
);

CREATE TABLE IF NOT EXISTS guest_feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  guest_name VARCHAR(120) NOT NULL,
  guest_email VARCHAR(160),
  table_number VARCHAR(20),
  cuisine_rating INT NOT NULL,
  service_rating INT NOT NULL,
  ambience_rating INT NOT NULL,
  overall_rating INT NOT NULL,
  comments TEXT NOT NULL,
  internal_note TEXT,
  flagged boolean NOT NULL DEFAULT false,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Users (passwords are BCrypt of: admin123, staff123, kitchen123)
INSERT INTO users (full_name, email, username, password, role) VALUES
('Nitam Bhattarai',  'nitam@gokyo.com',  'admin',   '$2a$12$rSjGpsFTL7fW4hboiaVile6sB//yL4YxxmtyAK9rGNlxD5ChC3Ghm', 'ADMIN'),
('Isha Suchcha Rai', 'isha@gokyo.com',   'isha',    '$2a$12$TxHpssFvOvKdqeIz3RoJQe1dM3tVZzsG.xXFD0n/COmDZ8XaBsjlq', 'STAFF'),
('Aryan Thapa',      'aryan@gokyo.com',  'aryan',   '$2a$12$TxHpssFvOvKdqeIz3RoJQe1dM3tVZzsG.xXFD0n/COmDZ8XaBsjlq', 'STAFF'),
('Sujal Bantawa Rai','sujal@gokyo.com',  'sujal',   '$2a$12$sruF9VbZ.2KQOfgBPd4j.u/DMPNGJohaNAMMRKkud3kRdfn7mdyLG', 'KITCHEN'),
('Puskar Acharya',   'puskar@gokyo.com', 'puskar',  '$2a$12$sruF9VbZ.2KQOfgBPd4j.u/DMPNGJohaNAMMRKkud3kRdfn7mdyLG', 'KITCHEN');

-- Tables T01–T15
INSERT INTO dining_tables (table_number, capacity, qr_token) VALUES
('T01',2,'tok_t01_gkb2024'), ('T02',4,'tok_t02_gkb2024'), ('T03',4,'tok_t03_gkb2024'),
('T04',4,'tok_t04_gkb2024'), ('T05',6,'tok_t05_gkb2024'), ('T06',4,'tok_t06_gkb2024'),
('T07',2,'tok_t07_gkb2024'), ('T08',4,'tok_t08_gkb2024'), ('T09',6,'tok_t09_gkb2024'),
('T10',4,'tok_t10_gkb2024'), ('T11',4,'tok_t11_gkb2024'), ('T12',2,'tok_t12_gkb2024'),
('T13',4,'tok_t13_gkb2024'), ('T14',4,'tok_t14_gkb2024'), ('T15',6,'tok_t15_gkb2024');

-- Categories
INSERT INTO categories (name, display_order) VALUES
('Starters', 1), ('Main Course', 2), ('Drinks', 3), ('Desserts', 4);

-- Menu Items
INSERT INTO menu_items (category_id, name, description, price, emoji) VALUES
(1,'Crispy Spring Rolls','Golden fried rolls with vegetables and sweet chilli dip',220.00,'🥢'),
(1,'Garlic Cheese Bread','Toasted sourdough with herb butter and melted gruyère',180.00,'🥖'),
(1,'Tomato Basil Soup','Roasted plum tomatoes, basil oil, house-made croutons',200.00,'🍲'),
(1,'Chicken Momo','Steamed dumplings with spiced chicken and sesame dip',280.00,'🥟'),
(1,'Sampler Platter','Assorted starters — spring rolls, pakora, chilli paneer',380.00,'🍱'),
(2,'Butter Chicken','Slow-cooked chicken in rich tomato cream sauce, Basmati rice',480.00,'🍛'),
(2,'Grilled Atlantic Salmon','Lemon herb butter, seasonal greens, roasted potatoes',650.00,'🐟'),
(2,'Dal Bhat Set','Lentil soup, steamed rice, seasonal curry, house achar',320.00,'🍚'),
(2,'Nepali Thali','Rice, dal, two curries, pickles and papad',420.00,'🥘'),
(2,'Margherita Pizza','Thin crust, San Marzano tomato, buffalo mozzarella, basil',550.00,'🍕'),
(2,'Black Truffle Tagliatelle','Hand-rolled pasta, aged butter, shaved Périgord truffle',780.00,'🍝'),
(2,'Lamb Sekuwa','Charcoal-grilled lamb skewers with mint chutney',580.00,'🍖'),
(3,'Mango Lassi','Fresh Alphonso mango, chilled yogurt, cardamom',140.00,'🥭'),
(3,'Masala Chai','Spiced milk tea with cardamom, ginger, cinnamon',80.00,'☕'),
(3,'Fresh Lime Soda','Chilled lime with soda — sweet, salted or mixed',110.00,'🍋'),
(3,'Virgin Mojito','Mint, lime, sugar syrup, sparkling water',150.00,'🍃'),
(3,'Wine Pairing','Sommelier-selected glass pairing for your main course',350.00,'🍷'),
(4,'Chocolate Lava Cake','Warm dark chocolate, molten center, vanilla ice cream',280.00,'🍫'),
(4,'Gulab Jamun','Milk dumplings in rose-cardamom sugar syrup',160.00,'🍮'),
(4,'Mango Kulfi','Traditional frozen dessert with Alphonso mango and pistachios',180.00,'🍦'),
(4,'Seasonal Tart','Chef''s daily creation — ask your server for today''s selection',220.00,'🧁');

-- Sample reservations
INSERT INTO reservations (guest_name, guest_phone, table_id, party_size, reserved_at, status) VALUES
('Ramesh Sharma','9841234567',6,4, DATE_ADD(NOW(), INTERVAL 3 HOUR), 'CONFIRMED'),
('Anita Poudel', '9851234567',12,2, DATE_ADD(NOW(), INTERVAL 4 HOUR), 'PENDING');

-- Sample Guest Feedback
INSERT INTO guest_feedback (guest_name, guest_email, table_number, cuisine_rating, service_rating, ambience_rating, overall_rating, comments, flagged) VALUES
('Anjali Sharma', 'anjali@example.com', 'T12', 5, 5, 5, 5, 'The Himalayan Trout was absolutely sublime. Authentic flavors that reminded me of home. The staff was incredibly attentive to our needs throughout the evening. Definitely coming back!', false),
('David Miller', 'david.m@example.com', 'T04', 5, 3, 5, 3, 'Food was great as usual, but we had to wait 25 minutes for our drinks to arrive. It was a busy Friday night, but service could be slightly faster during peak hours. Great vibe though.', true),
('Rahul K.C.', 'rahul@example.com', 'T09', 4, 4, 5, 4, 'Really loved the ambience and the music. The Butter Chicken was a bit too sweet for my taste, but the garlic cheese bread made up for it.', false);
