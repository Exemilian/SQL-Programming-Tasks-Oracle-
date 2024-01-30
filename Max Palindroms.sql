--Condition
--I have a table with a character column. Create a request
--to output those values ??that contain palindromes, and
--the longest expressions that are a palindrome.

WITH SRC AS(
    SELECT '????????'TEXT FROM DUAL
    UNION ALL
    SELECT '???????'TEXT FROM DUAL
    UNION ALL
    SELECT '??????'TEXT FROM DUAL
),
NUMR AS (
    SELECT ROWNUM RN, TEXT
    FROM SRC
),
MODI AS (
    SELECT RN, CNT, SYM
    FROM NUMR
    MODEL
    PARTITION BY (RN)
    DIMENSION BY (CAST (1 AS NUMBER(5)) AS CNT)
    MEASURES (TEXT, CAST (' ' AS VARCHAR2(40)) AS SYM)
    RULES ITERATE(100) UNTIL (ITERATION_NUMBER + 1 >= LENGTH(TEXT[1])) (
        SYM[ITERATION_NUMBER + 1] = SUBSTR(TEXT[1], ITERATION_NUMBER + 1, 1)
    )
),
COMB AS (
    SELECT RN, REPLACE(SYS_CONNECT_BY_PATH(SYM, ','), ',') CB
    FROM MODI
    WHERE LEVEL != 1
    CONNECT BY PRIOR CNT = CNT - 1 AND PRIOR RN = RN
),
PAL AS (
    SELECT RN, CB
    FROM COMB
    WHERE LOWER(CB) = LOWER(REVERSE(CB))
),
MAXPAL AS (
    SELECT RN, LISTAGG(CB, ', ') WITHIN GROUP(ORDER BY CB) P
    FROM PAL
    WHERE LENGTH(CB) = (SELECT MAX(LENGTH(CB)) FROM PAL PP WHERE PP.RN = PAL.RN)
    GROUP BY RN
)
SELECT NUMR.TEXT "Text", MP.P "Palindrom"
FROM MAXPAL MP
LEFT JOIN NUMR ON (NUMR.RN = MP.RN);
