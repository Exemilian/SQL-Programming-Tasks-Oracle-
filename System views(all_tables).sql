--Condition
--Create a query to list all columns in a view ALL_TABLES. 
--Column names should be sorted alphabetically and
--separated by commas. The list must be divided into lines, while
--Each line must contain no more than 50 characters. Everyone's name
--The column must be placed entirely on one line. If after the name
--column followed by a comma, it must appear on the line along with column name.
--The query result must also contain the row number and quantity columns per row.

WITH SRC AS (
    SELECT 1 RN, LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_NAME) STR
    FROM ALL_TAB_COLUMNS
    WHERE UPPER(TABLE_NAME) = 'ALL_TABLES'
),
MODI AS (
    SELECT NSTR
    FROM SRC
    MODEL
    DIMENSION BY (RN)
    MEASURES (STR, CAST(NULL AS VARCHAR2(4000)) AS NSTR, CAST(NULL AS VARCHAR2(100)) AS TSTR)
    RULES ITERATE(1000) UNTIL (ITERATION_NUMBER > REGEXP_COUNT(STR[1], ',') + 1) (
        NSTR[1] = NSTR[1] || 
                  (CASE
                        WHEN ITERATION_NUMBER = REGEXP_COUNT(STR[1], ',') + 1
                            THEN RTRIM(TSTR[1], ',')
                        WHEN LENGTH(TSTR[1] || REGEXP_SUBSTR(STR[1], '[^,]+', 1, ITERATION_NUMBER + 1) || ',') > 50 
                            THEN TSTR[1]|| '|'
                        ELSE ''
                   END),
        TSTR[1] = (CASE 
                        WHEN LENGTH(TSTR[1] || REGEXP_SUBSTR(STR[1], '[^,]+', 1, ITERATION_NUMBER + 1) || ',') > 50
                            THEN REGEXP_SUBSTR(STR[1], '[^,]+', 1, ITERATION_NUMBER + 1) || ','
                        ELSE TSTR[1] || REGEXP_SUBSTR(STR[1], '[^,]+', 1, ITERATION_NUMBER + 1) || ','
                    END)
    )
),
SPL AS (
    SELECT LEVEL LV, REGEXP_SUBSTR(NSTR, '[^|]+', 1, LEVEL) PAC
    FROM MODI
    CONNECT BY LEVEL <= REGEXP_COUNT(NSTR, '\|') + 1
)
SELECT (CASE LV WHEN 1 THEN 'ALL_TABLES' ELSE ' ' END) "??? ?????????????",
        LV "????? ??????", PAC "?????? ????????", REGEXP_COUNT(PAC, '[^,]+') "?????????? ????????"
FROM SPL;
