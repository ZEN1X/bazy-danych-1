-- schema def
create schema if not exists genealogia;
set search_path to genealogia;

-- DDL
create table Osoba
(
    id                integer generated always as identity primary key,
    imie              varchar(50) not null,
    nazwisko          varchar(50) not null,
    data_urodzenia    date        not null,
    miejsce_urodzenia varchar(100),
    data_smierci      date,
    matka             integer references Osoba (id) on delete restrict,
    ojciec            integer references Osoba (id) on delete restrict,
    -- albo mamy oboje rodzicow, albo zadnego
    check ( (matka is null and ojciec is null) or (matka is not null and ojciec is not null) )
);

create table Malzenstwo
(
    osoba1        integer not null references Osoba (id) on delete restrict,
    osoba2        integer not null references Osoba (id) on delete restrict,
    data_zawarcia date,
    -- dzieki temu nie mozemy miec dubli (osoba A z B i drugie malzenstwo B z A)
    check (osoba1 < osoba2),
    -- osoby w malzenstwie tworza klucz glowny malzenstwa
    primary key (osoba1, osoba2)
);

-- DML
-- Osoba
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia)
values ('Jan', 'Kowalski', '1900-01-01', 'Kraków');
-- id = 1, protoplasta
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia)
values ('Maria', 'Nowak', '1902-05-10', 'Warszawa');
-- id = 2, protoplasta

-- Malzenstwo Jana i Marii
insert into Malzenstwo (osoba1, osoba2, data_zawarcia)
values (1, 2, '1920-06-15');

-- dzieci Jana i Marii
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia, matka, ojciec)
values ('Adam', 'Kowalski', '1925-03-20', 'Kraków', 2, 1);
-- id = 3
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia, matka, ojciec)
values ('Anna', 'Kowalska', '1928-07-11', 'Kraków', 2, 1);
-- id = 4

-- kolejne pokolenie
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia, matka, ojciec)
values ('Piotr', 'Kowalski', '1950-12-01', 'Kraków', 4, 3);
-- id = 5

insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia)
values ('Ewa', 'Wiśniewska', '1952-10-10', 'Gdańsk');
-- id = 6, protoplasta

-- Malzenstwo Piotra i Ewy
insert into Malzenstwo (osoba1, osoba2, data_zawarcia)
values (5, 6, '1970-09-05');

-- dzieci Piotra i Ewy
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia, matka, ojciec)
values ('Marek', 'Kowalski', '1975-04-25', 'Gdańsk', 6, 5);
-- id = 7
insert into Osoba (imie, nazwisko, data_urodzenia, miejsce_urodzenia, matka, ojciec)
values ('Magdalena', 'Kowalska', '1978-11-30', 'Gdańsk', 6, 5);
-- id = 8

-- triggery
-- trigger uniemozliwiajacy usuniecie rodzica
create or replace function prevent_deleting_parents() returns trigger as
$$
begin
    if exists( select 1 from Osoba where matka = OLD.id or ojciec = OLD.id ) then
        raise exception 'Nie mozna usunac tej osoby: jest ona kogos rodzicem';
    end if;
    return OLD;
end;
$$ language plpgsql;

create trigger trg_prevent_deleting_parents
    before delete
    on Osoba
    for each row
execute function prevent_deleting_parents();

-- trigger uniemozliwiajacy usuniecie osoby bedacej w malzenstwie
create or replace function prevent_deleting_married_person() returns trigger as
$$
begin
    if exists( select 1 from Malzenstwo where osoba1 = OLD.id or osoba2 = OLD.id ) then
        raise exception 'Nie mozna usunac tej osoby: jest ona czescia malzenstwa';
    end if;
    return OLD;
end;
$$ language plpgsql;

create trigger trg_prevent_deleting_married_person
    before delete
    on Osoba
    for each row
execute function prevent_deleting_married_person();

-- DQL
-- informacje o danej osobie
select *
from Osoba
where id = 3;

-- informacje o rodzicach danej osoby
select p2.*
from Osoba p
         join Osoba p2 on p2.id in (p.matka, p.ojciec)
where p.id = 5;

-- czy dana osoba ma dzieci, jeśli tak wyświetla ich imiona
create or replace function get_children_list(id integer) returns text as
$$
declare
    imiona_dzieci text;
begin
    select case when count(*) = 0 then 'Brak dzieci' else string_agg(imie, ', ') end
    into imiona_dzieci
    from Osoba
    where matka = get_children_list.id
       or ojciec = get_children_list.id;

    return imiona_dzieci;
end;
$$ language plpgsql;

select get_children_list(1);
select get_children_list(6);

-- testy constraintow
-- proba usuniecia osoby, ktora jest rodzicem
delete
from Osoba
where id = 1;

-- proba usuniecia osoby, ktora jest w malzenstwie
delete
from Osoba
where id = 2;
