set search_path to lab;

-- A
SELECT description, (sell_price - cost_price) AS zysk
FROM lab.item; --jaka jest różnica między ceną sprzedaży a ceną zakupu

SELECT description,
       CASE
           WHEN sell_price - cost_price < 0 THEN 'Strata'
           WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN 'Zysk'
           ELSE 'Super'
           END
FROM lab.item;

-- B
SELECT SUM(CASE WHEN sell_price - cost_price < 0 THEN 1 ELSE 0 END)                                   AS "Strata",
       SUM(CASE WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN 1 ELSE 0 END) AS "Zysk",
       SUM(CASE WHEN sell_price - cost_price > 4 THEN 1 ELSE 0 END)                                   AS "Super"
FROM lab.item;

-- C
SELECT SUM(CASE WHEN sell_price - cost_price < 0 THEN sell_price - cost_price ELSE 0 END) AS "Strata",
       SUM(CASE
               WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN sell_price - cost_price
               ELSE 0 END)                                                                AS "Zysk",
       SUM(CASE WHEN sell_price - cost_price > 4 THEN sell_price - cost_price ELSE 0 END) AS "Super"
FROM lab.item;

-- D
SELECT SUM(sell_price - cost_price),
       (CASE
            WHEN sell_price - cost_price < 0 THEN 'Strata'
            WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN 'Zysk'
            ELSE 'Super' END) AS kolumna_zysk
FROM lab.item
GROUP BY CASE
             WHEN sell_price - cost_price < 0 THEN 'Strata'
             WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN 'Zysk'
             ELSE 'Super' END;

-- E
SELECT orderinfo_id AS numer_zamowienia, SUM(sell_price * quantity) AS Sprzedaz
FROM lab.orderline
         JOIN lab.item USING (item_id)
GROUP BY orderinfo_id;

-- F
SELECT SUM(CASE WHEN sell_price - cost_price < 0 THEN sell_price * quantity ELSE 0 END) AS "Strata",
       SUM(CASE
               WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN sell_price * quantity
               ELSE 0 END)                                                              AS "Zysk",
       SUM(CASE WHEN sell_price - cost_price > 4 THEN sell_price * quantity ELSE 0 END) AS "Super"
FROM lab.orderline
         JOIN lab.item USING (item_id);


-- G
SELECT orderinfo_id,
       SUM(CASE WHEN sell_price - cost_price < 0 THEN sell_price * quantity ELSE 0 END) AS "Strata",
       SUM(CASE
               WHEN sell_price - cost_price >= 0 AND sell_price - cost_price <= 4 THEN sell_price * quantity
               ELSE 0 END)                                                              AS "Zysk",
       SUM(CASE WHEN sell_price - cost_price > 4 THEN sell_price * quantity ELSE 0 END) AS "Super"
FROM lab.orderline
         JOIN lab.item USING (item_id)
GROUP BY orderinfo_id;