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

-- dodatkowe
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

-- BEGIN SKRYPT WLASCIWY
-- a

-- definicja tablicy_1
create table tablica_1
(
    wpis_id         serial,
    ksiazka_id      integer references ksiazka on delete cascade,
    granica         integer not null, --graniczna ilosc wypozyczen
    pozyczenie_plus integer not null, -- ilu  powyzej granicznej wartosci

    constraint tablica_1_pk primary key (wpis_id)
);

-- funkcja wyzwalajaca
create or replace function update_tablica1() returns trigger as
$$
declare
    n            int := tg_argv[0];
    curr_borrows int := 0;
begin
    select into curr_borrows count(ksiazka_id) from wypozyczenie_ksiazki wk where ksiazka_id = new.ksiazka_id;

    if curr_borrows > n then
        insert into tablica_1 (ksiazka_id, granica, pozyczenie_plus) values (new.ksiazka_id, n, curr_borrows - n);
    end if;
    return null;
end;
$$ language plpgsql;

-- wyzwalacz
create trigger trig_tablica1
    after insert
    on wypozyczenie_ksiazki
    for each row
execute function update_tablica1(5);

-- drop trigger trig_tablica1 on wypozyczenie_ksiazki;
-- tego mialo nie byc...

-- testowanie
insert into wypozyczenie_ksiazki (ksiazka_id, wypozyczenie_id)
values (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' )),
       (1, ( select wypozyczenie_id from wypozyczenie where czytelnik_id = 2 and data_pozyczenia = '2024-11-01' ));

-- c
-- funkcja  wyzwalajaca
create or replace function sprawdz_wypozyczenia() returns trigger as
$$
begin
    -- czy ma niezakonczone wypozyczenia?
    if exists ( select 1 from wypozyczenie where czytelnik_id = old.czytelnik_id and data_zwrotu is null ) then
        raise exception 'Nie można usunąć czytelnika, ponieważ posiada niezakończone wypożyczenia.';
    end if;

    -- nie ma trwajacych wypozyczen
    delete
    from wypozyczenie_ksiazki
    where wypozyczenie_id in ( select wypozyczenie_id from wypozyczenie where czytelnik_id = old.czytelnik_id );

    delete from wypozyczenie where czytelnik_id = old.czytelnik_id;

    return old;
end;
$$ language plpgsql;

-- trigger
create trigger trig_sprawdz_wypozyczenia
    before delete
    on czytelnik
    for each row
execute function sprawdz_wypozyczenia();

-- testowanie (niezakonczone)
delete
from czytelnik
where czytelnik_id = 3;

-- tstowanie (zakonczone)
delete
from czytelnik
where czytelnik_id = 5;

-- b
-- tutaj slowo komentarza, poniewaz nie za bardzo rozumiem, czy mnoznik to faktyczny mnoznik,
-- czy jest to zapis punktow procentowych
-- watpliwosci mam dlatego, ze w zadaniu jest napisane:
-- "po każdych 2 przedłużeniach wypożyczenia o 7 dni zwiększa mnożnik kary czytelnika o 2% - nie może być wyższa niż 10"
-- kiedy jednoczesnie mamy check mnoznik between 1.0 and 10.0

-- nastepnie:
-- czy liczymy tylko aktywne wypozyczenia (data_zwrotu is null),
-- czy liczymy tylko zakonczone wypozyczenia (data_zwrotu is not null)
-- czy oba typy wypozyczen?

-- kolejna watpliwosc to sposob liczenia dni
-- czy przedluzenie to takie wypozyczenie, dla ktorego:
-- {data_zwrotu | (dla niezwroconych) now()} - data_wypozyczenia - (select opoznienie_max from kara where kara_id = 0) >= 7?
-- czy jakos inaczej?

-- wobec tego wprowadzam szereg zalozen
-- mam nadzieje ze oddadza one ogolny zamysl tego podpunktu

-- 1) mnoznik to doslownie matematyczny mnoznik -> 1.0 oznacza zwykla kwote kary;
-- 1.1 oznacza kwote wynoszac kara.kwota * 1.1
-- 2) "nie przekracza 10" rozumiem jako 10%, tzn maksymalny mnoznik to 1.1
-- wobec tego zmieniam checka na between 1.0 and 1.1
-- 3) mnoznik jest liczony dla zakonczonych wypozyczen (trigger wyzwalany w momencie zakonczenia)
-- 4) kazde 2x przedluzenie o 7 dni (czyli lacznie 14 dni) ponad opoznienie_max dla kara_id = 0 daje wzrost mnoznika
-- 5) za jedno wypozyczenie mozemy otrzymac co najwyzej jednokrotny wzrost mnoznika
-- 5) mnoznik dla danego uzytkownika jest niemalejacy, jest to kara za nieterminowe zwroty

alter table czytelnik
    add column mnoznik REAL default 1.0 check (mnoznik between 1.0 and 1.1);

create or replace function update_multiplier_after_return() returns trigger as
$$
declare
    late_days           int;
    no_of_prolongations int;
    new_mult            real;
    id_reader           int := new.czytelnik_id; -- nie chce kolizji z czytelnik_id wiec po angielsku...
begin
    select new.data_zwrotu - new.data_pozyczenia - k.opoznienie_max into late_days from kara k where k.kara_id = 0;

    if late_days > 0 then
        no_of_prolongations := ceil(late_days / 7.0);

        if no_of_prolongations >= 2 then
            select c.mnoznik + 0.02 into new_mult from czytelnik c where c.czytelnik_id = id_reader;

            if new_mult > 1.1 then new_mult := 1.1; end if;

            update czytelnik set mnoznik = new_mult where czytelnik_id = id_reader;
        end if;
    end if;

    return null;
end;
$$ language plpgsql;

create trigger trig_update_mult_after_return
    after update of data_zwrotu
    on wypozyczenie
    for each row
    when (new.data_zwrotu is not null)
execute function update_multiplier_after_return();

-- testowanie
insert into wypozyczenie (czytelnik_id, data_pozyczenia)
values (2, current_date - 20);

update wypozyczenie
set data_zwrotu = current_date
where czytelnik_id = 2
  and data_pozyczenia = current_date - 20;

select mnoznik
from czytelnik
where czytelnik_id = 2;
