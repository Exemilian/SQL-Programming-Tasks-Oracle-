--Condition
--There is a table with columns Number, Line. Column data type Number -
--Integer, String column data type is Varchar2(10). First column
--contains the serial number of the record, the String column – character strings,
--consisting of 0 and 1. The total number of digits in all lines is the same
--and equals 5. Write a request, which will print the numbers of the maximum
--number of rows and column positions Row forming a square a matrix consisting only of ones.

WITH SRC AS (
    SELECT 1 ID, '00101' STR FROM DUAL
    UNION ALL
    SELECT 2, '10011' FROM DUAL
    UNION ALL
    SELECT 3, '10101' FROM DUAL
),
COMB AS (
    SELECT ROWNUM RN, LEVEL LV, 
           LTRIM(SYS_CONNECT_BY_PATH(ID, ','), ',') CB,
           LTRIM(SYS_CONNECT_BY_PATH(SUBSTR(STR, 1, 1), '*'), '*') B1,
           LTRIM(SYS_CONNECT_BY_PATH(SUBSTR(STR, 2, 1), '*'), '*') B2,
           LTRIM(SYS_CONNECT_BY_PATH(SUBSTR(STR, 3, 1), '*'), '*') B3,
           LTRIM(SYS_CONNECT_BY_PATH(SUBSTR(STR, 4, 1), '*'), '*') B4,
           LTRIM(SYS_CONNECT_BY_PATH(SUBSTR(STR, 5, 1), '*'), '*') B5
    FROM SRC
    CONNECT BY PRIOR ID < ID
),
MODI AS (
    SELECT RN, LV, CB, M1, M2, M3, M4, M5
    FROM COMB
    MODEL
    DIMENSION BY (RN)
    MEASURES (LV, CB, 1 AS M1, 1 AS M2, 1 AS M3, 1 AS M4, 1 AS M5, B1, B2, B3, B4, B5)
    RULES ITERATE (32) (
        M1[ANY] = M1[CV()] * NVL(TO_NUMBER(REGEXP_SUBSTR(B1[CV()], '[^*]', 1, ITERATION_NUMBER + 1)), 1),
        M2[ANY] = M2[CV()] * NVL(TO_NUMBER(REGEXP_SUBSTR(B2[CV()], '[^*]', 1, ITERATION_NUMBER + 1)), 1),
        M3[ANY] = M3[CV()] * NVL(TO_NUMBER(REGEXP_SUBSTR(B3[CV()], '[^*]', 1, ITERATION_NUMBER + 1)), 1),
        M4[ANY] = M4[CV()] * NVL(TO_NUMBER(REGEXP_SUBSTR(B4[CV()], '[^*]', 1, ITERATION_NUMBER + 1)), 1),
        M5[ANY] = M5[CV()] * NVL(TO_NUMBER(REGEXP_SUBSTR(B5[CV()], '[^*]', 1, ITERATION_NUMBER + 1)), 1)
    )
),
SMM AS (
    SELECT LV, CB, M1, M2, M3, M4, M5
    FROM MODI
    WHERE M1 + M2 + M3 + M4 + M5 = LV
)
SELECT CB "??????", RTRIM(DECODE(M1, 1, '1,', '') || DECODE(M2, 1, '2,', '') || 
       DECODE(M3, 1, '3,', '') || DECODE(M4, 1, '4,', '') || DECODE(M5, 1, '5,', ''), ',') "???????"
FROM SMM
WHERE LV = (SELECT MAX(LV) FROM SMM);
