--Condition
--Create a request that will allow you to leave only one of
--repeated words in the text, following each other and separated
--spaces. The number of repeated words is arbitrary.

WITH SRC AS (
    SELECT ' qq q qwe Qwe qwe qwe dd dd                qwe ff ff ws h dd ff ds   ' STR
    FROM DUAL
),
PROB AS (
    SELECT TRIM(REGEXP_REPLACE(STR, '[ ]+', ' ')) NS
    FROM SRC
),
DIV AS (
    SELECT LEVEL RN, REGEXP_SUBSTR(NS, '[^ ]+', 1, LEVEL) WORDS
    FROM PROB
    CONNECT BY LEVEL <= REGEXP_COUNT(NS, ' ') + 1
),
SIG AS (
    SELECT RN, WORDS, 
           (CASE 
                WHEN LOWER(WORDS) = LOWER(LAG(WORDS, 1, ' ') OVER (ORDER BY RN)) THEN 0
                ELSE 1
            END) CHK
    FROM DIV
)
SELECT LISTAGG(WORDS, ' ') WITHIN GROUP (ORDER BY RN) "Altered string"
FROM SIG
WHERE CHK != 0;
