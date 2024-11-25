create schema lab8;
set search_path to lab8;

-- a - Monitorowanie zmian w bazie danych.

-- zapis do tabeli operacji dokonanych w bazie danych

-- Tabela person
create table person
(
    id         serial primary key,
    groups     char(2),
    first_name varchar(40) not null,
    last_name  varchar(40) not null
);

--Tabela audit zapis operacji w bazie danych
create table audit
(
    table_name varchar(15) not null,
    operation  varchar,
    time_at    timestamp   not null default now(),
    userid     name        not null default session_user
);

-------------------------------------------------------------------
-- Funkcja  zapisujaca operacje do tabeli audit
create or replace function audit_log() returns TRIGGER
    language plpgsql as
$$
begin

    insert into audit (table_name, operation) values (TG_RELNAME, TG_OP);

    return NEW;
end;
$$;
-------------------------------------------------------------------

-- Wyzwalacz monitorujacy działania na tabeli person

create trigger person_audit
    after insert or update or delete
    on person
    for each row
execute procedure audit_log();


-------------------------------------------------------------------
-- Sprawdzenie poprawnosci opracowanego wyzwalacza

insert into person
values (1, 'A', 'Adam', 'Abacki');

select *
from person;
select *
from audit;

-- zapis do tabeli starych danych po dokonaniu zmiany

--Tabela przechowujaca stare dane (nazwisko)

create table change
(
    id         serial primary key,
    person_id  int4         not null,
    last_name  varchar(40)  not null,
    changed_on timestamp(6) not null
);

-------------------------------------------------------------------

--Funkcja archiwizujaca nazwisko jeżeli zostało zmieniona

create or replace function log_last_name_changes() returns trigger as
$$
begin
    if NEW.last_name <> OLD.last_name then
        insert into change(person_id, last_name, changed_on) values (OLD.id, OLD.last_name, now());
    end if;
    return NEW;
end
$$ language 'plpgsql';

-------------------------------------------------------------------

--Wyzwalacz monitorujacy działania na tabeli person

create trigger last_name_changes
    before update
    on person
    for each row
execute procedure log_last_name_changes();

-------------------------------------------------------------------
-- Sprawdzenie poprawności opracowanego wyzwalacza

insert into person
values (2, 'B', 'Jan', 'Janecki');
insert into person
values (3, 'A', 'Anna', 'Adamska');

update person
set last_name = 'Kowalski'
where id = 2;

select *
from person;
select *
from change;

-- Testowanie poprawności wprowadzonych danych.

-- Funkcja sprawdzajaca poprawnosc wprowadzonych danych
create or replace function valid_data() returns TRIGGER
    language plpgsql as
$$
begin
    if length(NEW.last_name) = 0 then
        raise exception 'Nazwisko nie moze byc puste.';
        return null; --Anulujemy
    end if;

    return NEW; --Akceputacja modyfikacji
end;
$$;

-------------------------------------------------------------------
-- Wyzwalacz monitorujacy poprawnosc danych dla tabeli person

create trigger person_valid
    after insert or update
    on person
    for each row
execute procedure valid_data();

-------------------------------------------------------------------
-- Sprawdzenie poprawnosci opracowanego wyzwalacza

insert into person
values (12, 'AA', '', '');

drop trigger person_valid on person;

-- Modyfikacja wprowadzanych danych do tabeli.

-- Funkcja normalizujaca wprowadzone dane do bazy danych

create or replace function norm_data() returns TRIGGER as
$$
begin
    if NEW.last_name is not null then
        NEW.last_name := lower(NEW.last_name);
        NEW.last_name := initcap(NEW.last_name);
    end if;
    return NEW;
end;
$$ language 'plpgsql';

-------------------------------------------------------------------
-- Przypisanie wyzwalacza do tabeli person

create trigger person_norm
    before insert or update
    on person
    for each row
execute procedure norm_data();
-------------------------------------------------------------------

insert into person
values (6, 'bb', 'Adam', 'babacki'),
       (7, 'bb', 'Marek', 'cabacki'),
       (8, 'cc', 'Adam', 'kabacki'),
       (9, 'dd', 'Teresa', 'Zak');

-- Testowanie danych na podstawie informacji z innych tabel.

create table person_group
(
    name varchar(15),
    nc   int
); --nazwa grupy; maksymalna ilosc osob w  grupie

insert into person_group
values ('aa', 2),
       ('bb', 3),
       ('cc', 4);

-------------------------------------------------------------------

create or replace function group_count() returns TRIGGER as
$$
begin
    if exists( select 1
               from person_group
               where name = New.groups and nc > ( select count(*) from person where groups like New.groups ) ) then
        -- rekord zostanie dodany lub zaktualizowany
        return NEW;
    else
        raise notice 'Za duzo osob w grupie %.',New.groups;
        return null;
    end if;
end;
$$ language 'plpgsql';

-------------------------------------------------------------------

create trigger person_test_insert
    before insert or update
    on person
    for each row
execute procedure group_count();

-------------------------------------------------------------------

insert into person
values (21, 'aa', 'Adam', 'Babacki'),
       (22, 'cc', 'Marek', 'Cabacki'),
       (23, 'aa', 'Adam', 'Babacki'),
       (24, 'a', 'Teresa', 'Dadacka');

-------------------------------------------------------------------

drop trigger person_test_insert on person;

-- Wprowadzanie danych do tabel powiązanych.

create table person_data
(
    id      int,
    city    varchar(30),
    email   varchar(30),
    telefon varchar(15)
);

alter table person_data
    add primary key (id);
insert into person_data (id)
select id
from person;
alter table person_data
    add foreign key (id) references person (id);

-------------------------------------------------------------------
create or replace function insert_data() returns TRIGGER as
$$
begin
    insert into person_data (id) values (New.id);
    return NEW;
end;
$$ language 'plpgsql';

-------------------------------------------------------------------

create trigger person_insert
    after insert
    on person
    for each row
execute procedure insert_data();


insert into person
values (69, 'bb', 'Zygmunt', 'Bielecki');

select *
from person;
select *
from person_data;
select *
from audit;

-- Wprowadzanie danych do tabel powiązanych - tabela asocjacyjna.
set search_path to lab;

create function customer_magazine_trigger() returns TRIGGER as
$$
declare
    customer_record record;
    item_record     record;
    cust            integer;
    max_orderinfo   integer;
    itemid          integer;
begin
    select count(*) into cust from customer;
    select * into customer_record from customer;
    select * into item_record from item where substr(upper(description), 1, 7) = substr(upper(new.description), 1, 7);

    for item_record in select * from item where substr(upper(description), 1, 7) = substr(upper(new.description), 1, 7)
        loop
            itemid := item_record.item_id;
        end loop;
    select max(orderinfo_id) into max_orderinfo from orderinfo;
    if (cust > 0 and substr(upper(new.description), 1, 7) = upper(tg_argv[0])) then
        raise notice 'Trzeba wysylac magazyn do % klientow' ,cust;
        for customer_record in select * from customer
            loop
                max_orderinfo = max_orderinfo + 1;
                --zapis do tabeli orderinfo
                insert into orderinfo (orderinfo_id, customer_id, date_placed, shipping)
                values (max_orderinfo, customer_record.customer_id, now(), 0.0);
                --zapis do tabeli asocjacyjnej
                insert into orderline(orderinfo_id, item_id, quantity) values (max_orderinfo, itemid, 1);
            end loop;
    else
        if (cust = 0) then raise notice 'Brak klientow do ktorych moznaby wyslac magazyn'; end if;
    end if;
    return new;
end;
$$ language 'plpgsql';

-------------------------------------------------------------------

create trigger trig_customer
    after insert
    on item
    for each row
execute procedure customer_magazine_trigger(Magazyn); --argument wywołania dostepny przez tablicę tg_argv


insert into item (description, cost_price, sell_price)
values ('Magazyn - Luty', 0.1, 0.0)
