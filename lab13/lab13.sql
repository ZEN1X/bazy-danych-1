-- schema def
create schema if not exists lab13_JK;
set search_path to lab13_JK;

-- ZADANIE 1

-- TWORZENIE TABEL

-- dzial
create table dzial
(
    dzial_nr serial primary key,
    nazwa    text not null,
    lokal    text not null
);

-- stopien
create table stopien
(
    stopien_id        serial primary key,
    min_wynagrodzenia numeric check (min_wynagrodzenia >= 1000.0),
    max_wynagrodzenia numeric check (max_wynagrodzenia > min_wynagrodzenia)
);

-- pracownik
create table pracownik
(
    pracownik_id  serial primary key,
    nazwisko      text    not null,
    stanowisko    text    not null,
    manager_id    integer references pracownik (pracownik_id),
    staz          integer not null check (staz >= 0),
    wynagrodzenie numeric not null check (wynagrodzenie >= 1000.0),
    prowizja      numeric not null check (prowizja between 20 and 60),
    dzial_nr      integer not null references dzial (dzial_nr)
);

-- projekt
create table projekt
(
    projekt_id serial primary key,
    nazwa      text not null,
    start      date not null,
    koniec     date
);

-- N:M między pracownikami a projektami
create table pracownik_projekt
(
    pracownik_id integer not null references pracownik (pracownik_id),
    projekt_id   integer not null references projekt (projekt_id),
    primary key (pracownik_id, projekt_id)
);


-- WSTAWIANIE DO TABEL

-- dzial
insert into dzial (nazwa, lokal)
values ('Dział IT', 'Warszawa'),
       ('Dział HR', 'Kraków'),
       ('Dział Sprzedaży', 'Wrocław');

-- stopien
insert into stopien (min_wynagrodzenia, max_wynagrodzenia)
values (1000.0, 2000.0),
       (2000.1, 3000.0),
       (3000.1, 5000.0);

-- projekt
insert into projekt (nazwa, start, koniec)
values ('Projekt Alfa', '2025-01-01', '2025-06-01'),
       ('Projekt Babilon', '2024-12-15', null),
       ('Projekt SECRET', '2024-11-10', '2025-01-10');

-- pracownik
insert into pracownik (nazwisko, stanowisko, manager_id, staz, wynagrodzenie, prowizja, dzial_nr)
values ('Kowalski', 'Programista', null, 5, 3000.0, 40, 1),
       ('Nowak', 'Analityk', 1, 3, 2500.0, 25, 1),
       ('Wiśniewski', 'Specjalista HR', null, 10, 2000.0, 30, 2),
       ('Zielińska', 'Sprzedawca', 3, 2, 1200.0, 45, 3),
       ('Jankowski', 'Menadżer', null, 15, 4500.0, 55, 1)

-- pracownik-projekt
insert into pracownik_projekt (pracownik_id, projekt_id)
values (1, 1), -- Kowalski -> Alfa
       (2, 1), -- Nowak -> Alfa
       (3, 2), -- Wiśniewski -> Babilon
       (4, 3), -- Zielińska -> SECRET
       (5, 1), -- Jankowski -> Alfa
       (2, 2), -- Nowal -> Babilon
       (2, 3), -- Nowak -> SECRET
       (5, 2);

-- ZADANIE 2
-- 1
select s.stopien_id, count(p.pracownik_id) as ilosc_osob
from pracownik p
         join stopien s on p.wynagrodzenie between s.min_wynagrodzenia and s.max_wynagrodzenia
group by s.stopien_id
order by s.stopien_id;

-- 2
select p.pracownik_id,
       p.nazwisko,
       count(case when pr.koniec is not null then 1 end) as ilosc_projektow_ukonczonych,
       count(case when pr.koniec is null then 1 end)     as ilosc_projektow_nieukonczonych
from pracownik p
         left join pracownik_projekt pp on p.pracownik_id = pp.pracownik_id
         left join projekt pr on pp.projekt_id = pr.projekt_id
group by p.pracownik_id, p.nazwisko
order by p.pracownik_id;

-- 3
with projekty as ( select projekt_id, count(distinct pracownik_id) as liczba_pracownikow
                   from pracownik_projekt
                   group by projekt_id
                   having count(distinct pracownik_id) >= 2 )
select p.pracownik_id, p.nazwisko
from pracownik p
         join pracownik_projekt pp on p.pracownik_id = pp.pracownik_id
         join projekty on pp.projekt_id = projekty.projekt_id
group by p.pracownik_id, p.nazwisko
having count(pp.projekt_id) >= 2;

-- 4
with cte as ( select pr.nazwa, count(distinct pp.pracownik_id) as liczba_pracownikow
              from projekt pr
                       join pracownik_projekt pp on pr.projekt_id = pp.projekt_id
              group by pr.projekt_id, pr.nazwa )
select nazwa, liczba_pracownikow
from cte
where liczba_pracownikow = ( select max(liczba_pracownikow) from cte );


-- 5
select p.pracownik_id,
       p.nazwisko,
       -- projekt albo sie skonczyl, albo jeszcze trwa -> coalesce
       avg(coalesce((pr.koniec - pr.start), (current_date - pr.start))) as srednia_ilosc_dni_trwania_proj
from pracownik p
         join pracownik_projekt pp on p.pracownik_id = pp.pracownik_id
         join projekt pr on pp.projekt_id = pr.projekt_id
group by p.pracownik_id, p.nazwisko
order by srednia_ilosc_dni_trwania_proj desc;

-- 6
select pr.nazwa, sum(p.wynagrodzenie) as budzet
from projekt pr
         join pracownik_projekt pp on pr.projekt_id = pp.projekt_id
         join pracownik p on pp.pracownik_id = p.pracownik_id
group by pr.projekt_id, pr.nazwa
order by budzet desc;

-- 7
select count(*) as ilosc_projektow
from projekt
where koniec is null
  and (current_date - start) > 15;

-- 8
select s.stopien_id, count(distinct pp.projekt_id) as ilosc_projektow
from pracownik p
         join stopien s on p.wynagrodzenie between s.min_wynagrodzenia and s.max_wynagrodzenia
         join pracownik_projekt pp on p.pracownik_id = pp.pracownik_id
group by s.stopien_id
order by s.stopien_id;

-- 9
with ranking_proj as ( select pr.nazwa,
                              -- moze byc jeszcze niezakonczony
                              coalesce(pr.koniec - pr.start, current_date - pr.start)                             as dni_trwania,
                              rank() over (order by coalesce(pr.koniec - pr.start, current_date - pr.start) desc) as rnk
                       from projekt pr )
select nazwa, dni_trwania
from ranking_proj
where rnk = 1;

-- 10


-- END
drop schema lab13_JK cascade;