--Condition
--I have a table with a column that contains many values,
--separated by commas. You need to create a query that will display each value
--on a separate line. Solve the problem using the Model section.

WITH SRC AS (
    SELECT '952240' NB, '2-34,3-41' TF 
    FROM DUAL
    UNION ALL
    SELECT '952423','2-78,2-83,8-34'
    FROM DUAL
),
RNUMB AS (
    SELECT ROWNUM RN, NB, TF
    FROM SRC
)
SELECT (CASE CNT WHEN 1 THEN NB ELSE ' ' END) Number,
       NVL(TEL, ' ') Telephone
FROM RNUMB
MODEL
PARTITION BY (RN)
DIMENSION BY (CAST (1 AS NUMBER(5)) AS CNT)
MEASURES (NB, TF, CAST ('' AS VARCHAR2(40)) AS TEL)
RULES ITERATE (100) UNTIL (ITERATION_NUMBER + 1 >= NVL(REGEXP_COUNT(TF[1], '[^,]+'), 0)) (
    TEL[ITERATION_NUMBER + 1] = REGEXP_SUBSTR(TF[1], '[^,]+', 1, ITERATION_NUMBER + 1)
);
