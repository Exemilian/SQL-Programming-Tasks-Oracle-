--Condition
--Check for the presence of cycles in the table of subordination. Output cyclic
--dependencies in a line in the form Number1.Name1->Number2.Name2->...Number1.Name1, starting
--from the first name in alphabetical order.

WITH SRC AS (
    SELECT 1 N, 'Alexey' NAME, 2 M FROM DUAL
    UNION ALL
    SELECT 2, 'Petr', 3 FROM DUAL
    UNION ALL
    SELECT 3, 'Pavel', 4 FROM DUAL
    UNION ALL
    SELECT 4, 'Ivan', 2 FROM DUAL
    UNION ALL
    SELECT 5, 'Kristina', 6 FROM DUAL
    UNION ALL
    SELECT 6, 'Andrey', 5 FROM DUAL
),
T AS (
    SELECT E.*, M.NAME MNAME
    FROM SRC E
    LEFT JOIN SRC M ON E.M = M.N
    ORDER BY E.NAME
),
PREP AS (
    SELECT LTRIM(SYS_CONNECT_BY_PATH(M || '.' || MNAME, '->') || '->' || N || '.' || NAME, '->') CYC
    FROM T
    WHERE CONNECT_BY_ROOT(M) = N
    CONNECT BY NOCYCLE PRIOR N = M
),
MODI AS (
    SELECT CYC, NN
    FROM PREP
    MODEL
    PARTITION BY (ROWNUM RN)
    DIMENSION BY (1 AS CNT)
    MEASURES (CYC, CAST (REGEXP_SUBSTR(CYC, '[[:alpha:]]+', 1, 1) AS VARCHAR2(40)) AS NN)
    RULES ITERATE(100) UNTIL (ITERATION_NUMBER > REGEXP_COUNT(CYC[1], '->')) (
        NN[1] = (CASE WHEN NN[CV()] > REGEXP_SUBSTR(CYC[CV()], '[[:alpha:]]+', 1, ITERATION_NUMBER + 2)
                        THEN REGEXP_SUBSTR(CYC[CV()], '[[:alpha:]]+', 1, ITERATION_NUMBER + 2)
                      ELSE NN[CV()] END)
    )
) 
SELECT CYC CYCLE
FROM MODI
WHERE REGEXP_SUBSTR(CYC, '[[:alpha:]]+', 1, 1) = NN;
