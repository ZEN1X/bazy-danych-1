set search_path to lab;

-- Zestawienie dla każdego klienta, ile razy kupował i ile rzeczy kupił.
select c.customer_id,
       c.fname,
       c.lname,
       (select count(*)
        from lab.orderinfo oi
        where c.customer_id = oi.customer_id) as orders_count,
       (select sum(quantity)
        from lab.orderline ol
                 join lab.orderinfo o on ol.orderinfo_id = o.orderinfo_id
        where o.customer_id = c.customer_id)  as items_ordered_count
from lab.customer c;

-- ile unikalnych rzeczy kupil (jesli quantity > 1 w orderline, to i tak liczone jako 1 raz)
SELECT c.lname || ' ' || c.fname                                                  AS klient,
       (SELECT count(*) FROM lab.orderinfo o WHERE o.customer_id = c.customer_id) AS ile_razy_kupowal,
       (SELECT count(*)
        FROM lab.orderinfo o,
             lab.orderline l
        WHERE o.customer_id = c.customer_id
          AND o.orderinfo_id = l.orderinfo_id
        GROUP BY o.customer_id)                                                   AS ile_kupil
FROM lab.customer c;

-- Ćwiczenie: Dla każdego zakupu proszę wypisać, kto kupił i ile rzeczy w danym zamówieniu kupił.
select c.fname || ' ' || c.lname                 as klient,
       (select o.orderinfo_id
        from lab.orderinfo o
        where c.customer_id = o.customer_id
        limit 1)                                 as nr_zamowienia,
       (select sum(quantity)
        from lab.orderline o2,
             lab.orderinfo o3
        where c.customer_id = o3.customer_id
          and o2.orderinfo_id = o3.orderinfo_id) as ile_rzeczy
-- zle

from lab.customer c
order by nr_zamowienia nulls last;

select c.fname || ' ' || c.lname                as klient,
       o.orderinfo_id                           as nr_zamowienia,
       (select sum(ol.quantity)
        from lab.orderline ol
        where ol.orderinfo_id = o.orderinfo_id) as ile_rzeczy

from lab.customer c,
     lab.orderinfo o
where c.customer_id = o.customer_id
order by nr_zamowienia;

-- Informacje o towarach, które mają przypisane kody.
select *
from lab.item i
where exists(select *
             from lab.barcode b
             where i.item_id = b.item_id);

-- Wyszukać klientów mających takie samo imię i nazwisko, ale inne id.
select c.customer_id, c.fname, c.lname
from customer c
where exists(select c2.customer_id
             from customer c2
             where c.customer_id <> c2.customer_id
               and c.fname = c2.fname
               and c.lname = c2.lname);

SELECT c1.customer_id, c1.fname, c1.lname
FROM lab.customer AS c1
WHERE EXISTS (SELECT c2.customer_id
              FROM lab.customer AS c2
              WHERE c1.lname = c2.lname
                AND c1.customer_id <> c2.customer_id);

-- Wyrażenie NOT EXISTS – do wyszukiwania wierszy, dla których podzapytanie nie zwraca danych.

-- Lista towarów bez kodów.
select i.description
from item i
where not exists(select *
                 from barcode b
                 where b.item_id = i.item_id);