set search_path to lab;

-- Wypisać dane towaru (opis i cenę sprzedaży) oraz różnicę między jego ceną a średnią ceną sprzedaży towarów.
select i.description,
       i.sell_price,
       i.cost_price - (select cast(avg(i2.sell_price) as numeric(7, 2))
                       from item i2) as roznica_koszt_avgsprzedazy
from item i;

-- Wypisać dane osób, które kiedykolwiek kupiły wybrany produkt.
select c.fname, c.lname
from customer c
         join lab.orderinfo o on c.customer_id = o.customer_id
         join lab.orderline o2 on o.orderinfo_id = o2.orderinfo_id
         join lab.item i on o2.item_id = i.item_id
where i.description = 'Tissues';

SELECT c.fname, c.lname
FROM lab.customer c
         JOIN lab.orderinfo o ON o.customer_id = c.customer_id
WHERE o.orderinfo_id IN (SELECT ol.orderinfo_id
                         FROM lab.orderline ol
                         WHERE ol.item_id IN (SELECT i.item_id FROM lab.item i WHERE i.description = 'Tissues'));


-- Wypisać dane o zamówieniach złożonych przez klienta o nazwisku Howard.
select *
from orderinfo o
where o.customer_id = (select c.customer_id
                       from customer c
                       where c.lname = 'Howard');

-- Wypisać dane o zamówieniach złożonych przez klienta o nazwisku Stones.
select *
from orderinfo o
where o.customer_id in (select c.customer_id
                        from customer c
                        where c.lname = 'Stones');

-- Wypisać dane klientów, którzy nie złożyli żadnego zamówienia.
select *
from customer c
where c.customer_id not in (select o.customer_id
                            from orderinfo o);

-- Wypisać identyfikatory towarów, które zostały zamówione w ilości równej zapasowi tego towaru w magazynie.
select i.item_id
from item i
         join lab.orderline o on i.item_id = o.item_id
where o.quantity = any (select s.quantity
                        from stock s
                        where i.item_id = s.item_id);

-- Wypisać nazwy towarów droższych niż jakikolwiek towar, którego mamy w magazynie mniej niż 9 sztuk.
select i.description
from item i
where i.sell_price > all (select i2.sell_price
                          from stock s
                                   join item i2 using (item_id)
                          where s.quantity < 9)
order by i.sell_price;