set search_path to biblioteka;

-- wyszuka wszystkie ksiazki, potem kursorem po idkach
select distinct k.ksiazka_id
from wypozyczenie w
         join wypozyczenie_ksiazki wk using (wypozyczenie_id)
         join ksiazka k using (ksiazka_id)
where w.czytelnik_id = 1;

-- teraz wydobywuje tytul do jsona
select k.tytul
from ksiazka k
where k.ksiazka_id = 2;

-- a teraz w kolejnym kursorze mam imiona i nazwiska czytelnikow
select distinct c.imie, c.nazwisko
from wypozyczenie_ksiazki wk
         join ksiazka k using (ksiazka_id)
         join wypozyczenie w using (wypozyczenie_id)
         join czytelnik c using (czytelnik_id)
where wk.ksiazka_id = 2;

select distinct c.imie, c.nazwisko from wypozyczenie_ksiazki wk join ksiazka k using (ksiazka_id) join wypozyczenie w using (wypozyczenie_id) join czytelnik c using (czytelnik_id) where wk.ksiazka_id = 2;
