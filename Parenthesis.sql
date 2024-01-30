--COndition
--For an arbitrary string consisting of opening and
--closing brackets write a query to display all
--words of maximum length representing correct
--bracket entries. For example, for the string (())(() the answer is
--it should be:
--()()
--(())
--Solve the problem using the Model section.

WITH T AS( 
    SELECT ')(()()))' STR FROM DUAL
),
T1 AS(
    SELECT STR, LEVEL RN, SUBSTR(STR, LEVEL, 1) LET 
    FROM T
    CONNECT BY LEVEL <=LENGTH(STR)
),
T2 AS(
    SELECT ROWNUM RN, STR, NABOR 
    FROM(
        SELECT DISTINCT STR, REPLACE(SYS_CONNECT_BY_PATH(LET, ' '), ' ') NABOR 
        FROM T1
        CONNECT BY PRIOR RN < RN
    )
),
MODI AS (
    SELECT RN, STR, NABOR, SUMM
    FROM T2
    MODEL
    DIMENSION BY (RN)
    MEASURES (STR, NABOR, CAST (0 AS NUMBER(3)) AS SUMM)
    RULES ITERATE(1000) (
        SUMM[ANY] = 
        (CASE SUMM[CV()] 
            WHEN -1 THEN -1 
            ELSE (CASE SUBSTR(NABOR[CV()], ITERATION_NUMBER + 1, 1)
                    WHEN '(' THEN SUMM[CV()] + 1
                    WHEN ')' THEN SUMM[CV()] - 1
                    ELSE SUMM[CV()] 
                 END)
        END)
    )
),
PRAV AS (
    SELECT NABOR
    FROM MODI
    WHERE SUMM = 0
)
SELECT NABOR
FROM PRAV
WHERE LENGTH(NABOR) = (SELECT MAX(LENGTH(NABOR)) FROM PRAV);
