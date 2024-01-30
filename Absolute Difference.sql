--Condition
--For an arbitrary integer, determine the numbers obtained
--permutations of digits in a number and having maximum sums
--absolute differences between adjacent numbers. For example, for a number
--1239 the result should be:
--3192
--2913
--The sums of absolute differences are equal:
--|3-1| + |1-9| + |9-2| = 17
--|2-9| + |9-1| + |1-3| = 17
--Make sure it works with 5, 10, 15 and 20 digits in the number.

UNDEFINE DN;
DEFINE DN = 1239;
WITH SRC AS (
    SELECT TO_CHAR((CASE WHEN &DN > 0 THEN &DN ELSE -1 * &DN END)) N FROM DUAL
),
DGT AS (
    SELECT ROWNUM RN, SUBSTR(N, LEVEL, 1) DIG
    FROM SRC
    CONNECT BY LEVEL <= LENGTH(N)
),
COMB AS (
    SELECT ROWNUM RN, REPLACE(SYS_CONNECT_BY_PATH(DIG, ' '), ' ') CB
    FROM DGT
    WHERE LEVEL = 4
    CONNECT BY NOCYCLE PRIOR RN != RN AND LEVEL <= (SELECT COUNT(*) FROM DGT)
),
MODI AS (
    SELECT CB, SR
    FROM COMB
    MODEL
    DIMENSION BY (RN)
    MEASURES (CB, CAST(0 AS NUMBER(10)) AS SR)
    RULES ITERATE(25) UNTIL (ITERATION_NUMBER >= LENGTH(CB[1]) - 2) (
        SR[ANY] = SR[CV()] + ABS(TO_NUMBER(SUBSTR(CB[CV()], ITERATION_NUMBER + 1, 1)) - TO_NUMBER(SUBSTR(CB[CV()], ITERATION_NUMBER + 2, 1)))
    )
)
SELECT (CASE WHEN &DN < 0 THEN '-' ELSE '' END) || CB "??????????"
FROM MODI
WHERE SR = (SELECT MAX(SR) FROM MODI);
