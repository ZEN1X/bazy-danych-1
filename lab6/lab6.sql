-- utworzenie schemy
create schema biblioteka;
set search_path to biblioteka;

-- tabela czytelnik
create table if not exists czytelnik
(
    czytelnik_id serial primary key,
    imie         varchar(32) not null,
    nazwisko     varchar(32) not null
);

-- tabela ksiazka
create table if not exists ksiazka
(
    ksiazka_id     serial primary key,
    tytul          varchar(32) not null,
    nazwisko_autor varchar(32) not null,
    rok_wydania    integer     not null
);

-- tabela wypozyczenie
create table if not exists wypozyczenie
(
    wypozyczenie_id serial primary key,
    czytelnik_id    integer not null references czytelnik (czytelnik_id) on delete cascade,
    data_pozyczenia date    not null,
    data_zwrotu     date
);

-- tabela pozyczenie ksiazki
create table if not exists wypozyczenie_ksiazki
(
    wypozyczenie_ksiazki_id serial primary key,
    ksiazka_id              integer not null references ksiazka (ksiazka_id) on delete cascade,
    wypozyczenie_id         integer not null references wypozyczenie (wypozyczenie_id) on delete cascade
);

-- tabela kara
create table if not exists kara
(
    kara_id        serial primary key,
    opoznienie_min integer not null,
    opoznienie_max integer not null,
    kwota          integer not null
);

-- Wstawianie danych do tabeli czytelnik
insert into czytelnik (imie, nazwisko)
values ('Jan', 'Kowalski'),
       ('Anna', 'Nowak'),
       ('Piotr', 'Zielinski'),
       ('Marek', 'Wozniak'),
       ('Zofia', 'Kaczmarek'),
       ('Tomasz', 'Lewandowski');

-- Wstawianie danych do tabeli ksiazka
insert into ksiazka (tytul, nazwisko_autor, rok_wydania)
values ('Wiedzmin', 'Sapkowski', 1993),
       ('Lalka', 'Prus', 1890),
       ('Krzyzacy', 'Sienkiewicz', 1900),
       ('Pan Tadeusz', 'Mickiewicz', 1834),
       ('Quo Vadis', 'Sienkiewicz', 1896),
       ('Ogniem i Mieczem', 'Sienkiewicz', 1884),
       ('Faraon', 'Prus', 1897),
       ('Ludzie Bezdomni', 'Zeromski', 1900);

-- Wstawianie danych do tabeli wypozyczenie
insert into wypozyczenie (czytelnik_id, data_pozyczenia, data_zwrotu)
values (1, '2024-10-01', '2024-10-15'),
       (2, '2024-09-20', '2024-10-05'),
       (3, '2024-10-10', null),
       (4, '2024-10-11', '2024-10-17'),
       (5, '2024-10-09', '2024-10-20'),
       (6, '2024-10-12', null),
       (1, '2024-10-15', null),
       (1, '2024-07-01', '2024-07-10'),
       (1, '2024-06-15', '2024-06-25'),
       (1, '2024-05-05', '2024-05-12');

-- Wstawianie danych do tabeli wypozyczenie_ksiazki (relacja m:n)
insert into wypozyczenie_ksiazki (ksiazka_id, wypozyczenie_id)
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 4),
       (6, 5),
       (7, 5),
       (8, 6),
       (1, 7),
       (3, 7),
       (2, 8),
       (3, 9),
       (4, 10);

-- Wstawianie danych do tabeli kara (w tym wpis 'bez kary')
insert into kara (kara_id, opoznienie_min, opoznienie_max, kwota)
values (0, 0, 6, 0);
insert into kara (opoznienie_min, opoznienie_max, kwota)
values (7, 14, 10);
insert into kara (opoznienie_min, opoznienie_max, kwota)
values (15, 9999, 50);

-- BEGIN SKRYPT WLASCIWY

-- a
select c.nazwisko,
       sum(
               case when wk.ksiazka_id = 1 then 1 else 0 end
       ) as "Wiedźmin",
       sum(
               case when wk.ksiazka_id = 2 then 1 else 0 end
       ) as "Lalka",
       sum(
               case when wk.ksiazka_id = 3 then 1 else 0 end
       ) as "Krzyżacy",
       sum(
               case when wk.ksiazka_id = 4 then 1 else 0 end
       ) as "Pan Tadeusz"
from czytelnik c
         join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
         join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
group by c.nazwisko;

-- b
with zestawienie (nazwisko_czytelnika, tytul_ksiazki, ilosc_wypozyczen) as (select c.nazwisko, k.tytul, count(*)
                                                                            from czytelnik c
                                                                                     join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
                                                                                     join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
                                                                                     join ksiazka k on wk.ksiazka_id = k.ksiazka_id
                                                                            group by c.nazwisko, c.czytelnik_id, k.tytul, k.ksiazka_id)
select *
from zestawienie
order by nazwisko_czytelnika;

-- przygotowanie c, d ,e
create schema jobsite;
set search_path to jobsite;

CREATE TABLE staff
(
    empno   INT,
    empname VARCHAR(20),
    mgrno   INT
);

INSERT INTO staff
VALUES (100, 'Kowalski', null),
       (101, 'Jasny', 100),
       (102, 'Ciemny', 101),
       (103, 'Szary', 102),
       (104, 'Bury', 101),
       (105, 'Cienki', 104),
       (106, 'Dlugi', 100),
       (107, 'Stary', 106),
       (108, 'Mlody', 106),
       (109, 'Bialy', 107),
       (110, 'Sztuka', 109),
       (111, 'Czarny', 110),
       (112, 'Nowy', 110),
       (113, 'Sredni', 110),
       (114, 'Jeden', 100),
       (115, 'Drugi', 114),
       (116, 'Ostatni', 115),
       (117, 'Lewy', 115);

-- c
select s.*, s2.empname as mgr_name
from staff s
         join staff s2 on s.mgrno = s2.empno
where s.mgrno is not null;

-- d
with recursive hier as (select *, 1 as lvl
                        from staff s
                        where mgrno is null

                        union all

                        select s2.*, lvl + 1
                        from staff s2
                                 join hier h on s2.mgrno = h.empno)
select h.empname, s3.empname, lvl
from hier h
         left join staff s3 on h.mgrno = s3.empno
order by lvl nulls first;

-- e
with recursive hier as (select *, 1 as lvl, '' as path
                        from staff s
                        where mgrno is null

                        union all

                        select s2.*, lvl + 1, path || '->' || h.empname
                        from staff s2
                                 join hier h on s2.mgrno = h.empno)
select h.empname, lvl, path
from hier h
         left join staff s3 on h.mgrno = s3.empno
order by lvl nulls first;