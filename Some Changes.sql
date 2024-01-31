--Condition
--A table with columns Number – Number and Amount – Number is specified.
--A positive value in the second column indicates the amount that came to the account,
--and a negative value indicates an adjustment (reduction) of previous receipts. 
--You need to write a request that will determine the amounts taking into account adjustments.

WITH SRC AS(
    SELECT 1 N, 100 SUMM FROM DUAL
    UNION ALL
    SELECT 2 N, 300 SUMM FROM DUAL
    UNION ALL
    SELECT 3 N, 200 SUMM FROM DUAL
    UNION ALL
    SELECT 4 N, 100 SUMM FROM DUAL
    UNION ALL
    SELECT 5 N, -350 SUMM FROM DUAL
    UNION ALL
    SELECT 6 N, 100 SUMM FROM DUAL
    UNION ALL
    SELECT 8 N, 100 SUMM FROM DUAL
    UNION ALL
    SELECT 9 N, -300 SUMM FROM DUAL
    UNION ALL
    SELECT 10 N, 800 SUMM FROM DUAL
    UNION ALL
    SELECT 11 N, -600 SUMM FROM DUAL
),
REV AS (
    SELECT ROWNUM RN, N, SUMM
    FROM(SELECT ROWNUM R, N, SUMM 
         FROM SRC
         ORDER BY R DESC)
),
MODI AS (
    SELECT RN,N, SUMM S, OST, RESULTS 
    FROM REV
    MODEL
    DIMENSION BY(RN)
    MEASURES(SUMM, CAST(0 AS NUMBER(10)) OST,N, CAST(0 AS NUMBER(10)) RESULTS)
    RULES(
        OST[1]= (CASE WHEN SUMM[CV()] > 0 THEN 0 ELSE SUMM[CV()] END),
        RESULTS[1] = SUMM[CV()] - OST[CV()],
        OST[RN>1]= (CASE 
                        WHEN SUMM[CV()] + OST[CV() - 1] < 0
                            THEN SUMM[CV()]+OST[CV()-1] 
                        ELSE 0 
                    END),
        RESULTS[RN>1] = (CASE 
                            WHEN SUMM[CV()] + OST[CV() - 1] < 0
                                THEN 0
                            ELSE SUMM[CV()]+OST[CV()-1]  
                        END)
    )
)
SELECT N, S SUMM, RESULTS 
FROM (SELECT RN, N, S, RESULTS
      FROM MODI
      ORDER BY 1 DESC);
