create schema lab;
set search_path to lab;

-- START WLASCIWEGO SKRYPTU

-- UTWORZENIE TABELI
create table if not exists ksiazka
(
    ksiazka_id        serial primary key, -- serial, wtedy nie musimy wpisywac recznie id
    autor_imie        text not null,
    autor_nazwisko    text not null,
    tytul             text not null,
    cena              numeric(10, 2) check (cena >= 100.0),
    rok_wydania       int check (rok_wydania between 1995 and 2020),
    ilosc_egzemplarzy int check (ilosc_egzemplarzy >= 0),
    dzial             text default null
);

create table if not exists czytelnik
(
    czytelnik_id serial primary key,
    imie         text not null,
    nazwisko     text not null
);

create table if not exists kara
(
    kara_id        integer primary key,
    opoznienie_min integer not null,
    opoznienie_max integer not null,
    constraint opoznienie_min_less_than_max check (opoznienie_min < opoznienie_max)
);

create table if not exists wypozyczenie
(
    wypozyczenie_id   serial primary key,
    czytelnik_id      integer not null,
    data_wypozyczenia date    not null,
    data_zwrotu       date
        constraint data_wypozyczenia_less_than_zwrotu check (data_zwrotu > data_wypozyczenia),
    constraint wypozyczenie_czytelnik_id_fk foreign key (czytelnik_id) references czytelnik (czytelnik_id) on delete cascade
);

create table if not exists wypozyczenie_ksiazki
(
    wypozyczenie_ksiazki_id serial primary key,
    wypozyczenie_id         integer not null,
    ksiazka_id              integer not null,
    constraint wypozyczenie_ksiazki_wypozyczenie_id_fk foreign key (wypozyczenie_id) references wypozyczenie (wypozyczenie_id) on delete cascade,
    constraint wypozyczenie_ksiazki_ksiazka_id_fk foreign key (ksiazka_id) references ksiazka (ksiazka_id)
);

-- WSTAWIENIE REKORDOW
insert into ksiazka (autor_imie, autor_nazwisko, tytul, cena, rok_wydania, ilosc_egzemplarzy, dzial)
values ('Henryk', 'Sienkiewicz', 'Quo Vadis', 120.99, 2001, 10, 'Literatura'),
       ('Adam', 'Mickiewicz', 'Pan Tadeusz', 150.49, 2005, 15, 'Epika'),
       ('Bolesław', 'Prus', 'Lalka', 130.75, 2010, 8, 'Literatura'),
       ('Stefan', 'Żeromski', 'Ludzie bezdomni', 110.30, 1998, 5, NULL),
       ('Juliusz', 'Słowacki', 'Kordian', 140.85, 2003, 20, 'Dramat'),
       ('Aleksander', 'Fredro', 'Zemsta', 160.99, 2012, 30, 'Dramat'),
       ('Henryk', 'Sienkiewicz', 'Krzyżacy', 170.25, 2000, 25, 'Historia'),
       ('Eliza', 'Orzeszkowa', 'Nad Niemnem', 105.60, 2015, 12, 'Literatura'),
       ('Adam', 'Mickiewicz', 'Dziady', 125.99, 2007, 18, 'Dramat'),
       ('Juliusz', 'Słowacki', 'Balladyna', 135.47, 1999, 22, 'Dramat'),
       ('Bolesław', 'Prus', 'Faraon', 145.89, 2011, 7, 'Historia'),
       ('Stefan', 'Żeromski', 'Syzyfowe prace', 155.20, 2004, 9, 'Literatura'),
       ('Henryk', 'Sienkiewicz', 'W pustyni i w puszczy', 165.75, 2008, 6, 'Przygoda'),
       ('Aleksander', 'Fredro', 'Śluby panieńskie', 175.99, 2013, 11, NULL),
       ('Eliza', 'Orzeszkowa', 'Gloria victis', 185.50, 2006, 4, 'Historia');

insert into czytelnik (imie, nazwisko)
values ('Jan', 'Kowalski'),
       ('Joanna', 'Toboła'),
       ('Maciej', 'Górski'),
       ('Julia', 'Gozda');

insert into kara (kara_id, opoznienie_min, opoznienie_max)
values (0, 0, 6),
       (1, 7, 10),
       (2, 11, 14),
       (3, 14, 21);

insert into wypozyczenie (czytelnik_id, data_wypozyczenia, data_zwrotu)
values (1, '2024-10-10', null),
       (1, '2020-08-12', '2020-08-15'),
       (2, '2024=10-13', null),
       (3, '2024-09-09', '2024-09-28'),
       (4, '2024-08-13', '2024-08-30');

insert into wypozyczenie_ksiazki (wypozyczenie_id, ksiazka_id)
values (1, 1),
       (1, 4),
       (2, 10),
       (3, 15),
       (4, 11),
       (4, 3),
       (4, 2),
       (5, 9);

-- #1
select czytelnik.nazwisko, wypozyczenie.wypozyczenie_id
from czytelnik
         join wypozyczenie on czytelnik.czytelnik_id = wypozyczenie.czytelnik_id
order by czytelnik.nazwisko;

-- #2
select ksiazka.tytul
from wypozyczenie
         join wypozyczenie_ksiazki on wypozyczenie.wypozyczenie_id = wypozyczenie_ksiazki.wypozyczenie_ksiazki_id
         join ksiazka on ksiazka.ksiazka_id = wypozyczenie.wypozyczenie_id
where wypozyczenie.wypozyczenie_id = 4;

-- #3
select w.wypozyczenie_id, c.nazwisko, k.kara_id
from wypozyczenie w
         join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
         join czytelnik c on w.czytelnik_id = c.czytelnik_id
         join kara k
              on (extract(day from age(now(), w.data_wypozyczenia)) between k.opoznienie_min and k.opoznienie_max)
where data_zwrotu is null;

-- #4
select ksiazka.tytul
from czytelnik
         join wypozyczenie on czytelnik.czytelnik_id = wypozyczenie.czytelnik_id
         join wypozyczenie_ksiazki on wypozyczenie.wypozyczenie_id = wypozyczenie_ksiazki.wypozyczenie_id
         join ksiazka on ksiazka.ksiazka_id = wypozyczenie_ksiazki.ksiazka_id
where czytelnik.imie = 'Maciej'
  and czytelnik.nazwisko = 'Górski';

-- #5
select distinct w.wypozyczenie_id, c.nazwisko
from wypozyczenie w
         join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
         join czytelnik c on w.czytelnik_id = c.czytelnik_id
         join kara k on kara_id = 0
where data_zwrotu is null
  and (now()::date - w.data_wypozyczenia) > k.opoznienie_max;