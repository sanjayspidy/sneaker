-- User Table
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    avatar VARCHAR(255), -- Placeholder, adjust as needed
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    user_name VARCHAR(25) NOT NULL UNIQUE,
    phone BIGINT NOT NULL UNIQUE CHECK (LENGTH(CAST(phone AS CHAR)) = 10),
    dob DATE NOT NULL,
    email VARCHAR(25) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Recommend using longer, hashed password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Address Table
CREATE TABLE address (
    add_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title ENUM('home', 'others', 'office'),
    address_line_1 VARCHAR(100) NOT NULL,
    address_line_2 VARCHAR(100),
    country VARCHAR(10) NOT NULL,
    city VARCHAR(12) NOT NULL,
    postal_code INT NOT NULL CHECK (LENGTH(CAST(postal_code AS CHAR)) = 6),
    land_mark VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Category Table
CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(25) NOT NULL,
    description VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Sub Category Table
CREATE TABLE sub_category (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(25) NOT NULL,
    description VARCHAR(200) NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);





-- Product Table
CREATE TABLE product (
    pid INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(25) NOT NULL,
    description VARCHAR(200) NOT NULL,
    summary VARCHAR(500) NOT NULL,
    sub_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (sub_id) REFERENCES sub_category(sub_id)
);

-- Attribute Table (Size and Color)
CREATE TABLE attribute (
    att_id INT PRIMARY KEY AUTO_INCREMENT,
    size INT NOT NULL,
    color VARCHAR(15) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Product SKUs Table
CREATE TABLE product_skus (
    skus_id INT PRIMARY KEY AUTO_INCREMENT,
    pid INT NOT NULL,
    size_id INT NOT NULL,
    color_id INT NOT NULL,
    status ENUM('out of stock', 'available'),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (pid) REFERENCES product(pid),
    FOREIGN KEY (size_id) REFERENCES attribute(att_id),
    FOREIGN KEY (color_id) REFERENCES attribute(att_id)
);

-- Wishlist Table
CREATE TABLE wishlist (
    w_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(pid),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Cart Table
CREATE TABLE cart (
    c_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Cart Items Table
CREATE TABLE cart_item (
    citm_id INT PRIMARY KEY AUTO_INCREMENT,
    c_id INT NOT NULL,
    product_id INT NOT NULL,
    skus_id INT NOT NULL,
    quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (c_id) REFERENCES cart(c_id),
    FOREIGN KEY (product_id) REFERENCES product(pid),
    FOREIGN KEY (skus_id) REFERENCES product_skus(skus_id)
);

-- Order Details Table
CREATE TABLE order_detail (
    o_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Payment Table
CREATE TABLE payment (
    pay_id INT PRIMARY KEY AUTO_INCREMENT,
    o_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('success', 'failed'),
    payment_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (o_id) REFERENCES order_detail(o_id)
);

-- Order Items Table
CREATE TABLE order_item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    o_id INT NOT NULL,
    product_id INT NOT NULL,
    skus_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (o_id) REFERENCES order_detail(o_id),
    FOREIGN KEY (product_id) REFERENCES product(pid),
    FOREIGN KEY (skus_id) REFERENCES product_skus(skus_id)
);
