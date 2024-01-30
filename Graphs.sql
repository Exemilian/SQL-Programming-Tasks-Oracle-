--Condition
--Create a Cities table that stores the names of cities and the distances between
--them. The names of the cities are unique.
--Write a SELECT command that will determine all paths and
--distances between two cities whose names are given as options. 
--Display the path as a list, for example, Moscow - Kazan - Vologda.
--Forward and reverse distances may vary

UNDEFINE ST;
UNDEFINE EN;
DEFINE ST = '??????';
DEFINE EN = '???????';
WITH SRC AS (
    SELECT '??????' SR, '??????' DEST, 2000 RAST FROM DUAL
    UNION ALL
    SELECT '??????', '????', 200 FROM DUAL
    UNION ALL
    SELECT '??????', '???????', 800 FROM DUAL
    UNION ALL
    SELECT '??????', '?????-?????????', 700 FROM DUAL
    UNION ALL
    SELECT '?????-?????????', '??????', 735 FROM DUAL
    UNION ALL
    SELECT '??????', '???????', 400 FROM DUAL
    UNION ALL
    SELECT '?????-?????????', '???????', 5000 FROM DUAL
),
TOWNS AS (
    SELECT DISTINCT SR TMP FROM SRC
    UNION ALL
    SELECT DISTINCT DEST FROM SRC
),
DOP AS (
    SELECT * FROM SRC
    UNION ALL
    SELECT DISTINCT TMP, NULL, 0
    FROM TOWNS
),
PAT AS (
    SELECT LTRIM(SYS_CONNECT_BY_PATH(SR, '->'), '->') WAY, 
           LTRIM(SYS_CONNECT_BY_PATH(RAST, '+'), '+') FL
    FROM DOP
    START WITH LOWER(SR) = LOWER('&ST') AND DEST IS NOT NULL
    CONNECT BY NOCYCLE PRIOR LOWER(DEST) = LOWER(SR)
),
STEN AS (
    SELECT ROWNUM RN, WAY, FL
    FROM PAT
    WHERE REGEXP_LIKE(WAY, '^.+&EN$', 'i')
),
NOCYC AS (
    SELECT * 
    FROM STEN ST
    WHERE NOT EXISTS (SELECT TMP
                     FROM TOWNS
                     WHERE REGEXP_COUNT(ST.WAY, TMP, 1, 'i') >= 2)
)
SELECT WAY, D DISTANCE
FROM NOCYC
MODEL
DIMENSION BY (RN)
MEASURES (WAY, FL, CAST(0 AS NUMBER(10)) AS D)
RULES ITERATE(10) (
    D[ANY] = D[CV()] + NVL(TO_NUMBER(REGEXP_SUBSTR(FL[CV()], '[^+]+', 1, ITERATION_NUMBER + 1)), 0)
);
