-- Tworzenie perspektywy z tabeli item, ukrywającej pole cost_price i przedstawiającej pole sell_price w formacie zmiennoprzecinkowym.

create view lab.item_price as
(
select i.item_id, i.description, cast(i.sell_price as float)
from lab.item i
    );

select *
from lab.item_price ip;

-- Tworzenie perspektywy z tabeli customer, tworzącej nowe pole.
create view lab.dane as
(
select c.fname || ' ' || c.lname as name,
       c.town
from lab.customer c
    );

select *
from lab.dane d;

-- Perspektywa, która przedstawia zestawienie item_id, description i barcode.
create view lab.all_items as
(
select i.item_id, i.description, b.barcode_ean
from lab.item i
         join lab.barcode b using (item_id)
order by item_id
    );

select *
from lab.all_items ai;

-- Widoki modifikowalne
CREATE VIEW lab.personel AS
SELECT fname, lname, zipcode, town
FROM lab.customer;

INSERT INTO lab.personel (fname, lname, zipcode, town)
VALUES ('Harry', 'Potter', 'WT3 8GM', 'Welltown');

-- CHECK OPTION
CREATE VIEW lab.women AS
SELECT title, fname, lname, zipcode, town
FROM lab.customer
WHERE title <> 'Mr';

CREATE VIEW lab.women_check AS
SELECT title, fname, lname, zipcode, town
FROM lab.customer
WHERE title <> 'Mr'
WITH CHECK OPTION;

INSERT INTO lab.women(title, fname, lname, zipcode, town)
VALUES ('Mr', 'Tom', 'Sawyer', 'WT3 8GM', 'Welltown');
INSERT INTO lab.women_check(title, fname, lname, zipcode, town)
VALUES ('Mr', 'Tom', 'Sawyer', 'WT3 8GM', 'Welltown');
INSERT INTO lab.women_check(title, fname, lname, zipcode, town)
VALUES ('Mrs', 'Tom', 'Sawyer', 'WT3 8GM', 'Welltown');

-- 2
CREATE VIEW lab.women_town AS
SELECT title, lname, zipcode, town
FROM lab.women
WHERE town LIKE 'W%'
WITH LOCAL CHECK OPTION;

INSERT INTO lab.women_town(title, lname, zipcode, town)
VALUES ('Mr', 'Sawyer', 'WT3 8GM', 'Welltown'); --złamanie ograniczenia widoku women

INSERT INTO lab.women_town(title, lname, zipcode, town)
VALUES ('Mr', 'Sawyer', 'WT3 8GM', 'Nicetown'); --złamanie ograniczenia widoku women_town

-- 3
CREATE VIEW lab.women_town_check AS
SELECT title, lname, zipcode, town
FROM lab.women
WHERE town LIKE 'W%'
WITH CASCADED CHECK OPTION;

INSERT INTO lab.women_town_check(title, lname, zipcode, town)
VALUES ('Miss', 'Poppins', 'WT3 8GM', 'Nicetown'); --złamanie ograniczenia widoku women_town_check

INSERT INTO lab.women_town_check(title, lname, zipcode, town)
VALUES ('Mr', 'Sawyer', 'WT3 8GM', 'Nicetown'); --złamanie ograniczenia widoku women

INSERT INTO lab.women_town_check(title, lname, zipcode, town)
VALUES ('Miss', 'Poppins', 'WT3 8GM', 'Welltown');

-- ZMATERIALIZOWANE
CREATE MATERIALIZED VIEW lab.personel_m AS
SELECT fname, lname, zipcode, town
FROM lab.customer
WITH NO DATA;

CREATE MATERIALIZED VIEW lab.personel_f AS
SELECT fname, lname, zipcode, town
FROM lab.customer
WITH DATA;

REFRESH MATERIALIZED VIEW lab.personel_m;