-- loop
do
$$
    declare
        i INTEGER := 0;
    begin
        loop
            exit when i > 9;
            i := i + 1;
            raise notice 'i: %',i;
        end loop;
    end;
$$;

-- while
do
$$
    declare
        i INTEGER := 0;
    begin
        while i < 10
            loop
                i := i + 1;
                raise notice 'i: %',i;
            end loop;
    end;
$$;

-- for
do
$$
    begin
        for i in 1..10
            loop
                raise notice 'i: %',i;
            end loop;
    end;
$$;

-- function
create or replace function lab.fun_6(p_pattern VARCHAR)
    returns TABLE
            (
                im  VARCHAR,
                naz VARCHAR
            )
as -- zwracany typ danych  tablica
$$
begin
    return query select fname, lname from lab.customer where lname like p_pattern;
end;
$$ language 'plpgsql';


select *
from lab.fun_6('H%');

-- function, but with a loop
create or replace function lab.fun_7(p_pattern VARCHAR)
    returns TABLE
            (
                im  VARCHAR,
                naz VARCHAR
            )
as
$$
declare
    var_r RECORD;
begin
    for var_r in ( select fname, lname from lab.customer where lname like p_pattern )
        loop
            im := var_r.fname;
            naz := upper(var_r.lname);
            return next; --dodaje rekord do zwracanej tabeli
        end loop;
end;
$$ language 'plpgsql';


select *
from lab.fun_7('H%');

-- execute using
create or replace function lab.fun_8(sort_type char(1), n INTEGER)
    returns TABLE
            (
                im   VARCHAR,
                naz  VARCHAR,
                opis VARCHAR
            )
as
$$
declare
    rec   RECORD;
    query text;
begin
    query := 'SELECT c.fname AS im, c.lname AS naz, i.description AS opis FROM lab.customer c JOIN lab.orderinfo oi  USING (customer_id)
                                                                  JOIN lab.orderline ol USING ( orderinfo_id )
                                                                  JOIN lab.item i Using (item_id) ';
    if sort_type = 'U' then
        query := query || 'ORDER BY naz, opis ';
    elsif sort_type = 'I' then
        query := query || 'ORDER BY opis, naz ';
    else
        raise exception 'Niepoprawny typ sortowania %', sort_type;
    end if;

    query := query || ' LIMIT $1';

    for rec in execute query using n
        loop
            raise notice '% - %', n, rec.naz;
            im := rec.im;
            naz := rec.naz;
            opis := rec.opis;
            return next;
        end loop;

end;
$$ language plpgsql;

select *
from lab.fun_8('U', 12);
select *
from lab.fun_8('I', 7);