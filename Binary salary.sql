--Condition
--Assuming there are no employee salaries (Employees table),
--greater than 100,000, for each employee with more than two
--subordinates, display salary representation in decimal and binary
--number systems (without leading zeros).

WITH SRC AS (
    SELECT EMPLOYEE_ID, LAST_NAME, SALARY, BIN_SAL
    FROM EMPLOYEES
    MODEL
    PARTITION BY (EMPLOYEE_ID)
    DIMENSION BY (1 AS CNT)
    MEASURES (LAST_NAME, SALARY, SALARY AS CHKS, CAST ('' AS VARCHAR2(40)) AS BIN_SAL)
    RULES ITERATE(25) UNTIL (CHKS[1] = 0) (
        BIN_SAL[1] = TO_CHAR(MOD(CHKS[CV()], 2)) || BIN_SAL[CV()],
        CHKS[1] = TRUNC(CHKS[CV()] / 2)
    )
)
SELECT S.EMPLOYEE_ID, S.LAST_NAME, S.SALARY, S.BIN_SAL
FROM SRC S
WHERE 2 <= (SELECT COUNT(*)
            FROM EMPLOYEES E
            WHERE E.MANAGER_ID = S.EMPLOYEE_ID);
