create schema lab6;
set search_path to lab6;

-- boolean

CREATE TABLE stock_availability
(
    product_id INT PRIMARY KEY,
    available  BOOLEAN NOT NULL
);

INSERT INTO stock_availability (product_id, available)
VALUES (100, TRUE),
       (200, FALSE),
       (300, 't'),
       (400, '1'),
       (500, 'y'),
       (600, 'yes'),
       (700, 'no'),
       (800, '0');

SELECT *
FROM stock_availability;

SELECT *
FROM stock_availability
WHERE available = 'yes';

-- varchar, char, text

CREATE TABLE string_fixed_values
(
    fixed_text char(5),
    var_text   varchar(5)
);

-- Próba wstawienia zbyt długich wartości
INSERT INTO string_fixed_values
VALUES ('abcdefg', 'abcdefg');


-- Wstawienie zbyt długiego tekstu, gdzie przekraczającymi znakami są spacje
INSERT INTO string_fixed_values
VALUES ('abc          ', 'cde          ');

-- Wstawienie zbyt długich wartości tekstowych, ale z jawnym rzutowaniem
INSERT INTO string_fixed_values
VALUES ('abcdefg'::CHAR(5), 'abcdefg'::VARCHAR(5));


SELECT *
FROM string_fixed_values;

-- numeric

CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    price NUMERIC(5, 2) --precyzja 5 skala 2 --> ilosc cyfr 5 po przecinku 2
);

INSERT INTO products (name, price)
VALUES ('Phone', 500.215), --zostanie zaokraglone do w dół
       ('Tablet', 500.214); --zostanie zaokraglone do w dół

SELECT *
FROM products;

INSERT INTO products (name, price)
VALUES ('Phone', 123456.21);

UPDATE products
SET price = 'NaN'
WHERE id = 1;

SELECT *
FROM products
ORDER BY price DESC;

-- date

CREATE TABLE documents
(
    document_id   serial PRIMARY KEY,
    header_text   VARCHAR(255) NOT NULL,
    posting_date  DATE         NOT NULL DEFAULT CURRENT_DATE,
    delivery_date DATE
);

INSERT INTO documents (header_text)
VALUES ('Billing to customer XYZ');

SELECT *
FROM documents;

SELECT NOW()::date; --funkcja wbudowana zwracajaca aktualny czas
select now();

SELECT TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy'); --rzutowanie na tekst

SELECT TO_CHAR(NOW() :: DATE, 'Mon dd, yyyy');

INSERT INTO documents (header_text, delivery_date)
VALUES ('Billing to customer ABC', '2021-11-23');

SELECT header_text, delivery_date - posting_date AS diff, now() - posting_date AS time
FROM documents;

CREATE TABLE person
(
    person_id  serial PRIMARY KEY,
    first_name VARCHAR(255),
    last_name  VARCHAR(355),
    birth_date DATE NOT NULL
);

INSERT INTO person (first_name, last_name, birth_date)
VALUES ('Shannon', 'Freeman', '1980-01-01'),
       ('Sheila', 'Wells', '1978-02-05'),
       ('Ethel', 'Webb', '1975-01-01');

SELECT first_name, last_name, AGE(birth_date)
FROM person;

SELECT first_name,
       last_name,
       EXTRACT(YEAR FROM birth_date)  AS YEAR,
       EXTRACT(MONTH FROM birth_date) AS MONTH,
       EXTRACT(DAY FROM birth_date)   AS DAY
FROM person;