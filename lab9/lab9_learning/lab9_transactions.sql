create schema lab9;
set search_path to lab9;

create table osoba
(
    pesel    char(11) primary key,
    imie     char(20),
    nazwisko char(30),
    adres_m  char(30)
);

select cast(txid_current() as text);


begin;
insert into osoba
values ('11111113', 'Tom', 'nazwisko', 'miasto1');
select *
from osoba;
select cast(txid_current() as text);
select xmin, xmax, *
from osoba;
rollback; --odrzucenie
select *
from osoba;


begin;
insert into osoba
values ('11111111', 'Ala', 'nazwisko1', 'miasto1');
select *
from osoba;
commit; --zatwierdzenie
select *
from osoba;
select xmin, xmax, *
from osoba;

begin;
delete
from osoba o;
select xmin, xmax, *
from osoba o;
rollback;

-- TESTOWANIE POPRAWNOSCI DANYCH

create schema test;
set search_path to test;
create table person
(
    id         serial primary key,
    groups     char(2),
    first_name varchar(40) not null,
    last_name  varchar(40) not null
);

-- Funkcja sprawdzajaca poprawnosc wprowadzonych danych
create or replace function valid_data_test() returns TRIGGER
    language plpgsql as
$$
declare
    var record;
begin
    select * into var from person;--w tabeli bedzie nie wiecej niz jeden rekord
    raise notice 'przed sprawdzeniem dlugosci nazwiska zawartosc tablicy person %', var;
    if length(NEW.last_name) = 0 then
        raise exception 'Nazwisko nie moze byc puste.';--ROLLBACK
    end if;
    select * into var from person;
    raise notice 'po sprawdzeniu dlugosci nazwiska zawartosc tablicy person %', var;
    return NEW;
end; --COMMIT
$$;

-------------------------------------------------------------------
-- Wyzwalacz monitorujący poprawność danych dla tabeli person

create trigger person_valid
    after insert or update
    on person
    for each row
execute procedure valid_data_test();

-------------------------------------------------------------------
-- Sprawdzenie poprawnosci opracowanego wyzwalacza

insert into person
values (12, 'AA', '', '');
select *
from person;

insert into person
values (12, 'AA', '', 'nazwisko');
select *
from person;

drop trigger person_valid on person;