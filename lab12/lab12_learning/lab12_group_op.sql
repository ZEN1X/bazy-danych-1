set search_path to analytic;

-- 1
select count(*)
from sample;

-- 2
select distinct region, province
from sample
order by region;

-- 3: liczba sprzedaży i suma sprzedaży dla każdego regionu
select s.region, count(*), sum(s.sales)
from sample s
group by s.region
order by s.region;

-- 5: liczba sprzedaży i suma sprzedaży dla każdej prowincji w regionie
select s.region, s.province, count(*), sum(s.sales)
from sample s
group by s.region, s.province
order by s.region, s.province;

-- 6: liczba sprzedaży i suma sprzedaży dla regionu i prowincji, regionu, prowincji i całkowita
select s.region, s.province, count(*), sum(s.sales)
from sample s
group by s.region, s.province
union
select s.region, null, count(*), sum(s.sales)
from sample s
group by s.region
union
select null, s.province, count(*), sum(s.sales)
from sample s
group by s.province
union
select null, null, count(*), sum(s.sales)
from sample s
order by region, province;

-- 6b
select region, province, count(*), sum(sales)
from sample s
group by grouping sets ( (region, province), (region), (province), () );

-- 6c
select region, province, count(*), sum(sales)
from sample s
group by rollup (region, province)
order by region, province;

-- 6d
select region, province, count(*), sum(sales)
from sample s
group by cube (region, province)
order by region, province;

-- 7: Informację o wartościach zagregowanych sprzedaży dla każdego miesiąca plus rok
select extract(month from ship_date) as m, extract(year from ship_date) as y, count(*), sum(sales) as s
from sample
group by rollup ( extract(month from ship_date), extract(year from ship_date))
order by 2, 1;

-- 9: informację o wartościach zagregowanych sprzedaży dla każdego każdego miesiąca plus rok,
-- każdego miesiąca, każdego roku
select extract(month from ship_date) as m, extract(year from ship_date) as y, sum(sales) as s
from sample
group by cube ( extract(month from ship_date), extract(year from ship_date) )
order by 2, 1;
--tworzymy tymczasową tabelę z poprzedniego zapytania
create temp table temp1 as
select extract(month from ship_date) as m, extract(year from ship_date) as y, sum(sales) as s
from sample
group by cube ( extract(month from ship_date), extract(year from ship_date) )
order by 2, 1;

-- 10: utworzenie tabeli przestawnej
create extension if not exists tablefunc;
select *
from crosstab('select y::text, m::text, s from temp1') as fr (Rok text, Styczen numeric, Luty numeric, Marzec numeric,
                                                              Kwiecien numeric, Maj numeric, Czerwiec numeric,
                                                              Lipiec numeric, Sierpien numeric, Wrzesien numeric,
                                                              Pazdziernik numeric, Listopad numeric, Grudzien numeric,
                                                              Razem numeric);