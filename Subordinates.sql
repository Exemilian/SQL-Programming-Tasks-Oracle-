--Condition
--Define a list of subordination sequences from
--teachers who do not have a boss, to teachers who do not
--having subordinates. If the list consists of more than four surnames, 
--then display only the first two and last two surnames, and put an ellipsis in place of the remaining surnames.
--Kostyrkin-> Vikulina-> ...-> Sokolov->Kazanko (has no subordinates)

WITH SRC AS (
    SELECT LEVEL CNT, LTRIM(SYS_CONNECT_BY_PATH(INITCAP(???????), '->'), '->') TEACHERS
    FROM ?????????????
    WHERE CONNECT_BY_ISLEAF = 1
    START WITH ??????????? IS NULL
    CONNECT BY PRIOR ?????_????????????? = ???????????
),
PREP AS (
    SELECT CNT, TEACHERS || ' (?? ????? ???????????)' PATH
    FROM SRC
)
SELECT (CASE
            WHEN CNT > 4 THEN SUBSTR(PATH, 1, INSTR(PATH, '->', 1, 2) + 1) ||
                              '...' || SUBSTR(PATH, INSTR(PATH, '->', -1, 2))
            ELSE PATH
        END) "??????"
FROM PREP;
