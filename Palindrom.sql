--Condition
--With one command, print all palindromes found in an arbitrary character string. 
--For example, for the string aabacdca the answer should be: aa,aba, cdc, acdca.

WITH SRC AS (
    SELECT 'AABACDCA' STR 
    FROM DUAL
),
SPL AS (
    SELECT ROWNUM RN, SUBSTR(STR, LEVEL, 1) SYM
    FROM SRC
    CONNECT BY LEVEL <= LENGTH(STR)
),
COMB AS (
    SELECT REPLACE(SYS_CONNECT_BY_PATH(SYM, ' '), ' ') CB
    FROM SPL
    WHERE LEVEL != 1
    CONNECT BY PRIOR RN = RN - 1
)
SELECT CB Combination
FROM COMB
WHERE LOWER(CB) = LOWER(REVERSE(CB));
