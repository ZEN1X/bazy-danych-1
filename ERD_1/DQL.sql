-- schema
set search_path to transport;

-- dla wybranego przystanku -> znaleźć linie zatrzymujące się na tym przystanku
select distinct po.linia_numer
from odjazd o
         join podroz po using (podroz_id)
         join przystanek p using (przystanek_id)
where p.przystanek_nazwa like 'Krowodrza%'
order by po.linia_numer;

-- jesli chcemy jednak dowiedziec sie tez, w jakim kierunku jada te linie, to wystarczy dodac po.kierunek_nazwa
select distinct po.linia_numer, po.kierunek_nazwa
from odjazd o
         join podroz po using (podroz_id)
         join przystanek p using (przystanek_id)
where p.przystanek_nazwa like 'Krowodrza%'
order by po.linia_numer;

-- dla wybranego przystanku i linii -> znaleźć czasy odjazdu
select po.linia_numer, po.kierunek_nazwa, p.przystanek_nazwa, o.odjazd_czas
from odjazd o
         join przystanek p using (przystanek_id)
         join podroz po using (podroz_id)
where p.przystanek_nazwa = 'Plac Centralny'
  and po.linia_numer = 194;

-- dla wybranej linii -> znaleźć przystanki i czasy odjazdu z przystanków
select po.linia_numer, po.kierunek_nazwa, o.odjazd_czas, p.przystanek_nazwa
from podroz po
         join odjazd o using (podroz_id)
         join przystanek p using (przystanek_id)
where po.linia_numer = 128
order by po.kierunek_id, o.odjazd_kolejnosc; -- pierw dany kierunek kursu, potem po kolei przystanki
