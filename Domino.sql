--Condition
--There is a random set of dominoes. Information about them
--represented as a character string consisting of an even number of digits
--from 0 to 6. Numbers are separated by commas. Numbers located on adjacent
--odd and even places refer to one bone. Create a request for
--determining the longest sequences that can be
--compose from a given set. Result for each sequence
--must be represented as a character string.

WITH TAB1 AS (
    SELECT '2,1,2,6,4,2,3,5,6,5,6,6' STR FROM DUAL
),
TAB2 AS (
    SELECT REGEXP_SUBSTR(STR, '[^,]', 1, 2 * LEVEL - 1) D1,
           REGEXP_SUBSTR(STR, '[^,]', 1, 2 * LEVEL) D2
    FROM TAB1
    CONNECT BY LEVEL <= (REGEXP_COUNT(STR, ',') + 1) / 2
),
TAB3 AS (
    SELECT D1 D1, D2 D2, ROWNUM R
    FROM TAB2
    UNION
    SELECT D2, D1, ROWNUM 
    FROM TAB2
),
TAB4 AS (
    SELECT LTRIM(SYS_CONNECT_BY_PATH(D1 || ',' || D2, ' '), ' ') STR
    FROM TAB3
    CONNECT BY NOCYCLE PRIOR R <> R AND D1 = PRIOR D2
),
TAB5 AS (
    SELECT STR
    FROM TAB4 T4
    WHERE NOT EXISTS (SELECT *
                      FROM TAB2
                      WHERE REGEXP_COUNT(T4.STR, D1 || ',' || D2) + 
                            REGEXP_COUNT(T4.STR, D2 || ',' || D1) - 
                            (CASE WHEN D1 = D2 THEN 1 ELSE 0 END) >= 2)
)
SELECT STR 
FROM TAB5
WHERE LENGTH(STR)=(SELECT MAX(LENGTH(STR)) FROM TAB5);
