--Consition
--An arbitrary character string consisting of two parts is specified,
--separated by "=>" symbols. On the left and right sides of the expression
--contains character strings separated by commas.
--You need to create a query that will display all possible pairs
--combinations of left and right parts.

WITH SRC AS (
    SELECT 'a,fgf,yy=>uu,gh' STR FROM DUAL
),
LRP AS (
    SELECT REGEXP_SUBSTR(STR, '[^(=>)]+', 1, 1) L,
           REGEXP_SUBSTR(STR, '[^(=>)]+', 1, 2) R
    FROM SRC
),
LP AS (
    SELECT LEVEL LV, REGEXP_SUBSTR(L, '[^,]+', 1, LEVEL) P1
    FROM LRP
    CONNECT BY LEVEL <= REGEXP_COUNT(L, '[^,]+')
),
RP  AS (
    SELECT LEVEL RV, REGEXP_SUBSTR(R, '[^,]+', 1, LEVEL) P2
    FROM LRP
    CONNECT BY LEVEL <= REGEXP_COUNT(R, '[^,]+')
) 
SELECT LP.P1 || '=>' || RP.P2 PATH
FROM LP
CROSS JOIN RP
ORDER BY LP.LV, RP.RV;
