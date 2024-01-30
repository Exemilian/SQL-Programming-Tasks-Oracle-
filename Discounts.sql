--Condition
--There is a Sales table (Number, Product Name, Date,
--Discount %). Print a sales report that includes columns
--Product name, Sale dates, % discount by submitting
--information in such a way that if the same product
--was sold with the same discount for several days, then these dates
--must be separated by commas. Moreover, if two or more
--the dates differ from each other by one day, then they must be
--are presented as an interval with a hyphen as a separator.

WITH SRC AS (
    SELECT 1 ID, 'CHAIR' THING, TO_DATE('1.02.2016','DD.MM.YYYY') DAT, 5 DIS FROM DUAL UNION ALL
    SELECT 2, 'CHAIR', TO_DATE('5.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 3, 'CHAIR', TO_DATE('7.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 4, 'CHAIR', TO_DATE('8.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 5, 'CHAIR', TO_DATE('9.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 6, 'CHAIR', TO_DATE('10.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 7, 'CHAIR', TO_DATE('11.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 8, 'CHAIR', TO_DATE('12.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 9, 'CHAIR', TO_DATE('15.02.2016','DD.MM.YYYY'), 5 FROM DUAL UNION ALL
    SELECT 10, 'TABLE', TO_DATE('2.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 11, 'TABLE', TO_DATE('4.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 12, 'BED', TO_DATE('2.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 13, 'BED', TO_DATE('6.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 14, 'BED', TO_DATE('7.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 15, 'BED', TO_DATE('12.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 16, 'BED', TO_DATE('13.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 17, 'BED', TO_DATE('14.02.2016','DD.MM.YYYY'), 10 FROM DUAL UNION ALL
    SELECT 18, 'BED', TO_DATE('15.02.2016','DD.MM.YYYY'), 13 FROM DUAL
),
RNUMB AS (
    SELECT DENSE_RANK() OVER (ORDER BY THING, DIS) RN,
           ROW_NUMBER() OVER (PARTITION BY THING, DIS ORDER BY DAT) CNT,
           COUNT(*) OVER (PARTITION BY THING, DIS) AMNT,
           THING, DAT, DIS
    FROM SRC
),
MODI AS (
    SELECT RN, CNT, THING, DAT, NDAT, DIS
    FROM RNUMB
    MODEL
    PARTITION BY (RN)
    DIMENSION BY (CNT)
    MEASURES (THING, DAT, DIS, AMNT, DAT AS NDAT)
    RULES ITERATE (100) UNTIL (ITERATION_NUMBER >= AMNT[1]) (
        NDAT[ITERATION_NUMBER + 1] = (CASE 
                                        WHEN DAT[ITERATION_NUMBER + 1] = DAT[ITERATION_NUMBER] + 1
                                            THEN NDAT[ITERATION_NUMBER]
                                        ELSE NDAT[ITERATION_NUMBER + 1]
                                      END)
    )
),
PREP AS (
    SELECT RN, CNT, THING, (CASE 
                                WHEN DAT = NDAT THEN TO_CHAR(DAT, 'DD.MM.YYYY')
                                ELSE TO_CHAR(NDAT, 'DD.MM.YYYY') || '-' || TO_CHAR(DAT, 'DD.MM.YYYY')
                            END) DATS, DIS
    FROM MODI M 
    WHERE DAT = (SELECT MAX(DAT) 
                FROM MODI MM 
                WHERE M.THING = MM.THING AND M.DIS = MM.DIS AND M.NDAT = MM.NDAT)
)
SELECT THING "???????? ??????", LISTAGG(DATS, ', ') WITHIN GROUP(ORDER BY CNT) "???? ??????", 
       DIS "??????, %"
FROM PREP
GROUP BY RN, THING, DIS;
