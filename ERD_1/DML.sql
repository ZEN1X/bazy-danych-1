-- schema
set search_path to transport;

-- linie
insert into linia (linia_numer)
values (194),
       (128),
       (503),
       (252);

-- przystanki
insert into przystanek (przystanek_nazwa, przystanek_lat, przystanek_lon)
values ('Kawiory', 50.065, 19.922),
       ('Kombinat', 50.070, 19.944),
       ('Plac Centralny', 50.074, 19.956),
       ('Krowodrza Gorka', 50.085, 19.931),
       ('Muzeum Narodowe', 50.057, 19.925),
       ('Rondo Mogilskie', 50.067, 19.950),
       ('Dworzec Glowny Zachod', 50.066, 19.944),
       ('Plac Inwalidow', 50.068, 19.929);

-- kalendarz
insert into kalendarz (poniedzialek, wtorek, sroda, czwartek, piatek, sobota, niedziela, data_poczatek, data_koniec)
values (true, true, true, true, true, false, false, '2024-01-01', '2024-12-31'), -- operacja_id 1 (dni robocze)
       (false, false, false, false, false, true, true, '2024-01-01', '2024-12-31'); -- operacja_id 2 (weekend)

-- podroze / kursy
insert into podroz (linia_numer, operacja_id, kierunek_nazwa, kierunek_id)
values
    -- 194
    (194, 1, 'Kombinat', false),
    (194, 1, 'Krowodrza Gorka', true),
    -- 128
    (128, 1, 'Muzeum Narodowe', false),
    (128, 1, 'Plac Centralny', true),
    -- 252
    (252, 1, 'Dworzec Glowny Zachod', false),
    (252, 1, 'Rondo Mogilskie', true);

-- odjazdy dla kursow
insert into odjazd (podroz_id, odjazd_czas, przystanek_id, odjazd_kolejnosc)
values
    -- 194 -> Kombinat
    (1, '07:00', 4, 1), -- Krowodrza Gorka
    (1, '07:10', 3, 2), -- Plac Centralny
    (1, '07:20', 2, 3), -- Kombinat

    -- 194 -> Krowodrza Gorka
    (2, '07:00', 2, 1), -- Kombinat
    (2, '07:15', 3, 2), -- Plac Centralny
    (2, '07:25', 4, 3), -- Krowodrza Gorka

    -- 128 -> Muzeum Narodowe
    (3, '08:00', 4, 1), -- Krowodrza Gorka
    (3, '08:15', 5, 2), -- Muzeum Narodowe

    -- 128 -> Plac Centralny
    (4, '09:00', 5, 1), -- Muzeum Narodowe
    (4, '09:20', 4, 2), -- Krowodrza Gorka
    (4, '09:35', 3, 3), -- Plac Centralny

    -- 252 -> Dworzec Glowny Zachod
    (5, '06:45', 6, 1), -- Rondo Mogilskie
    (5, '06:55', 7, 2), -- Dworzec Glowny Zachod

    -- 252 -> Rondo Mogilskie
    (6, '06:50', 7, 1), -- Dworzec Glowny Zachod
    (6, '07:00', 8, 2), -- Plac Inwalidow
    (6, '07:10', 6, 3); -- Rondo Mogilskie
