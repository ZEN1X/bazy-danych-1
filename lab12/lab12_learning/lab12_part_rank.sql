set search_path to analytic;

-- 1: Wyznaczyć kwotę sprzedaży w każdym rejonie i prowincji,
-- z udziałem procentowym każdej kwoty dla prowincji w kwocie dla danego regionu
with cte as ( select region, province, sum(sales) as suma from sample group by region, province )
select region,
       province,
       suma,
       sum(suma) over ( partition by region )                     as suma_region,
       round(100 * suma / (sum(suma) over (partition by region))) as "udzial_%"
from cte;

select region, province, sum(sales) as suma
from sample
group by region, province
order by 1, 2;

-- 2: Numeracja rekordów
with cte as ( select region, province, sum(sales) as suma from sample group by region, province )
select row_number() over (order by region)                        as nr,
       region,
       province,
       suma,
       sum(suma) over ( partition by region ),
       round(100 * suma / (sum(suma) over (partition by region))) as "udzial_%"
from cte;

-- 3: Numerację wszystkich rekordów oraz rekordów w ramach każdego regionu
with cte as ( select region, province, sum(sales) as suma from sample group by region, province )
select row_number() over (order by region)                        as nr,
       row_number() over (partition by region order by region )   as nl,
       region,
       province,
       suma,
       sum(suma) over ( partition by region ),
       round(100 * suma / (sum(suma) over (partition by region))) as "udzial_%"
from cte;

-- 4: Analizy kategorii i podkategorii sprzedanych artykułów
select product_category, product_sub_category, count(*)
from sample
group by product_category, product_sub_category
order by 1, 2;

with cte as ( select product_category, product_sub_category, count(*)
              from sample
              group by product_category, product_sub_category
              order by 1, 2 )
select product_category, product_sub_category, rank() over ( order by product_category )
from cte;

with cte as ( select product_category, product_sub_category, count(*)
              from sample
              group by product_category, product_sub_category
              order by 1, 2 )
select product_category, product_sub_category, dense_rank() over ( order by product_category )
from cte;

-- 5: Najlepiej sprzedające się produkty w danej podkategorii produktów
select product_sub_category, sum(sales) as suma, rank() over ( order by sum(sales) desc ) as pozycja
from sample
group by product_sub_category
order by suma desc, product_sub_category;

with cte as ( select product_category, product_sub_category, sum(sales) suma
              from sample
              group by product_category, product_sub_category
              order by 1, 2 )
select product_category,
       product_sub_category,
       dense_rank() over ( order by product_category ),
       rank() over (order by product_category),
       row_number() over ( partition by product_category) as row_number_cat,
       row_number() over ()                               as row_number_all,
       suma,
       sum(suma) over ( partition by product_category)
from cte;

-- 6: Najlepsi klienci pod względem dokonanych zakupów
select customer_name, sum(sales) as suma, rank() over ( order by sum(sales) desc ) as ranking
from sample
group by customer_name
order by suma desc, customer_name;

-- 7: Procentowy ranking z bieżącego rekordu w stosunku do zbioru wartości w partycji
-- wyznacza jaki procent rekordów w partycji poprzedza w rankingu bieżący rekord (tzw.percentyl).
-- Wyznacza wartość w przedziale (0,1>. Do wyliczonej wartości jest dodawany bieżący rekord.
select product_sub_category, sum(sales) as suma, cume_dist() over ( order by sum(sales) desc ) as cume_dist
from sample
group by product_sub_category
order by suma desc, product_sub_category;

-- Do wyliczonej wartości nie jest dodawany bieżący rekord.
select product_sub_category, sum(sales) as suma, percent_rank() over ( order by sum(sales) desc ) as perc_rank
from sample
group by product_sub_category
order by suma desc, product_sub_category;