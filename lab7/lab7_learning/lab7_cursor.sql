create or replace function lab.fun_9(stext text) returns text as
$$
declare
    records    TEXT default '';
    rec_klient RECORD;
    cur_klient cursor for select *
                          from lab.customer ;
    id         INTEGER;
begin
    id := 0;
    open cur_klient; -- otwarcie kursora
    loop
        fetch cur_klient into rec_klient; -- pobranie rekordu z kursora do zmiennej rec_klient
        exit when not FOUND;
        -- zamkniecie jak brak dalszych rekordow
        -- tworzenie rekordu wynikowego
        if rec_klient.lname like stext and id != 0 then
            records := records || ',' || rec_klient.fname || ':' || rec_klient.lname;
        end if;
        if rec_klient.lname like stext and id = 0 then
            records := rec_klient.fname || ':' || rec_klient.lname;
            id := 1;
        end if;

    end loop;
    close cur_klient; -- zamkniecie kursora
    return records;
end;
$$ language plpgsql;

select *
from lab.fun_9('Stones');
select *
from lab.fun_9('Marks');
