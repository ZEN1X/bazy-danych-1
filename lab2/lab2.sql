create schema lab;
set search_path to lab;

-- START WLASCIWEGO SKRYPTU

-- UTWORZENIE TABELI
create table if not exists ksiazka (
	ksiazka_id serial primary key, -- serial, wtedy nie musimy wpisywac recznie id
	autor_imie text not null,
	autor_nazwisko text not null,
	tytul text not null,
	cena numeric(10,2) check (cena >= 100.0),
	rok_wydania int check (rok_wydania between 1995 and 2020),
	ilosc_egzemplarzy int check (ilosc_egzemplarzy >= 0),
	dzial text default null
);

-- WSTAWIENIE 15 REKORDOW
insert into ksiazka (autor_imie, autor_nazwisko, tytul, cena, rok_wydania, ilosc_egzemplarzy, dzial)
values
    ('Henryk', 'Sienkiewicz', 'Quo Vadis', 120.99, 2001, 10, 'Literatura'),
    ('Adam', 'Mickiewicz', 'Pan Tadeusz', 150.49, 2005, 15, 'Epika'),
    ('Bolesław', 'Prus', 'Lalka', 130.75, 2010, 8, 'Literatura'),
    ('Stefan', 'Żeromski', 'Ludzie bezdomni', 110.30, 1998, 5, NULL),
    ('Juliusz', 'Słowacki', 'Kordian', 140.85, 2003, 20, 'Dramat'),
    ('Aleksander', 'Fredro', 'Zemsta', 160.99, 2012, 30, 'Dramat'),
    ('Henryk', 'Sienkiewicz', 'Krzyżacy', 170.25, 2000, 25, 'Historia'),
    ('Eliza', 'Orzeszkowa', 'Nad Niemnem', 105.60, 2015, 12, 'Literatura'),
    ('Adam', 'Mickiewicz', 'Dziady', 125.99, 2007, 18, 'Dramat'),
    ('Juliusz', 'Słowacki', 'Balladyna', 135.47, 1999, 22, 'Dramat'),
    ('Bolesław', 'Prus', 'Faraon', 145.89, 2011, 7, 'Historia'),
    ('Stefan', 'Żeromski', 'Syzyfowe prace', 155.20, 2004, 9, 'Literatura'),
    ('Henryk', 'Sienkiewicz', 'W pustyni i w puszczy', 165.75, 2008, 6, 'Przygoda'),
    ('Aleksander', 'Fredro', 'Śluby panieńskie', 175.99, 2013, 11, NULL),
    ('Eliza', 'Orzeszkowa', 'Gloria victis', 185.50, 2006, 4, 'Historia');
   
-- WYPISANIE ALFABETYCZNEJ LISTY KSIAZEK
select dzial, autor_nazwisko, autor_imie, tytul from ksiazka
order by dzial, autor_nazwisko, autor_imie, tytul;

-- WYSZUKANIE KSIAZEK BEZ PRZYPISANEGO DZIALU
select * from ksiazka
where dzial is null;

-- WYPISANIE TYTULOW WSZYSTKICH KSIAZEK SIENKIEWICZA W BAZIE
select tytul from ksiazka
where autor_nazwisko = 'Sienkiewicz' and autor_imie = 'Henryk';

-- WYPISANIE POSORTOWANEJ PO NAZWISKU LISTY AUTOROW (UNIKALONA LISTA)
select distinct autor_imie as imie, autor_nazwisko as nazwisko from ksiazka
order by autor_nazwisko;

-- PRZECENIENIE KSIAZEK Z DZIALU LITERATURA O 10%
update ksiazka
set cena = cena * 0.9
where dzial = 'Literatura';
-- FAIL PRZY "NAD NIEMNEM" BO ZEJDZIE PONIZEJ 100ZL, SPRAWDZA DZIALANIE CONSTRAINTA

-- PRZECENIENIE KSIAZEK Z DZIALU LITERATURA O 10% Z SPRAWDZENIEM CONSTRAINTA NA CENE
update ksiazka
set cena = greatest(cena * 0.9, 100.0) -- JESLI CENA WYNIKOWA < 100, TO USTAW NA 100
where dzial = 'Literatura';

-- WYPISANIE TYTULU I NAZWISKA AUTORA KSIAZEK WYDANYCH W 2000 I 2010 ROKU
select tytul, autor_nazwisko as nazwisko from ksiazka
where rok_wydania in (2000, 2010);

-- USUNIECIE KSIAZEK WYDANYCH PRZED 2000 ROKIEM
delete from ksiazka
where rok_wydania < 2000;
