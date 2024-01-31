--Condition
--For an arbitrary string consisting of numbers,
--separated by the specified delimiter, get the string,
--displaying these numbers in reverse order. For example,
--for the original string:
--0|0|1.45|2|1|2|10|22|34|15|0|-105|66|73
--you should get the following string:
--73|66|-105|0|15|34|22|10|2|1|2|1.45|0|0.
--Solve the problem without using hierarchical queries.

WITH SRC AS (
    SELECT '0|0|1.45|2|1|2|10|22|34|15|0|-105|66|73' STR 
    FROM DUAL
)
SELECT RTRIM(REVSTR, '|') "Reverse string"
FROM SRC
MODEL
DIMENSION BY (1 AS RN)
MEASURES (STR, CAST (NULL AS VARCHAR2(100)) AS REVSTR)
RULES ITERATE (100) UNTIL (ITERATION_NUMBER >= REGEXP_COUNT(STR[1], '\|')) (
    REVSTR[1] = REGEXP_SUBSTR(STR[1], '[^|]+', 1, ITERATION_NUMBER + 1) || '|' || REVSTR[CV()]
);
