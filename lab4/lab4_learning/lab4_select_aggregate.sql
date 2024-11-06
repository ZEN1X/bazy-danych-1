-- Ilu klientów (proszę podać nazwisko) mieszka w poszczególnych miastach i ile jest tam osób o tych samych nazwiskach?
select count(*), c.lname, c.town
from customer c
group by c.lname, c.town
order by c.lname;

-- Znaleźć nazwiska wszystkich klientów i miast, skąd oni pochodzą  z wyjątkiem miasta Lincoln.Istotne są tylko te miasta, skąd pochodzi więcej niż jeden klient.
-- #1 wszystko bez miasta Lincoln
select distinct c.lname as Nazwisko, c.town Miasto
from customer c
where c.town <> 'Lincoln';

-- #2
select c.lname, c.town
from customer c
where c.town <> 'Lincoln'
group by c.lname, c.town
having count(*) > 1;

-- Do ilu klientów znamy telefon?
select count(c.phone)
from customer c;

-- Proszę podać ile razy kupowane były poszczególne towary ( opis, ilość zakupów) posortowane po ilości zakupów
select count(*) as ile, i.description
from lab.item i
         left join lab.orderline ol on i.item_id = ol.item_id
group by i.description, i.item_id
order by ile;

-- Proszę podać ile sztuk poszczególnych towarów kupiono - ile, id_towaru, nazwa towaru
select sum(ol.quantity) as ile, i.item_id as id_towaru, i.description as nazwa_towaru
from lab.item i
         left join lab.orderline ol on i.item_id = ol.item_id
group by i.description, i.item_id
order by ile nulls first;

-- Proszę podać zestawienie: numer rachunku, wartośc zakupów
select sum(ol.quantity * i.sell_price) as wartosc, ol.orderinfo_id
from lab.orderline ol
         join lab.item i on ol.item_id = i.item_id
group by ol.orderinfo_id
order by ol.orderinfo_id;