--Condition
--For an arbitrary string consisting of digits, determine all possible
--sets of words obtained by replacing numbers with the number of letters in the Russian alphabet.
--For example, for line 211221 the result should be: ??????,?????,?????,?????,???,......

WITH SRC AS (
    SELECT '211221' STR
    FROM DUAL
),
SPL AS (
    SELECT TO_NUMBER(SUBSTR(STR, LEVEL, 1)) NM, LEVEL POS
    FROM SRC
    CONNECT BY LEVEL <= LENGTH(STR)
    UNION ALL
    SELECT TO_NUMBER(SUBSTR(STR, LEVEL, 2)), LEVEL
    FROM SRC
    CONNECT BY LEVEL < LENGTH(STR)
),
FILT AS (
    SELECT NM, POS
    FROM SPL
    WHERE NM <= 33
),
COMB AS (
    SELECT REPLACE(SYS_CONNECT_BY_PATH(SUBSTR('?????????????????????????????????', NM, 1), ' '), ' ') CB, POS + LENGTH(NM) - 1 LST
    FROM FILT
    WHERE CONNECT_BY_ISLEAF = 1 
    START WITH POS = 1
    CONNECT BY PRIOR POS + LENGTH(PRIOR NM) - 1 = POS - 1
)
SELECT CB "?????"
FROM COMB, SRC
WHERE LST = LENGTH(STR);
