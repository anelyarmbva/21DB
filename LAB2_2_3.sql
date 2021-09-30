CREATE TABLE customers (
    id INTEGER NOT NULL UNIQUE  PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    delivery_address TEXT NOT NULL
);

CREATE TABLE products (
    id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    price DOUBLE PRECISION NOT NULL CHECK ( price > 0 )
);

CREATE TABLE orders (
    code INTEGER NOT NULL UNIQUE PRIMARY KEY,
    customer_id INTEGER references costumers(id),
    total_sum DOUBLE PRECISION NOT NULL CHECK ( total_sum > 0 ),
    is_paid BOOLEAN NOT NULL
);

CREATE TABLE order_items (
    order_code INTEGER NOT NULL UNIQUE references orders(code),
    product_id VARCHAR(255) NOT NULL UNIQUE references products(id),
    quantity INTEGER NOT NULL CHECK ( quantity > 0 )
);

INSERT INTO products VALUES ('22', 'chocolate', 'with cream', 1235);
INSERT INTO products VALUES ('25', 'apple', 'juice', 544);
INSERT INTO products VALUES ('14', 'tea', 'with banana', 600);


UPDATE products SET price = 640 WHERE name = 'tea';

DELETE FROM products WHERE name = 'apple';

CREATE TABLE students (
    id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL,
    average_grade DOUBLE PRECISION NOT NULL CHECK ( average_grade > 0 ),
    dormitory_is_needed BOOLEAN NOT NULL
);

CREATE TABLE instructors (
    id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    speaking_languages  INTEGER NOT NULL,
    work_experience INTEGER NOT NULL,
    remote_lessons BOOLEAN NOT NULL
);

CREATE TABLE attendance (
    lessons_titLe VARCHAR(255) NOT NULL,
    teacher VARCHAR(255) NOT NULL,
    studying_students VARCHAR(255) NOT NULL,
    room INTEGER NOT NULL,
    FOREIGN KEY (full_name) references instructors,
    FOREIGN KEY (full_name) references students
);
