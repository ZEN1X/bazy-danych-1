--tabela customer
create table lab.customer
(
    customer_id                     serial                        ,
    title                           char(4)                       ,
    fname                           varchar(32)                   ,
    lname                           varchar(32)           not null,
    addressline                     varchar(64)                   ,
    town                            varchar(32)                   ,
    zipcode                         char(10)              not null,
    phone                           varchar(16)                   ,
    CONSTRAINT                      customer_pk PRIMARY KEY(customer_id)
);

--tabela orderinfo
CREATE TABLE lab.orderinfo( orderinfo_id serial,
                        customer_id INTEGER NOT NULL REFERENCES lab.customer(customer_id),
                        date_placed DATE NOT NULL,
                        date_shipped DATE,
                        shipping NUMERIC(7,2),
                        CONSTRAINT orderinfo_pk PRIMARY KEY(orderinfo_id));

--tabela item
create table lab.item
(
    item_id                         serial                        ,
    description                     varchar(64)           not null,
    cost_price                      numeric(7,2)                  ,
    sell_price                      numeric(7,2)                  ,
    CONSTRAINT                      item_pk PRIMARY KEY(item_id)
);

--tabela lab.orderline
CREATE TABLE lab.orderline( orderinfo_id INTEGER NOT NULL,
                        item_id INTEGER NOT NULL,
                        quantity INTEGER NOT NULL,
                        CONSTRAINT orderline_pk PRIMARY KEY(orderinfo_id, item_id),
                        CONSTRAINT orderline_orderinfo_id_fk FOREIGN KEY(orderinfo_id) REFERENCES lab.orderinfo (orderinfo_id),
                        CONSTRAINT orderline_item_id_fk FOREIGN KEY(item_id) REFERENCES lab.item (item_id));


---------WYPEŁNIANIE

--tabela customer
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Miss','Jenny','Stones','27 Rowan Avenue','Hightown','NT2 1AQ','023 9876');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Andrew','Stones','52 The Willows','Lowtown','LT5 7RA','876 3527');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Miss','Alex','Matthew','4 The Street','Nicetown','NT2 2TX','010 4567');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Adrian','Matthew','The Barn','Yuleville','YV67 2WR','487 3871');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Simon','Cozens','7 Shady Lane','Oahenham','OA3 6QW','514 5926');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Neil','Matthew','5 Pasture Lane','Nicetown','NT3 7RT','267 1232');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Richard','Stones','34 Holly Way','Bingham','BG4 2WE','342 5982');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Ann','Stones','34 Holly Way','Bingham','BG4 2WE','342 5982');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Christine','Hickman','36 Queen Street','Histon','HT3 5EM','342 5432');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Mike','Howard','86 Dysart Street','Tibsville','TB3 7FG','505 5482');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Dave','Jones','54 Vale Rise','Bingham','BG3 8GD','342 8264');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Richard','Neill','42 Thached way','Winersby','WB3 6GQ','505 6482');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Laura','Hendy','73 Margeritta Way','Oxbridge','OX2 3HX','821 2335');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Bill','ONeill','2 Beamer Street','Welltown','WT3 8GM','435 1234');
insert into lab.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','David','Hudson','4 The Square','Milltown','MT2 6RT','961 4526');

--tabela item
insert into lab.item(description, cost_price, sell_price) values('Wood Puzzle', 15.23, 21.95);
insert into lab.item(description, cost_price, sell_price) values('Rubic Cube', 7.45, 11.49);
insert into lab.item(description, cost_price, sell_price) values('Linux CD', 1.99, 2.49);
insert into lab.item(description, cost_price, sell_price) values('Tissues', 2.11, 3.99);
insert into lab.item(description, cost_price, sell_price) values('Picture Frame', 7.54, 9.95);
insert into lab.item(description, cost_price, sell_price) values('Fan Small', 9.23, 15.75);
insert into lab.item(description, cost_price, sell_price) values('Fan Large', 13.36, 19.95);
insert into lab.item(description, cost_price, sell_price) values('Toothbrush', 0.75, 1.45);
insert into lab.item(description, cost_price, sell_price) values('Roman Coin', 2.34, 2.45);
insert into lab.item(description, cost_price, sell_price) values('Carrier Bag', 0.01, 0.0);
insert into lab.item(description, cost_price, sell_price) values('Speakers', 19.73, 25.32);

--tabela orderinfo
insert into lab.orderinfo(customer_id, date_placed, date_shipped, shipping) values(3,'2000-03-13','2000-03-17', 2.99);
insert into lab.orderinfo(customer_id, date_placed, date_shipped, shipping) values(8,'2000-06-23','2000-06-24', 0.00);
insert into lab.orderinfo(customer_id, date_placed, date_shipped, shipping) values(15,'2000-09-02','2000-09-12', 3.99);
insert into lab.orderinfo(customer_id, date_placed, date_shipped, shipping) values(13,'2000-09-03','2000-09-10', 2.99);
insert into lab.orderinfo(customer_id, date_placed, date_shipped, shipping) values(8,'2000-07-21','2000-07-24', 0.00);


--tabela orderline
insert into lab.orderline(orderinfo_id, item_id, quantity) values(1, 4, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(1, 7, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(1, 9, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(2, 1, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(2, 10, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(2, 7, 2);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(2, 4, 2);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(3, 2, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(3, 1, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(4, 5, 2);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(5, 1, 1);
insert into lab.orderline(orderinfo_id, item_id, quantity) values(5, 3, 1);