--Condition
--Define a list of employees (Employees table) whose names and
--surnames contain at least three matching letters.

WITH SRC AS (
    SELECT ROWNUM RN, LAST_NAME || ' ' || FIRST_NAME NAME
    FROM EMPLOYEES
),
MODI AS (
    SELECT NAME, LET
    FROM SRC
    MODEL
    PARTITION BY (RN)
    DIMENSION BY (1 AS CNT)
    MEASURES (NAME, LOWER(NAME) AS NM, CAST ('' AS VARCHAR2(30)) AS LET) 
    RULES ITERATE(50) UNTIL (ITERATION_NUMBER >= LENGTH(NM[1])) (
        LET[1] = (CASE 
                    WHEN SUBSTR(NM[1], ITERATION_NUMBER + 1, 1) IN ('*', ' ') THEN LET[1]
                    WHEN REGEXP_COUNT(NM[1], SUBSTR(NM[1], ITERATION_NUMBER + 1, 1)) >= 2 
                        THEN LET[1] || ',' || SUBSTR(NM[1], ITERATION_NUMBER + 1, 1)
                    ELSE LET[1]
                  END),
        NM[1] = (CASE 
                    WHEN SUBSTR(NM[1], ITERATION_NUMBER + 1, 1) IN ('*', ' ') THEN NM[1]
                    ELSE REGEXP_REPLACE(NM[1], SUBSTR(NM[1], ITERATION_NUMBER + 1, 1), '*')
                  END)
    )
)
SELECT NAME "?????????", 
       '????????? ' ||  (CASE REGEXP_COUNT(LET, ',') 
                            WHEN 3 THEN '???'
                            WHEN 4 THEN '??????'
                            WHEN 5 THEN '????'
                            WHEN 6 THEN '?????'
                            WHEN 7 THEN '????'
                            WHEN 8 THEN '??????'
                            WHEN 9 THEN '??????'
                            ELSE TO_CHAR(REGEXP_COUNT(LET, ','))
                         END) || ' ????' ||
                         (CASE WHEN REGEXP_COUNT(LET, ',') > 4 THEN '' ELSE '?' END) ||
                         ' (' || LTRIM(LET, ',') || ')' "?????????"
FROM MODI
WHERE REGEXP_COUNT(LET, ',') >= 3;
