--Condition
--In the written expression ((((1?2)?3)?4)?5)?6 instead of each sign ?
--insert a sign of one of the 4 arithmetic operations +,-,*,/ so that
--the result of the calculations was 35 (when dividing the fractional part in the quotient
--is discarded). Find all solutions

WITH SRC AS (
    SELECT '((((1?2)?3)?4)?5)?6' TXT
    FROM DUAL
),
OPER AS (
    SELECT '+' OP FROM DUAL
    UNION ALL
    SELECT '-' FROM DUAL
    UNION ALL
    SELECT '*' FROM DUAL
    UNION ALL
    SELECT '/' FROM DUAL
),
COMB AS (
    SELECT ROWNUM RN, REPLACE(SYS_CONNECT_BY_PATH(OP, ' '), ' ') CB
    FROM OPER
    WHERE LEVEL = 5
    CONNECT BY LEVEL <= 5
),
MODI AS (
    SELECT CB, ANS
    FROM COMB
    MODEL
    DIMENSION BY (RN)
    MEASURES (CB, CAST(1 AS NUMBER(5)) AS ANS)
    RULES ITERATE (5) (
        ANS[ANY] = (CASE SUBSTR(CB[CV()], ITERATION_NUMBER + 1, 1)
                        WHEN '+' THEN ANS[CV()] + (ITERATION_NUMBER + 2)
                        WHEN '-' THEN ANS[CV()] - (ITERATION_NUMBER + 2)
                        WHEN '*' THEN ANS[CV()] * (ITERATION_NUMBER + 2)
                        ELSE TRUNC(ANS[CV()] / (ITERATION_NUMBER + 2))
                    END)
    )
),
PREP AS (
    SELECT ROWNUM RN, SRC.TXT, M.CB
    FROM MODI M
    CROSS JOIN SRC
    WHERE M.ANS = 35
)
SELECT TXT "??????????"
FROM PREP
MODEL
DIMENSION BY (RN)
MEASURES (TXT, CB)
RULES ITERATE(5) (
    TXT[ANY] = REGEXP_REPLACE(TXT[CV()], '\?', SUBSTR(CB[CV()], ITERATION_NUMBER + 1, 1), 1, 1)
);
