--Condition
--With one SELECT command, display a list of company employees who have
--the lowest salary among employees of the department in which they
--are working. Information about employees for whom the company division to which they are assigned is unknown does not need to be displayed.
--The result is:
--1.Identifier of the company division to which you are assigned
--employee.
--2.Employee's last name.
--3. Salary established for the employee.
--In the SELECT command it is prohibited to use: Phrases WITH, GROUP BY, HAVING, ORDER BY, CONNECT BY,
--START WITH, Conditions IN, =ANY, =SOME, NOT IN, <> ALL, EXISTS, NOT EXISTS,
--Subqueries, including subqueries in the FROM clause, Hierarchical queries,
--Aggregate functions – MIN, MAX, SUM, COUNT, AVG, etc. Analytical functions

SELECT DEPARTMENT_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
MINUS
SELECT E1.DEPARTMENT_ID, E1.LAST_NAME, E1.SALARY
FROM EMPLOYEES E1 
JOIN EMPLOYEES E2 ON (E1.SALARY > E2.SALARY AND E1.DEPARTMENT_ID = E2.DEPARTMENT_ID);
