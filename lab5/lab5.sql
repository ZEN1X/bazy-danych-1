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
select MAX(count_per_czytelnik) -
       MIN(count_per_czytelnik) as roznica
from (select w.czytelnik_id,
             COUNT(*) as count_per_czytelnik
      from wypozyczenie_ksiazki wk
               join wypozyczenie w on wk.wypozyczenie_id = w.wypozyczenie_id
      group by w.czytelnik_id) as czytelnik_counts;


-- b
select k.tytul
from wypozyczenie_ksiazki wk
         join ksiazka k on wk.ksiazka_id = k.ksiazka_id
where wk.wypozyczenie_id in (select wk2.wypozyczenie_id
                             from wypozyczenie_ksiazki wk2
                                      join ksiazka k2 on wk2.ksiazka_id = k2.ksiazka_id
                             where k2.tytul = 'Pan Tadeusz')
  and k.tytul != 'Pan Tadeusz';


-- c
select distinct c.imie, c.nazwisko
from czytelnik c
         join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
         join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
where wk.ksiazka_id in (select wk2.ksiazka_id
                        from wypozyczenie w2
                                 join wypozyczenie_ksiazki wk2 on w2.wypozyczenie_id = wk2.wypozyczenie_id
                                 join czytelnik c2 on w2.czytelnik_id = c2.czytelnik_id
                        where c2.imie = 'Jan'
                          and c2.nazwisko = 'Kowalski')
  AND c.imie != 'Jan'
  and c.nazwisko != 'Kowalski';

-- d
select t.tytul, t.liczba_czytelnikow
from (select k.tytul, count(distinct w.czytelnik_id) as liczba_czytelnikow
      from ksiazka k
               join wypozyczenie_ksiazki wk on k.ksiazka_id = wk.ksiazka_id
               join wypozyczenie w on wk.wypozyczenie_id = w.wypozyczenie_id
      group by k.tytul) as t
order by t.liczba_czytelnikow desc
limit 1;


-- e
select c.imie, c.nazwisko, MAX(liczba_ksiazek) as ilosc
from czytelnik c
         join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
         join (select wypozyczenie_id, COUNT(*) as liczba_ksiazek
               from wypozyczenie_ksiazki
               group by wypozyczenie_id) wk_counts on w.wypozyczenie_id = wk_counts.wypozyczenie_id
group by c.czytelnik_id, c.imie, c.nazwisko
order by ilosc desc
limit 1;

-- h
select c.imie, c.nazwisko, MAX(przetrzymanie) as najdluzsze_przetrzymanie
from czytelnik c
         join (select w.czytelnik_id, (w.data_zwrotu - w.data_pozyczenia) AS przetrzymanie
               from wypozyczenie w
                        join kara k on k.kara_id = 0
               where w.data_zwrotu is not null
                 and (w.data_zwrotu - w.data_pozyczenia) > k.opoznienie_max) as overdue_data
              on c.czytelnik_id = overdue_data.czytelnik_id
group by c.czytelnik_id, c.imie, c.nazwisko;

-- i
select c.imie, c.nazwisko
from czytelnik c
where c.czytelnik_id not in (select w.czytelnik_id
                             from wypozyczenie w
                                      join kara k on k.kara_id = 0
                             where w.data_zwrotu is not null
                               and (w.data_zwrotu - w.data_pozyczenia) > k.opoznienie_max);

