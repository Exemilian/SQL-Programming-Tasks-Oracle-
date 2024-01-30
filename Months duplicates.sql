--Condition
--For each month in which employees were hired,
--find the 3 closest months after a given “twin month”.
--“Double” months are those months that begin on the same day.
--day of the week and end on the same day of the week.
--Withdraw:
--1. Last name of the employee;
--2. The month in which the employee was hired in the format
--"mon year";
--3.-5. The three nearest “twin months” in the “mon year” format

WITH M1 AS (
    SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, M1
    FROM EMPLOYEES
    MODEL
    DIMENSION BY (EMPLOYEE_ID)
    MEASURES (LAST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 1) AS M1)
    RULES ITERATE(200) (
        M1[ANY] = 
        (CASE
            WHEN TO_CHAR(LAST_DAY(M1[CV()]),'DD') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]),'DD') AND
                 TO_CHAR(LAST_DAY(M1[CV()]), 'DY') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]), 'DY')
                 THEN M1[CV()]
            ELSE ADD_MONTHS(M1[CV()], 1)
        END)
    )
),
M2 AS (
    SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, M1, M2
    FROM M1
    MODEL
    DIMENSION BY (EMPLOYEE_ID)
    MEASURES (LAST_NAME, HIRE_DATE, M1, ADD_MONTHS(M1, 1) AS M2)
    RULES ITERATE(200) (
        M2[ANY] = 
        (CASE
            WHEN TO_CHAR(LAST_DAY(M2[CV()]),'DD') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]),'DD') AND
                 TO_CHAR(LAST_DAY(M2[CV()]), 'DY') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]), 'DY')
                 THEN M2[CV()]
            ELSE ADD_MONTHS(M2[CV()], 1)
        END)
    )
),
M3 AS (
    SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, M1, M2, M3
    FROM M2
    MODEL
    DIMENSION BY (EMPLOYEE_ID)
    MEASURES (LAST_NAME, HIRE_DATE, M1, M2, ADD_MONTHS(M2, 1) AS M3)
    RULES ITERATE(200) (
        M3[ANY] = 
        (CASE
            WHEN TO_CHAR(LAST_DAY(M3[CV()]),'DD') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]),'DD') AND
                 TO_CHAR(LAST_DAY(M3[CV()]), 'DY') = TO_CHAR(LAST_DAY(HIRE_DATE[CV()]), 'DY')
                 THEN M3[CV()]
            ELSE ADD_MONTHS(M3[CV()], 1)
        END)
    )
)
SELECT * FROM M3;
