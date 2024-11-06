-- Lista nazwisk klientów (również tych którzy nie złożyli zmówienia) i daty złożenia przez nich zamówień
select c.lname, o.date_placed
from customer c
         left join lab.orderinfo o on c.customer_id = o.customer_id;

-- Nazwy towarów i ilość kupionych egzemplarzy w poszczególnych zamówieniach
select i.description, ol.quantity, ol.orderinfo_id
from orderline ol
         right join item i on ol.item_id = i.item_id
order by ol.quantity nulls last;

-- Numery i nazwy wszystkich produktów (tych co są aktualnie w magazynie, oraz tych które zostały kiedyś już zamówione)
select distinct i.item_id,
                i.description
from stock s
         full join orderline using (item_id)
         join item i using (item_id)
order by item_id;