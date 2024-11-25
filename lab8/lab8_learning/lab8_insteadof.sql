set search_path to lab;

create view miasta as
select town, count(*)
from customer
group by town;

delete
from miasta m
where m.count = 1; -- nie dziala


create or replace function view_miasta() returns TRIGGER as
$$
begin
    if TG_OP = 'INSERT' then
        raise notice 'Nie mozna wstawic nowego miasta';
        return null;
    elsif TG_OP = 'UPDATE' then
        update customer set town = NEW.town where town like OLD.town;
        return NEW;
    elsif TG_OP = 'DELETE' then
        delete from customer where town = OLD.town;
        return null;
    end if;
    return NEW;
end;
$$ language 'plpgsql';

--Tworzymy wyzwalacz

create trigger miasta_instead
    instead of insert or update or delete
    on miasta
    for each row
execute procedure view_miasta();

delete
from miasta
where town like 'Nicetown';

update miasta
set town = 'Krakow'
where town like 'Histon';