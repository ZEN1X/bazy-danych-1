drop schema if exists druzyny cascade;

-- schema def
create schema if not exists druzyny;
set search_path to druzyny;

-- Tabela DRUZYNA
create table druzyna
(
    druzyna_id serial primary key,
    nazwa      varchar(50) not null,
    dyscyplina varchar(50) not null
);

-- Tabela GRACZ
create table gracz
(
    gracz_id           serial primary key,
    imie               varchar(50) not null,
    nazwisko           varchar(50) not null,
    druzyna_id         int         not null references druzyna (druzyna_id),
    ma_czerwona_kartke boolean default false
);

-- Tabela MECZ
create table mecz
(
    mecz_id              serial primary key,
    mecz_data            date not null,
    gospodarz_druzyna_id int  not null references druzyna (druzyna_id),
    gosc_druzyna_id      int  not null references druzyna (druzyna_id),
    gospodarz_gole       int default 0,
    gosc_gole            int default 0,
    gospodarz_punkty     int default 0,
    gosc_punkty          int default 0
);

-- Tabela GRACZ_MECZ_STATYSTYKA
create table gracz_mecz_statystyka
(
    gracz_mecz_statystyka_id serial primary key,
    mecz_id                  int not null references mecz (mecz_id),
    gracz_id                 int not null references gracz (gracz_id),
    strzelone_gole           int     default 0,
    czerwona_kartka_w_meczu  boolean default false
);

-- Funkcja do obliczania punktów na podstawie wyniku
create or replace function oblicz_punkty() returns trigger as
$$
begin
    if new.gospodarz_gole > new.gosc_gole then
        new.gospodarz_punkty := 3;
        new.gosc_punkty := 0;
    elsif new.gospodarz_gole < new.gosc_gole then
        new.gospodarz_punkty := 0;
        new.gosc_punkty := 3;
    else
        new.gospodarz_punkty := 1;
        new.gosc_punkty := 1;
    end if;
    return new;
end;
$$ language plpgsql;

-- Trigger do automatycznego obliczania punktów
create trigger trg_oblicz_punkty
    before insert or update
    on mecz
    for each row
execute function oblicz_punkty();

-- Funkcja aktualizująca status czerwonej kartki
create or replace function aktualizuj_czerwona_kartke() returns trigger as
$$
begin
    if new.czerwona_kartka_w_meczu then
        update gracz set ma_czerwona_kartke = true where gracz_id = new.gracz_id;
    end if;
    return new;
end;
$$ language plpgsql;

-- Trigger do aktualizacji czerwonej kartki po meczu
create trigger trg_aktualizuj_czerwona_kartke
    after insert
    on gracz_mecz_statystyka
    for each row
execute function aktualizuj_czerwona_kartke();

-- Funkcja zdejmująca czerwoną kartkę po jednym meczu pauzy
create or replace function zdejmij_czerwona_kartke() returns trigger as
$$
declare
    zawodnicy_z_kartka record;
begin
    -- Przejdź przez graczy z czerwoną kartką i sprawdź, czy opuścili 1 mecz
    for zawodnicy_z_kartka in select gracz_id
                              from gracz
                              where ma_czerwona_kartke = true
                                and druzyna_id in (new.gospodarz_druzyna_id, new.gosc_druzyna_id)
        loop
            -- Sprawdź, czy gracz był pominięty w poprzednim meczu
            if not exists ( select 1
                            from gracz_mecz_statystyka
                            where mecz_id = new.mecz_id and gracz_id = zawodnicy_z_kartka.gracz_id ) then
                -- Zdejmij czerwoną kartkę
                update gracz set ma_czerwona_kartke = false where gracz_id = zawodnicy_z_kartka.gracz_id;
            end if;
        end loop;

    return new;
end;
$$ language plpgsql;

-- Trigger do zdejmowania czerwonej kartki
create trigger trg_zdejmij_czerwona_kartke
    after insert or update
    on mecz
    for each row
execute function zdejmij_czerwona_kartke();

-- Funkcja sprawdzająca liczbę zawodników w drużynie podczas meczu
create or replace function sprawdz_liczbe_graczy() returns trigger as
$$
declare
    liczba_gospodarzy int;
    liczba_gosci      int;
begin
    -- Policzenie zawodników drużyny gospodarzy
    select count(*)
    into liczba_gospodarzy
    from gracz_mecz_statystyka gms
             join mecz m on m.mecz_id = gms.mecz_id
    where gms.mecz_id = new.mecz_id
      and gms.gracz_id in ( select gracz_id from gracz where druzyna_id = m.gospodarz_druzyna_id );

    -- Policzenie zawodników drużyny gości
    select count(*)
    into liczba_gosci
    from gracz_mecz_statystyka gms
             join mecz m on m.mecz_id = gms.mecz_id
    where gms.mecz_id = new.mecz_id
      and gms.gracz_id in ( select gracz_id from gracz where druzyna_id = m.gosc_druzyna_id );

    -- Sprawdzenie, czy drużyny mają więcej niż 11 zawodników
    if liczba_gospodarzy > 11 or liczba_gosci > 11 then
        raise exception 'Liczba zawodników przekracza limit 11 w meczu: %', new.mecz_id;
    end if;

    return new;
end;
$$ language plpgsql;

-- Trigger do sprawdzania liczby zawodników w meczu
create trigger trg_sprawdz_liczbe_graczy
    before insert or update
    on gracz_mecz_statystyka
    for each row
execute function sprawdz_liczbe_graczy();

-- Wstawianie przykładowych danych
insert into druzyna (nazwa, dyscyplina)
values ('FC Barcelona', 'piłka nożna'),
       ('Real Madryt', 'piłka nożna'),
       ('Manchester United', 'piłka nożna'),
       ('Bayern Monachium', 'piłka nożna');

insert into gracz (imie, nazwisko, druzyna_id)
values ('Robert', 'Lewandowski', 1),
       ('Marc', 'Ter Stegen', 1),
       ('Karim', 'Benzema', 2),
       ('Luka', 'Modrić', 2),
       ('Marcus', 'Rashford', 3),
       ('Harry', 'Maguire', 3),
       ('Thomas', 'Müller', 4),
       ('Manuel', 'Neuer', 4);

insert into mecz (mecz_data, gospodarz_druzyna_id, gosc_druzyna_id, gospodarz_gole, gosc_gole)
values ('2024-05-10', 1, 2, 3, 1),
       ('2024-05-15', 3, 4, 2, 2),
       ('2024-05-20', 2, 3, 0, 1);

insert into gracz_mecz_statystyka (mecz_id, gracz_id, strzelone_gole, czerwona_kartka_w_meczu)
values (1, 1, 2, true),  -- Lewandowski
       (1, 2, 0, false), -- Ter Stegen
       (1, 3, 1, false), -- Benzema
       (1, 4, 0, false), -- Modrić
       (2, 5, 2, false), -- Rashford
       (2, 6, 0, false), -- Maguire
       (2, 7, 2, false), -- Müller
       (2, 8, 0, false), -- Neuer
       (3, 3, 0, false), -- Benzema
       (3, 4, 0, false), -- Modrić
       (3, 5, 1, false), -- Rashford
       (3, 6, 0, false);
-- Maguire

-- DQL
-- 1. Informacje o meczu
select m.mecz_id,
       to_char(m.mecz_data, 'YYYY-MM-DD')                              as data_meczu,
       gospodarze.nazwa                                                as druzyna_gospodarz,
       m.gospodarz_gole,
       m.gospodarz_punkty,
       goscie.nazwa                                                    as druzyna_gosc,
       m.gosc_gole,
       m.gosc_punkty,
       coalesce(string_agg(concat(g.imie, ' ', g.nazwisko), ', '), '') as gracze_z_czerwona_kartka
from mecz m
         join druzyna gospodarze on m.gospodarz_druzyna_id = gospodarze.druzyna_id
         join druzyna goscie on m.gosc_druzyna_id = goscie.druzyna_id
         left join gracz_mecz_statystyka gms on gms.mecz_id = m.mecz_id and gms.czerwona_kartka_w_meczu = true
         left join gracz g on g.gracz_id = gms.gracz_id
group by m.mecz_id, gospodarze.nazwa, goscie.nazwa, m.mecz_data, m.gospodarz_gole, m.gospodarz_punkty, m.gosc_gole,
         m.gosc_punkty
order by m.mecz_data;


-- 2. Informacje o piłkarzu
select g.gracz_id,
       concat(g.imie, ' ', g.nazwisko)                          as zawodnik,
       d.nazwa                                                  as druzyna,
       coalesce(sum(gms.strzelone_gole), 0)                     as liczba_bramek,
       case when g.ma_czerwona_kartke then 'TAK' else 'NIE' end as ma_czerwona_kartke
from gracz g
         join druzyna d on g.druzyna_id = d.druzyna_id
         left join gracz_mecz_statystyka gms on g.gracz_id = gms.gracz_id
group by g.gracz_id, g.imie, g.nazwisko, d.nazwa, g.ma_czerwona_kartke
order by liczba_bramek desc;

-- 3. Tabela drużyn
with sumy as ( select d.druzyna_id,
                      d.nazwa                                                                                    as druzyna,
                      coalesce(sum(case when m.gospodarz_druzyna_id = d.druzyna_id then m.gospodarz_punkty else 0 end),
                               0) +
                      coalesce(sum(case when m.gosc_druzyna_id = d.druzyna_id then m.gosc_punkty else 0 end),
                               0)                                                                                as suma_punktow,
                      coalesce(sum(case when m.gospodarz_druzyna_id = d.druzyna_id then m.gospodarz_gole else 0 end),
                               0) +
                      coalesce(sum(case when m.gosc_druzyna_id = d.druzyna_id then m.gosc_gole else 0 end),
                               0)                                                                                as suma_bramek
               from druzyna d
                        left join mecz m on d.druzyna_id in (m.gospodarz_druzyna_id, m.gosc_druzyna_id)
               group by d.druzyna_id, d.nazwa )
select row_number() over (order by suma_punktow desc, suma_bramek desc) as nr,
       druzyna_id,
       druzyna,
       suma_punktow,
       suma_bramek
from sumy
order by suma_punktow desc, suma_bramek desc;
