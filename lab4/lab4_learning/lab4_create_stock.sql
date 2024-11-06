create table lab.stock
(
    item_id  integer   not null,
    quantity  integer  not null,
    CONSTRAINT stock_pk PRIMARY KEY(item_id)
);

insert into lab.stock(item_id, quantity) values(1,12);
insert into lab.stock(item_id, quantity) values(2,2);
insert into lab.stock(item_id, quantity) values(4,8);
insert into lab.stock(item_id, quantity) values(5,3);
insert into lab.stock(item_id, quantity) values(7,8);
insert into lab.stock(item_id, quantity) values(8,18);
insert into lab.stock(item_id, quantity) values(10,1);