--Condition
--For each department from the Departments table, display as one row with
--a comma as a separator for the last names of employees working in it. Surnames
--employees should be sorted alphabetically. Solve the problem without
--using the Listagg and wm_concat functions.

WITH SRC AS (
    SELECT ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID ORDER BY LAST_NAME) RN,
           DEPARTMENT_ID, LAST_NAME
    FROM EMPLOYEES
)
SELECT NVL(TO_CHAR(DEPARTMENT_ID), '??? ??????') DEPARTMENT_ID,
       LTRIM(SYS_CONNECT_BY_PATH(LAST_NAME, ', '), ', ') NAME_LIST
FROM SRC
WHERE CONNECT_BY_ISLEAF = 1
START WITH RN = 1
CONNECT BY PRIOR RN = RN - 1 AND (PRIOR DEPARTMENT_ID = DEPARTMENT_ID OR 
           PRIOR DEPARTMENT_ID IS NULL AND DEPARTMENT_ID IS NULL);
