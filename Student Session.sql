--Condition
--Create a query to build a report on the number of students 
--who took exams on certain days in an arbitrarily specified date interval in various disciplines. 
--Results should be sorted by dates, number of students and discipline names.
--The same date should appear in the report no more than twice: on the first line of the given date and on the reporting date line.

UNDEFINE ST;
UNDEFINE EN;
DEFINE ST = TO_DATE('10.6.1999', 'DD.MM.YYYY');
DEFINE EN = TO_DATE('18.6.1999', 'DD.MM.YYYY');
WITH SRC AS (
    SELECT &ST + LEVEL - 1 DAT
    FROM DUAL
    CONNECT BY &ST + LEVEL - 1 <= &EN
),
GR AS ( 
    SELECT DISTINCT S.DAT, ?.????????, COUNT(??.?????) CNT
    FROM SRC S
    LEFT JOIN ???????????? ?? ON (S.DAT = ??.????)
    LEFT JOIN ?????????? ? ON (??.?????_?????????? = ?.?????_??????????)
    WHERE ??.?????? > 2 OR ??.?????? IS NULL
    GROUP BY ROLLUP(S.DAT, ?.????????)
),
PREP AS (
    SELECT DENSE_RANK() OVER (PARTITION BY DAT ORDER BY CNT, ????????) RN,
           DAT, ????????, CNT
    FROM GR
)
SELECT DT "????", WD "???? ??????", NM "??????????", CNT "???-?? ?????????"
FROM PREP
MODEL
DIMENSION BY (DAT, ????????)
MEASURES (RN, DAT AS DATTT, CAST('' AS VARCHAR2(20)) AS DT, 
          CAST('' AS VARCHAR2(20)) AS WD, ???????? AS NM, CNT)
RULES (
    DT[DAT IS NOT NULL, ???????? IS NOT NULL] = (CASE RN[CV(), CV()] 
                                                    WHEN 1 THEN TO_CHAR(DATTT[CV(), CV()], 'DD.MM.YY')
                                                    ELSE ' '
                                                END),
    DT[DAT IS NOT NULL, NULL] = TO_CHAR(DATTT[CV(), CV()], 'DD.MM.YY') || ':????? ',
    DT[NULL, NULL] = ' ',
    WD[DAT IS NOT NULL, ???????? IS NOT NULL] = (CASE RN[CV(), CV()] 
                                                    WHEN 1 THEN TO_CHAR(DATTT[CV(), CV()], 'DAY')
                                                    ELSE ' '
                                                END),
    WD[DAT IS NOT NULL, NULL] = TO_CHAR(DATTT[CV(), CV()], 'DAY'),
    WD[NULL, NULL] = ' ',
    NM[DAT IS NOT NULL, ANY] = NVL(NM[CV(), CV()], ' '),
    NM[NULL, NULL] = '????? ????'
);
