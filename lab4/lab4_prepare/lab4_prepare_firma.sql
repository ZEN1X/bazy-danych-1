-- schema
create schema firma;
set search_path to firma;

-- tabela dzial
create table if not exists dzial
(
    dzial_id serial primary key,
    nazwa    varchar(32) not null,
    lokal    varchar(32) not null
);

-- tabela pracownik
create table if not exists pracownik
(
    pracownik_id  serial primary key,
    wynagrodzenie integer     not null,
    prowizja      integer     not null,
    staz          integer     not null,
    manager_id    integer     not null,
    stanowisko    varchar(32) not null,
    nazwisko      varchar(32) not null,
    dzial_id      integer     not null references dzial (dzial_id)
);

-- tabela projekt
create table if not exists projekt
(
    projekt_id serial primary key,
    nazwa      varchar(32) not null,
    start      date        not null,
    koniec     date
);

-- tabela pracownik_projekt
create table if not exists pracownik_projekt
(
    projekt_id   integer not null references projekt (projekt_id),
    pracownik_id integer not null references pracownik (pracownik_id)
);

-- tabela stopien
create table if not exists stopien
(
    stopien_id        serial  not null primary key,
    min_wynagrodzenie integer not null,
    max_wynagrodzenie integer not null
);

-- Wstawianie danych do tabeli dzial
insert into dzial (nazwa, lokal)
values ('HR', 'Warszawa'),
       ('IT', 'Krakow'),
       ('Marketing', 'Gdansk'),
       ('Finanse', 'Wroclaw'),
       ('Sprzedaż', 'Warszawa'),      -- new department in Warszawa
       ('Obsługa klienta', 'Gdansk'), -- new department in Gdansk
       ('Logistyka', 'Krakow');
-- new department in Krakow

-- Wstawianie danych do tabeli pracownik (pracownicy z różnymi stopniami wynagrodzenia)
insert into pracownik (wynagrodzenie, prowizja, staz, manager_id, stanowisko, nazwisko, dzial_id)
values (4500, 400, 2, 1, 'Specjalista', 'Kowalski', 1),      -- HR (Stopień 1)
       (5500, 500, 3, 2, 'Starszy Specjalista', 'Nowak', 2), -- IT (Stopień 1)
       (6200, 600, 4, 3, 'Specjalista', 'Wiśniewski', 3),    -- Marketing (Stopień 2)
       (7800, 700, 5, 4, 'Manager', 'Zieliński', 4),         -- Finanse (Stopień 2)
       (8800, 800, 6, 5, 'Kierownik', 'Lewandowski', 5),     -- Sprzedaż (Stopień 3)
       (5200, 550, 3, 1, 'Specjalista', 'Wójcik', 6),        -- Obsługa klienta (Stopień 1)
       (4700, 450, 2, 2, 'Asystent', 'Krawczyk', 7),         -- Logistyka (Stopień 1)
       (9500, 900, 7, 4, 'Dyrektor', 'Kozłowski', 1),        -- HR (Stopień 3)
       (7000, 650, 4, 5, 'Analityk', 'Zawadzki', 4),         -- Finanse (Stopień 2)
       (5300, 500, 3, 2, 'Starszy Specjalista', 'Piotrowski', 3); -- Marketing (Stopień 1)

-- Wstawianie danych do tabeli projekt
insert into projekt (nazwa, start, koniec)
values ('Projekt A', '2024-01-01', '2024-12-31'),
       ('Projekt B', '2024-03-01', '2024-09-30'),
       ('Projekt C', '2024-05-01', null), -- ongoing project
       ('Projekt D', '2024-07-01', '2024-12-15'); -- new project

-- Wstawianie danych do tabeli pracownik_projekt (relacja m:n)
insert into pracownik_projekt (projekt_id, pracownik_id)
values (1, 1), -- Kowalski (HR) in Projekt A
       (2, 2), -- Nowak (IT) in Projekt B
       (3, 3), -- Wiśniewski (Marketing) in Projekt C
       (1, 4), -- Zieliński (Finanse) in Projekt A
       (2, 5), -- Lewandowski (Sprzedaż) in Projekt B
       (4, 6), -- Wójcik (Obsługa klienta) in Projekt D
       (4, 7), -- Krawczyk (Logistyka) in Projekt D
       (3, 8), -- Kozłowski (HR) in Projekt C
       (1, 9), -- Zawadzki (Finanse) in Projekt A
       (2, 10); -- Piotrowski (Marketing) in Projekt B

-- Wstawianie danych do tabeli stopien (różne zakresy wynagrodzeń)
insert into stopien (min_wynagrodzenie, max_wynagrodzenie)
values (4000, 6000), -- Stopień 1
       (6001, 8000), -- Stopień 2
       (8001, 10000); -- Stopień 3
