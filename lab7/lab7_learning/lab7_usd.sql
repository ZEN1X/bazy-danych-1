set search_path to lab;

create function lab.klienci_1(text) returns SETOF lab.customer as
$$
select *
from lab.customer
where town = $1;
$$ language SQL;


select lab.klienci_1('Bingham'); -- funkcja w obszarze argumentów
select *
from lab.klienci_1('Bingham'); -- funkcja w obszarze źródeł danych ( po FROM )
select lname(lab.klienci_1('Bingham')) as customer; --tylko jedna kolumna


create function lab.klienci_2(text) returns lab.customer as
$$
select *
from lab.customer
where town = $1;
$$ language SQL;


select lab.klienci_2('Bingham'); -- funkcja w obszarze argumentów
select *
from lab.klienci_2('Bingham'); -- funkcja w obszarze źródeł danych ( po FROM )
select lname(lab.klienci_2('Bingham')) as customer; --tylko jedna kolumna

-- pgsql
create or replace function lab.fun_1(int4) returns float8 as
$$ -- otwarcie bloku programu
declare -- blok deklaracji
    n              integer := 1;
    my_pi constant float8  = pi();
    r alias for $1; -- alias argumentów
begin
    return my_pi * r * r;
end;
$$ --zamkniecie bloku programu
    language plpgsql;
-- deklaracja języka
---------------------------------------------------------

create or replace function lab.fun_1(int4, int4) returns float8 as
$$ -- otwarcie bloku programu
declare -- blok deklaracji
    n integer := 1;
    r alias for $1; -- alias argumentów
begin
    return $2 * r;
end;
$$ --zamkniecie bloku programu
    language plpgsql; -- deklaracja języka


select lab.fun_1(10);
select lab.fun_1(10, 12);

-- return type of column
create or replace function lab.fun_2(int) returns text as
$$
declare
    id_k alias for $1;
    name customer.lname%TYPE; -- przypisanie typu atrybutu do zmiennej
begin
    select into name lname from customer where customer_id = id_k;
    return name;
end;
$$ language plpgsql;

select lab.fun_2(10);
select lab.fun_2(123);

-- return type of row
create or replace function lab.fun_3(int) returns text as
$$
declare
    id_k alias for $1;
    name customer%ROWTYPE; -- przypisanie typu rekordu  do zmiennej
begin
    select * into name from customer where customer_id = id_k;
    return name.fname || ' ' || name.lname;
end;
$$ language plpgsql;

select lab.fun_3(1);

-- record type
create or replace function lab.fun_4(int) returns text as
$$
declare
    id_k alias for $1;
    name RECORD; -- przypisanie typu RECORD
begin
    select fname, lname into name from customer where customer_id = id_k;
    return name.fname || ' ' || name.lname;
end;
$$ language 'plpgsql';

select lab.fun_4(1);