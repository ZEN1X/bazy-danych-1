set search_path to lab;

create or replace function lab.fun_5(id_k int) returns text as
$$
declare
    rec_klient customer%ROWTYPE;
begin
    select into rec_klient * from customer where customer_id = id_k;
    if not FOUND then raise exception 'Klienta % nie ma w bazie', id_k; end if;
    return rec_klient.fname || ' ' || rec_klient.lname;
end;
$$ language 'plpgsql';


select lab.fun_5(1);
select lab.fun_5(21);