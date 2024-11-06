set search_path to lab;

-- A
WITH RECURSIVE test_with(n) AS (VALUES (1)
                                UNION
                                SELECT n + 1
                                FROM test_with
                                WHERE n < 10)
SELECT *
FROM test_with
ORDER BY n;

-- B
SET statement_timeout = '1s'; --gdy mamy UNION ALL mozemy dokladać duplikaty, czy czść rekursywna nigdy sie nie skończy
WITH RECURSIVE source AS (SELECT 'Hello' UNION ALL SELECT 'Hello' FROM source)
SELECT *
FROM source;

RESET statement_timeout; --gdy mamy UNION nie mozemy dokladać duplikatów
WITH RECURSIVE source AS (SELECT 'Hello' UNION SELECT 'Hello' FROM source)
SELECT *
FROM source;

-- C
CREATE TABLE department
(
    id                INTEGER PRIMARY KEY,           -- departament ID
    parent_department INTEGER REFERENCES department, -- ID nadrzednego departamentu
    name              TEXT                           -- nazwa departamentu
);

INSERT INTO department (id, parent_department, "name")
VALUES (0, NULL, 'ROOT'),
       (1, 0, 'A'),
       (2, 1, 'B'),
       (3, 2, 'C'),
       (4, 2, 'D'),
       (5, 0, 'E'),
       (6, 4, 'F'),
       (7, 5, 'G');

-- struktura departamentow:
--
-- ROOT-+->A-+->B-+->C
--      |         |
--      |         +->D-+->F
--      +->E-+->G


-- D
WITH RECURSIVE subdepartment AS
                   (
                       -- non-recursive term
                       SELECT *
                       FROM department
                       WHERE name = 'A'

                       UNION ALL

                       -- recursive term
                       SELECT d.*
                       FROM department AS d
                                JOIN
                            subdepartment AS sd
                            ON (d.parent_department = sd.id))
SELECT *
FROM subdepartment
ORDER BY name;

select *
from department d;

-- E
WITH RECURSIVE delete_old_department(id) AS (SELECT id
                                             FROM department
                                             WHERE id = 2
                                             UNION
                                             SELECT c.id
                                             FROM delete_old_department foo,
                                                  department c
                                             WHERE foo.id = c.parent_department)
DELETE
FROM department
WHERE id IN (SELECT id FROM delete_old_department);

-- F
WITH RECURSIVE delete_old_department(id) AS (SELECT id
                                             FROM department
                                             WHERE parent_department = 2
                                             UNION
                                             SELECT c.id
                                             FROM delete_old_department foo,
                                                  department c
                                             WHERE foo.id = c.parent_department)
DELETE
FROM department
WHERE id IN (SELECT id FROM delete_old_department);