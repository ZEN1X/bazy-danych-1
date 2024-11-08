-- schema def
create schema if not exists transport;
set search_path to transport;

create table linia
(
    linia_numer int primary key -- np. 194
);

create table przystanek
(
    przystanek_id    serial primary key,
    przystanek_nazwa text not null, -- np. 'Kawiory'
    przystanek_lat   numeric(9, 6),
    przystanek_lon   numeric(9, 6)
);

create table kalendarz
(
    operacja_id   serial primary key,
    poniedzialek  boolean not null, -- opisuje, czy dany zestaw operacji / kursow odbywa sie w dany dzien tygodnia
    wtorek        boolean not null,
    sroda         boolean not null,
    czwartek      boolean not null,
    piatek        boolean not null,
    sobota        boolean not null,
    niedziela     boolean not null,
    data_poczatek date    not null, -- aka rozklad obowiazuje od ...
    data_koniec   date    not null, -- wlacznie, aka rozklad obowiazuje do ..
    check (data_koniec >= data_poczatek)
);

create table podroz
(
    linia_numer    int references linia on delete cascade on update cascade     not null,
    operacja_id    int references kalendarz on delete cascade on update cascade not null,
    podroz_id      serial primary key,
    kierunek_nazwa text                                                         not null, -- np. 'Kombinat'
    kierunek_id    boolean                                                      not null,
    /*
     kierunek_id oznacza "zwrot"
     np. linia 194 ma dwa kierunki, Kombinat i Krodowrza Gorka
     Kombinat wowczas ma kierunek_id 0, a Krowodrza Gorka ma kierunek_id 1
     troche bez sensu dla autobusow, ale gdybysmy robili metro, to mialoby to sens.
     wowczas mielibysmy kierunki, typu 0 - wschodni, 1 - zachodni
     */
    unique (linia_numer, kierunek_id, kierunek_nazwa)
);

create table odjazd
(
    podroz_id        int references podroz on delete cascade on update cascade     not null,
    odjazd_czas      time                                                          not null,
    przystanek_id    int references przystanek on delete cascade on update cascade not null,
    /*
     moze sie powtorzyc, gdyby linia robila pentelke, typu A -> B -> C (PETELKA) -> B -> D
     */
    odjazd_kolejnosc int                                                           not null,
    /*
     wyznacza kolejnosc przystanku w podrozy, dodatni integer, numeracja od 1
     */
    primary key (podroz_id, odjazd_kolejnosc)
);
