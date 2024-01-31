--Condition
--For each department, display the names and salaries of three employees,
--receiving the highest salaries in the department. If the lowest salary

WITH SRC AS ( 
    SELECT DEPARTMENT_ID, LAST_NAME, SALARY,
           RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) RK,
           DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) DR
    FROM EMPLOYEES
)
SELECT NVL(TO_CHAR(DEPARTMENT_ID), 'No dep') DEPARTMENT_ID,
       LAST_NAME, SALARY
FROM SRC
WHERE RK <= 3 AND DR <= 3;
