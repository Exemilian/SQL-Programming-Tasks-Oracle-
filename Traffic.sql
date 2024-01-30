--Condition
--Write a query to the Traffic table (Date and time of transaction start, Date and time of transaction end, 
--Volume in bytes), which will count the amount of transmitted traffic for each day of a given month and year. 
--If the session began and ended on different days, then the traffic should be divided in proportion to the duration on each day.
--If the result of proportional division is fractional, then discard the fractional part for the initial day, 
--and assign the remainder to the end of the session. The duration of the session is not limited in time.

WITH SRC AS (
SELECT TO_DATE('2.1.2020 23:00', 'DD.MM.YYYY HH24:MI') ST, 
       TO_DATE('5.1.2020 01:00', 'DD.MM.YYYY HH24:MI') EN, 1000 TR
FROM DUAL 
UNION ALL
SELECT TO_DATE('10.1.2020 11:08', 'DD.MM.YYYY HH24:MI'), 
       TO_DATE('12.1.2020 01:24', 'DD.MM.YYYY HH24:MI'), 3555
FROM DUAL 
UNION ALL
SELECT TO_DATE('11.1.2020 12:00', 'DD.MM.YYYY HH24:MI'), 
       TO_DATE('11.1.2020 13:13', 'DD.MM.YYYY HH24:MI'), 1642
FROM DUAL 
UNION ALL
SELECT TO_DATE('12.1.2020 00:05', 'DD.MM.YYYY HH24:MI'), 
       TO_DATE('12.1.2020 1:02', 'DD.MM.YYYY HH24:MI'), 655
FROM DUAL
UNION ALL
SELECT TO_DATE('10.1.2020 23:07', 'DD.MM.YYYY HH24:MI'), 
       TO_DATE('11.1.2020 14:11', 'DD.MM.YYYY HH24:MI'), 2555
FROM DUAL
),
RNUMB AS (
    SELECT ROWNUM RN, ST, EN, TR, TR / (EN - ST) KOF
    FROM SRC
),
MODI AS (
    SELECT RN, CNT, DAT, TRAF
    FROM RNUMB
    MODEL 
    PARTITION BY (RN)
    DIMENSION BY (CAST (1 AS NUMBER(5)) AS CNT)
    MEASURES (ST, EN, TR, KOF, CAST (NULL AS DATE) AS DAT, CAST (0 AS NUMBER(10)) AS TRAF)
    RULES ITERATE (100) UNTIL (TO_DATE(TO_CHAR(ST[1] + ITERATION_NUMBER, 'DD.MM.YYYY'), 'DD.MM.YYYY') >= 
                               TO_DATE(TO_CHAR(EN[1], 'DD.MM.YYYY'), 'DD.MM.YYYY')) (
        DAT[ITERATION_NUMBER + 1] = TO_DATE(TO_CHAR(ST[1] + ITERATION_NUMBER, 'DD.MM.YYYY'), 'DD.MM.YYYY'),
        TRAF[ITERATION_NUMBER + 1] = (CASE
                                        WHEN TO_CHAR(ST[1], 'DD.MM.YYYY') = TO_CHAR(EN[1], 'DD.MM.YYYY') THEN TR[1]
                                        WHEN ITERATION_NUMBER = 0 THEN (TRUNC(ST[1] + 1, 'DD') - ST[1]) * KOF[1] 
                                        WHEN TO_DATE(TO_CHAR(ST[1] + ITERATION_NUMBER, 'DD.MM.YYYY'), 'DD.MM.YYYY') = 
                                             TO_DATE(TO_CHAR(EN[1], 'DD.MM.YYYY'), 'DD.MM.YYYY')
                                             THEN (EN[1] - TRUNC(EN[1], 'DD')) * KOF[1]
                                        ELSE (TRUNC(ST[1] + 1, 'DD') - TRUNC(ST[1], 'DD')) * KOF[1]
                                      END) 
    )
),
PREP AS (
    SELECT MD.RN, MD.CNT, MD.DAT, 
           (CASE WHEN CNT = (SELECT MAX(MM.CNT) 
                             FROM MODI MM 
                             WHERE MM.RN = MD.RN)
                    THEN TRUNC(TRAF) + ROUND((SELECT SUM(MOD(MM.TRAF, 1)) 
                                              FROM MODI MM 
                                              WHERE MM.RN = MD.RN))
                  ELSE TRUNC(TRAF)
            END) NTRAF
    FROM MODI MD
)
SELECT DAT "????", SUM(NTRAF) "????????? ??????"
FROM PREP
GROUP BY DAT
ORDER BY DAT;
