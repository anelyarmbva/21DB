CREATE TABLE Products(
    UPCode varchar(255) PRIMARY KEY,
    name varchar(255),
    size varchar(255),
    price varchar(255),
    typeID varchar(255),
    brandID varchar(255),
    FOREIGN KEY(typeID) references types_product(typeID),
    FOREIGN KEY(brandID) references Brands(brandID)
);


CREATE TABLE Brands(
  brandId varchar(255) PRIMARY KEY,
  brands_name varchar(255),
  vendorID INT,
  FOREIGN KEY(vendorID) references vendor(vendorID)
);

CREATE TABLE types_product(
    typeID varchar(255) PRIMARY KEY,
    type_name varchar(255)
);

CREATE TABLE Orders(
    OrderID INT PRIMARY KEY,
    customerID INT,
    storeID INT,
    product_name varchar(255),
    delivery_method varchar(255),
    payment_method varchar(255),
    order_status BOOLEAN,
    FOREIGN KEY(storeID) references store(storeID),
    FOREIGN KEY(customerID) references customer(customerID)
);


CREATE TABLE vendor(
    vendorID INT PRIMARY KEY,
    vendor_name varchar(255),
    gender varchar(1),
    vendor_contact varchar(11)
);

CREATE TABLE store(
    storeID INT PRIMARY KEY,
    stote_name varchar(255),
    city varchar(255),
    address varchar(255),
    manager varchar(255),
    num_of_products INT,
    contact_number varchar(11)
);

CREATE TABLE customer(
    customerID INT PRIMARY KEY,
    name varchar(255),
    gender varchar(1),
    contact_number varchar(11)
);

CREATE TABLE payment (
    paymentID INT PRIMARY KEY,
    payment_method varchar(255),
    amount varchar(255)
);

CREATE TABLE delivery(
    deliveryID INT PRIMARY KEY,
    orderID INT,
    delivery_method varchar(255),
    deliver_name varchar(255),
    deliver_contact varchar(11),
    delivery_address varchar(255),
    FOREIGN KEY(orderID) references Orders(OrderID)
);