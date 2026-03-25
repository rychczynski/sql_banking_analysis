-- 1. What is the average credit limit depending on the card brand (Visa, Mastercard, Discover, AMEX)?
WITH A1 AS 
  (SELECT 
        CAST(REPLACE(credit_limit, '$', '') AS INTEGER) AS credit_limit_val,
        card_brand AS brand
    FROM cards_data)
SELECT 
    brand,
    COUNT(*) AS n_of_cards,
    ROUND(AVG(credit_limit_val), 2) AS avg_credit_limit
FROM A1
GROUP BY brand
ORDER BY avg_credit_limit DESC;


-- 2. Do customers with more than one card (num_cards_issued > 1) also have higher credit limits?
WITH A2 AS 
  (SELECT
        CAST(REPLACE(credit_limit, '$', '') AS INTEGER) AS credit_limit_val,
        CASE WHEN num_cards_issued > 1 THEN 'Multi-card' ELSE 'Single card' END AS loyalty_segment
    FROM cards_data)
SELECT
    loyalty_segment,
    COUNT(*) AS n_of_clients,
    ROUND(AVG(credit_limit_val), 2) AS avg_credit_limit
FROM A2
GROUP BY loyalty_segment
ORDER BY avg_credit_limit DESC;


-- 3. How many cards do not have a chip and what is their percentage of the total portfolio?
SELECT
    SUM(CASE WHEN has_chip = 'YES' THEN 0 ELSE 1 END) AS cards_without_chips,
    COUNT(*) AS total_cards,
    ROUND(SUM(CASE WHEN has_chip = 'YES' THEN 0 ELSE 1 END) * 100.0 / COUNT(*), 2) AS percentage
FROM cards_data;


-- 4. How many chip-enabled cards have appeared on the Dark Web?
SELECT
    has_chip,
    COUNT(*) AS n_of_leaked_cards
FROM cards_data
WHERE has_chip = 'YES' AND card_on_dark_web = 'Yes'
GROUP BY has_chip;
