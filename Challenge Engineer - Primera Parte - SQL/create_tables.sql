-- Creación de la tabla Customer
CREATE TABLE Customer (
    id_customer INT PRIMARY KEY,
    email VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    gender VARCHAR(20),
    address VARCHAR(255),
    birthday DATE,
    phone INT
);

-- Creación de la tabla Item
CREATE TABLE Item (
    id_item INT PRIMARY KEY,
    id_customer INT,
    id_categoria INT,
    item_name VARCHAR(255),
    desc VARCHAR(255),
    price FLOAT,
    item_status VARCHAR(20),
    release_date DATETIME,
    discharge_date DATETIME,
    FOREIGN KEY (id_customer) REFERENCES Customer(id_customer),
    FOREIGN KEY (id_categoria) REFERENCES Category(id_category)
);

-- Creación de la tabla Category
CREATE TABLE Category (
    id_category INT PRIMARY KEY,
    desc VARCHAR(255),
    path VARCHAR(255)
);

-- Creación de la tabla Order
CREATE TABLE OrderTable (
    id_order INT PRIMARY KEY,
    id_customer INT,
    id_item INT,
    quantity INT,
    purchase_date DATETIME,
    total_amount FLOAT,
    FOREIGN KEY (id_customer) REFERENCES Customer(id_customer),
    FOREIGN KEY (id_item) REFERENCES Item(id_item)
);
CREATE TABLE ItemState (
    id_item_state INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT,
    price FLOAT,
    state VARCHAR(255),
    date DATE,
    FOREIGN KEY (id_item) REFERENCES Item(id_item)
);
