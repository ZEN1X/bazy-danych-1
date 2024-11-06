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
select k.tytul, count(*)
from ksiazka k
         left join wypozyczenie_ksiazki wk using (ksiazka_id)
         join wypozyczenie w using (wypozyczenie_id)
         join czytelnik c using (czytelnik_id)
group by k.ksiazka_id, k.tytul
order by k.tytul;

-- b wypozyczenie - cale "zamowienie", nie pojedyncza ksiazka z zamowienia
select c.imie, c.nazwisko, count(*)
from czytelnik c
         left join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
group by c.imie, c.nazwisko, c.czytelnik_id
order by c.nazwisko, c.imie;

-- c
select avg(data_zwrotu - data_pozyczenia) as srednia_dni_wypozyczenia
from wypozyczenie w
where data_zwrotu is not null;

-- d
select max(data_zwrotu - data_pozyczenia) - min(data_zwrotu - data_pozyczenia) as diff
from wypozyczenie w
where data_zwrotu is not null;

-- e
select (data_zwrotu - data_pozyczenia) as dni, count(*)
from wypozyczenie w
         join kara k on kara_id = 0
where data_zwrotu is not null
  and (data_zwrotu - data_pozyczenia) > k.opoznienie_max
group by (data_zwrotu - data_pozyczenia);

-- f
select k.tytul, k.nazwisko_autor, count(*) as liczba_wypozyczen
from ksiazka k
         join wypozyczenie_ksiazki wk on k.ksiazka_id = wk.ksiazka_id
group by k.ksiazka_id, k.tytul, k.nazwisko_autor
order by liczba_wypozyczen desc
limit 1;

-- g
select c.imie, c.nazwisko, count(*) as ilosc_kar
from wypozyczenie w
         join czytelnik c on w.czytelnik_id = c.czytelnik_id
         join kara k on k.kara_id = 0
where w.data_zwrotu is not null
  and (data_zwrotu - data_pozyczenia) > k.opoznienie_max
group by c.czytelnik_id, c.imie, c.nazwisko
order by c.nazwisko, c.imie;

-- h
select c.imie, c.nazwisko, count(*) as liczba_wypozyczen
from wypozyczenie w
         join czytelnik c on c.czytelnik_id = w.czytelnik_id
         join kara k on k.kara_id = 0
where w.data_zwrotu is not null
  and (data_zwrotu - data_pozyczenia) > k.opoznienie_max
group by c.czytelnik_id, c.imie, c.nazwisko
having count(*) > 2
order by c.nazwisko, c.imie;

-- i
select k.tytul, k.nazwisko_autor, count(distinct w.czytelnik_id) as liczba_czytelnikow
from wypozyczenie_ksiazki wk
         join ksiazka k on wk.ksiazka_id = k.ksiazka_id
         join wypozyczenie w on wk.wypozyczenie_id = w.wypozyczenie_id
group by k.ksiazka_id, k.tytul, k.nazwisko_autor
having count(*) > 2
order by k.tytul, k.nazwisko_autor;

-- j
select kara_id, count(*)
from wypozyczenie w,
     kara k
where data_zwrotu is not null
  and ((w.data_zwrotu - w.data_pozyczenia) >= k.opoznienie_min and
       (w.data_zwrotu - w.data_pozyczenia) <= k.opoznienie_max)
group by kara_id
order by count(*) desc;
