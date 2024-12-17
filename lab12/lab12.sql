-- schema
create schema if not exists lab12;
set search_path to lab12;

-- tablica
create table TRANSAKCJE
(
    ID_TRANSAKCJI decimal(12, 0) not null,
    NR_KONTA      varchar(30)    not null,
    DATA          date           not null,
    KWOTA         decimal(10, 2) not null,
    TYP           varchar(10),
    KATEGORIA     varchar(20)
);
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10000, '11-11111111', to_date('03.01.1997', 'DD.MM.YYYY'), 1500, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10010, '11-11111111', to_date('12.01.1997', 'DD.MM.YYYY'), -100, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10020, '11-11111111', to_date('02.02.1997', 'DD.MM.YYYY'), 750, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10030, '11-11111111', to_date('22.05.1998', 'DD.MM.YYYY'), -150, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10040, '11-11111111', to_date('04.11.1999', 'DD.MM.YYYY'), 1800, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10050, '11-11111111', to_date('02.12.1999', 'DD.MM.YYYY'), 1800, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10060, '11-11111111', to_date('24.12.1999', 'DD.MM.YYYY'), -120.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10070, '11-11111111', to_date('24.12.1999', 'DD.MM.YYYY'), -300, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10080, '11-11111111', to_date('19.01.2000', 'DD.MM.YYYY'), -150, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10090, '11-11111111', to_date('03.05.2000', 'DD.MM.YYYY'), 900, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10100, '11-11111111', to_date('16.07.2001', 'DD.MM.YYYY'), -600, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10110, '11-11111111', to_date('24.07.2001', 'DD.MM.YYYY'), -150, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10120, '11-11111111', to_date('03.09.2001', 'DD.MM.YYYY'), 1400, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10130, '11-11111111', to_date('29.09.2001', 'DD.MM.YYYY'), -250, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10140, '11-11111111', to_date('03.12.2001', 'DD.MM.YYYY'), 1650, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10150, '11-11111111', to_date('05.01.2002', 'DD.MM.YYYY'), -500, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10001, '22-22222222', to_date('03.04.1998', 'DD.MM.YYYY'), 1650, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10011, '22-22222222', to_date('12.01.1997', 'DD.MM.YYYY'), 1000, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10021, '22-22222222', to_date('02.09.1997', 'DD.MM.YYYY'), 830, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10031, '22-22222222', to_date('22.03.1998', 'DD.MM.YYYY'), -170, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10041, '22-22222222', to_date('04.05.2001', 'DD.MM.YYYY'), 1980, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10051, '22-22222222', to_date('02.07.2001', 'DD.MM.YYYY'), 2090, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10061, '22-22222222', to_date('24.10.1999', 'DD.MM.YYYY'), -130.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10071, '22-22222222', to_date('02.10.1999', 'DD.MM.YYYY'), -330, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10081, '22-22222222', to_date('19.12.1999', 'DD.MM.YYYY'), -110, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10091, '22-22222222', to_date('03.02.2001', 'DD.MM.YYYY'), 990, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10101, '22-22222222', to_date('16.01.2001', 'DD.MM.YYYY'), -660, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10111, '22-22222222', to_date('24.05.2001', 'DD.MM.YYYY'), -170, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10121, '22-22222222', to_date('03.11.2002', 'DD.MM.YYYY'), 1540, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10131, '22-22222222', to_date('29.06.2001', 'DD.MM.YYYY'), -280, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10141, '22-22222222', to_date('03.04.2003', 'DD.MM.YYYY'), 1820, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10151, '22-22222222', to_date('05.08.2001', 'DD.MM.YYYY'), -550, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10002, '33-33333333', to_date('03.10.1995', 'DD.MM.YYYY'), 1350, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10012, '33-33333333', to_date('12.02.1997', 'DD.MM.YYYY'), -90, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10022, '33-33333333', to_date('02.07.1996', 'DD.MM.YYYY'), 670, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10032, '33-33333333', to_date('22.07.1998', 'DD.MM.YYYY'), -130, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10042, '33-33333333', to_date('04.05.1998', 'DD.MM.YYYY'), 1620, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10052, '33-33333333', to_date('02.05.1998', 'DD.MM.YYYY'), 1710, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10062, '33-33333333', to_date('24.02.2000', 'DD.MM.YYYY'), -110.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10072, '33-33333333', to_date('02.04.2000', 'DD.MM.YYYY'), -270, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10082, '33-33333333', to_date('19.02.2000', 'DD.MM.YYYY'), -90, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10092, '33-33333333', to_date('03.08.1999', 'DD.MM.YYYY'), 810, 'WPŁATA', 'UMOWA O DZIEŁO');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10102, '33-33333333', to_date('16.01.2002', 'DD.MM.YYYY'), -540, 'WYPŁATA', 'RACHUNEK ZA PRAD');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10112, '33-33333333', to_date('24.09.2001', 'DD.MM.YYYY'), -130, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10122, '33-33333333', to_date('03.07.2000', 'DD.MM.YYYY'), 1260, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10132, '33-33333333', to_date('29.12.2001', 'DD.MM.YYYY'), -220, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10142, '33-33333333', to_date('03.08.2000', 'DD.MM.YYYY'), 1480, 'WPŁATA', 'PENSJA');
insert into TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA)
values (10152, '33-33333333', to_date('05.06.2002', 'DD.MM.YYYY'), -450, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');

-- BEGIN ZADANIE
-- zad. 1
select NR_KONTA, TYP, KATEGORIA, sum(KWOTA)
from transakcje T
group by rollup (NR_KONTA, TYP, KATEGORIA)
order by 1, 2, 3 nulls last;

-- zad. 2
select NR_KONTA, TYP, sum(kWOTA)
from transakcje T
group by grouping sets ( (NR_KONTA, TYP), (NR_KONTA) )
order by 1;

-- zad. 3
select NR_KONTA, TYP, avg(KWOTA)
from transakcje T
group by cube (NR_KONTA, TYP)
order by 1, 2 nulls last;

-- zad. 4
with cte as ( select KATEGORIA, DATA, KWOTA
              from transakcje T
              where NR_KONTA = '11-11111111'
              order by KATEGORIA, KWOTA desc )
select rank() over (partition by KATEGORIA order by KWOTA desc),
       dense_rank() over (partition by KATEGORIA order by KWOTA desc),
       KATEGORIA,
       DATA,
       KWOTA
from cte;

-- zad. 5
with cte as ( select KWOTA, DATA, NR_KONTA, rank() over (order by KWOTA desc) as ranking
              from transakcje T
              where TYP = 'WPŁATA' )
select KWOTA, DATA, NR_KONTA
from cte
where ranking <= 3;
