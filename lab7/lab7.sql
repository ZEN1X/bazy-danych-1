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
create table tablica_1
(
    wpis_id         serial,
    ksiazka_id      integer references ksiazka on delete cascade,
    granica         integer not null, --graniczna ilosc wypozyczen
    pozyczenie_plus integer not null, -- ilu  powyzej granicznej wartosci

    constraint tablica_1_pk primary key (wpis_id)
);

create or replace function fun1(n int) returns int as
$$
declare
    occur int := 0;
    rec   record;
begin
    for rec in select k.ksiazka_id, count(k.ksiazka_id) as liczba_wyp
               from ksiazka k
                        join wypozyczenie_ksiazki wk on k.ksiazka_id = wk.ksiazka_id
                        join wypozyczenie w on wk.wypozyczenie_id = w.wypozyczenie_id
               group by k.ksiazka_id
        loop
            if rec.liczba_wyp > n then occur := occur + 1; end if;
            insert into tablica_1 (ksiazka_id, granica, pozyczenie_plus) values (rec.ksiazka_id, n, rec.liczba_wyp - n);
        end loop;
    return occur;
end;
$$ language plpgsql;

select *
from fun1(1);

-- b
--tabela tablica_2
create table tablica_2
(
    czytelnik_id integer,
    ilosc        integer, --ilość niezakończonych wypozyczeń
    data         date,    --aktualna data
    wiadomosc    text,
    constraint tablica_2_pk primary key (czytelnik_id)
);

create or replace function fun2() returns int as
$$
declare
    occur int := 0;
    rec   record;
begin
    for rec in select c.czytelnik_id, count(*) as liczba_akt_wyp
               from czytelnik c
                        join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
               where data_zwrotu is null
               group by c.czytelnik_id
        loop
            if rec.liczba_akt_wyp = 2 then
                occur := occur + 1;
                insert into tablica_2 (czytelnik_id, ilosc, data, wiadomosc)
                values (rec.czytelnik_id, rec.liczba_akt_wyp, current_date, 'pierwsze ostrzezenie');
            elseif rec.liczba_akt_wyp > 2 then
                occur := occur + 1;
                insert into tablica_2 (czytelnik_id, ilosc, data, wiadomosc)
                values (rec.czytelnik_id, rec.liczba_akt_wyp, current_date, 'zakaz pozyczania');
            end if;
        end loop;
    return occur;
end;
$$ language plpgsql;

-- trzeba dodac wartosci, zeby mialo sens
insert into wypozyczenie (czytelnik_id, data_pozyczenia, data_zwrotu)
values (2, '2024-11-01', null),
       (2, '2024-11-05', null),
       (3, '2024-11-02', null),
       (3, '2024-11-06', null),
       (3, '2024-11-10', null),
       (4, '2024-10-18', null),
       (4, '2024-10-20', null),
       (4, '2024-11-08', null);

insert into wypozyczenie_ksiazki (ksiazka_id, wypozyczenie_id)
values (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (2, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-05' )),
       (3, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 3 and data_pozyczenia = '2024-11-02' )),
       (4, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 3 and data_pozyczenia = '2024-11-06' )),
       (5, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 3 and data_pozyczenia = '2024-11-10' )),
       (6, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 4 and data_pozyczenia = '2024-10-18' )),
       (7, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 4 and data_pozyczenia = '2024-10-20' )),
       (8, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 4 and data_pozyczenia = '2024-11-08' ));


select *
from fun2();

-- c
create or replace function rownanie_1(a float, b float, c float)
    returns table
            (
                equ_solve text
            )
as
$$
declare
    delta          float;
    x1             float;
    x2             float;
    real_part      float;
    imaginary_part float;
begin
    delta := b * b - 4 * a * c;

    raise notice 'INFORMACJA: DELTA = %', delta;

    if delta > 0 then
        raise notice 'INFORMACJA: Rozwiazanie posiada dwa rzeczywiste pierwiastki';
        x1 := (-b + sqrt(delta)) / (2 * a);
        x2 := (-b - sqrt(delta)) / (2 * a);
        raise notice 'INFORMACJA: x1 = %', x1;
        raise notice 'INFORMACJA: x2 = %', x2;

        return query select format('(x1 = %s ),(x2 = %s)', x1, x2) as equ_solve;

    elsif delta = 0 then
        raise notice 'INFORMACJA: Rozwiazanie posiada jeden rzeczywisty pierwiastek';
        x1 := -b / (2 * a);
        raise notice 'INFORMACJA: x1 = x2 = %', x1;

        return query select format('(x1 = x2 = %s)', x1) as equ_solve;

    else
        raise notice 'INFORMACJA: Rozwiazanie w dziedzinie liczb zespolonych';
        real_part := -b / (2 * a);
        imaginary_part := sqrt(-delta) / (2 * a);
        raise notice 'INFORMACJA: x1 = % + %si', real_part, imaginary_part;
        raise notice 'INFORMACJA: x2 = % - %si', real_part, imaginary_part;

        return query select format('(x1 = %s + %si ),(x2 = %s - %si)', real_part, imaginary_part, real_part,
                                   imaginary_part) as equ_solve;
    end if;
end;
$$ language plpgsql;

select rownanie_1(1, 10, 1);
select rownanie_1(10, 5, 1);
