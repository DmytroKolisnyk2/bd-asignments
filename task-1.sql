CREATE DATABASE task1;

USE task1;

CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Profile (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    address VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
);

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product (product_id) ON DELETE CASCADE
);

CREATE TABLE WishList (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
);

CREATE TABLE WishListProduct (
    wishlist_product_id INT AUTO_INCREMENT PRIMARY KEY,
    wishlist_id INT,
    product_id INT,
    FOREIGN KEY (wishlist_id) REFERENCES WishList (wishlist_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product (product_id) ON DELETE CASCADE
);

INSERT INTO
    User (
        username,
        email,
        password_hash
    )
VALUES (
        'user1',
        'user1@example.com',
        'passwordhash1'
    ),
    (
        'user2',
        'user2@example.com',
        'passwordhash2'
    ),
    (
        'user3',
        'user3@example.com',
        'passwordhash3'
    ),
    (
        'user4',
        'user4@example.com',
        'passwordhash4'
    ),
    (
        'user5',
        'user5@example.com',
        'passwordhash5'
    ),
    (
        'user6',
        'user6@example.com',
        'passwordhash6'
    ),
    (
        'user7',
        'user7@example.com',
        'passwordhash7'
    ),
    (
        'user8',
        'user8@example.com',
        'passwordhash8'
    ),
    (
        'user9',
        'user9@example.com',
        'passwordhash9'
    ),
    (
        'user10',
        'user10@example.com',
        'passwordhash10'
    );

INSERT INTO
    Profile (
        user_id,
        first_name,
        last_name,
        phone_number,
        address
    )
VALUES (
        1,
        'John',
        'Doe',
        '555-1234',
        '123 Maple Street, Springfield'
    ),
    (
        2,
        'Jane',
        'Smith',
        '555-5678',
        '456 Oak Avenue, Metropolis'
    ),
    (
        3,
        'Alice',
        'Johnson',
        '555-8765',
        '789 Pine Lane, Gotham'
    ),
    (
        4,
        'Bob',
        'Brown',
        '555-4321',
        '101 Cedar Blvd, Star City'
    ),
    (
        5,
        'Charlie',
        'Wilson',
        '555-9876',
        '202 Birch Road, Central City'
    ),
    (
        6,
        'David',
        'Lee',
        '555-6543',
        '303 Elm Street, Coast City'
    ),
    (
        7,
        'Emily',
        'Davis',
        '555-3210',
        '404 Palm Avenue, Riverdale'
    ),
    (
        8,
        'Frank',
        'Miller',
        '555-7654',
        '505 Chestnut Blvd, Hill Valley'
    ),
    (
        9,
        'Grace',
        'Taylor',
        '555-2109',
        '606 Willow Lane, Smallville'
    ),
    (
        10,
        'Henry',
        'Anderson',
        '555-0987',
        '707 Redwood Road, Metropolis'
    );

INSERT INTO
    Product (product_name, price)
VALUES ('Product A', 10.99),
    ('Product B', 15.49),
    ('Product C', 8.75),
    ('Product D', 25.00),
    ('Product E', 30.00),
    ('Product F', 12.99),
    ('Product G', 22.99),
    ('Product H', 18.50),
    ('Product I', 19.99),
    ('Product J', 9.49),
    ('Product K', 27.89),
    ('Product L', 14.99),
    ('Product M', 7.99),
    ('Product N', 6.50),
    ('Product O', 5.75),
    ('Product P', 16.00),
    ('Product Q', 20.00),
    ('Product R', 11.99),
    ('Product S', 24.50),
    ('Product T', 29.99);

INSERT INTO
    Purchase (user_id, product_id)
VALUES (1, 1),
    (1, 2),
    (2, 3),
    (3, 4),
    (3, 5),
    (4, 6),
    (5, 7),
    (6, 8),
    (7, 9),
    (8, 10),
    (9, 11),
    (9, 12),
    (10, 13),
    (1, 14),
    (2, 15),
    (3, 16),
    (4, 17),
    (5, 18),
    (6, 19),
    (7, 20);

INSERT INTO
    WishList (user_id)
VALUES (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10);

INSERT INTO
    WishListProduct (wishlist_id, product_id)
VALUES (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (4, 6),
    (4, 7),
    (5, 8),
    (6, 9),
    (6, 10),
    (7, 1),
    (8, 2),
    (9, 3),
    (10, 4);

WITH
    UserPurchases AS (
        SELECT u.user_id, u.username, pr.product_name, pr.price, 'Purchased' as action_type
        FROM
            User u
            JOIN Purchase prc ON u.user_id = prc.user_id
            JOIN Product pr ON pr.product_id = prc.product_id
            JOIN Profile pf ON pf.user_id = u.user_id
    ),
    UserWishlists AS (
        SELECT u.user_id, u.username, pr.product_name, pr.price, 'Wishlisted' as action_type
        FROM
            User u
            JOIN WishList w ON u.user_id = w.user_id
            JOIN WishListProduct wp ON w.wishlist_id = wp.wishlist_id
            JOIN Product pr ON pr.product_id = wp.product_id
            JOIN Profile pf ON pf.user_id = u.user_id
    )
SELECT *
FROM UserPurchases
UNION ALL
SELECT *
FROM UserWishlists;

SELECT
    u.username,
    COUNT(p.product_id) AS total_actions,
    'Purchased' AS action_type
FROM User u
    JOIN Purchase p ON p.user_id = u.user_id
GROUP BY
    u.user_id
UNION ALL
SELECT
    u.username,
    COUNT(wp.product_id) AS total_actions,
    'Wishlisted' AS action_type
FROM
    User u
    JOIN WishList w ON u.user_id = w.user_id
    JOIN WishListProduct wp ON w.wishlist_id = wp.wishlist_id
GROUP BY
    u.username
ORDER BY total_actions DESC;

SELECT u.username, SUM(pr.price) AS total_spent
FROM
    User u
    JOIN Purchase p ON u.user_id = p.user_id
    JOIN Product pr ON p.product_id = pr.product_id
    JOIN Profile pf ON pf.user_id = u.user_id
GROUP BY
    u.username
HAVING
    total_spent > 30
ORDER BY total_spent DESC;