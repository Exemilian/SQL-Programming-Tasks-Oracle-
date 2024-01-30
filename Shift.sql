--Condition
--Create a query to determine the following tables among the tables in your schema:
--the names of which are obtained from each other by cyclic shift of symbols.

CREATE TABLE BAA(NUM NUMBER(2));
CREATE TABLE ABA(NUM NUMBER(2));
CREATE TABLE AAB(NUM NUMBER(2));

WITH SRC AS (
    SELECT TABLE_NAME
    FROM USER_TABLES 
)
SELECT ROWNUM AS "?????", T1.TABLE_NAME AS "??????? 1", T2.TABLE_NAME AS "??????? 2"
FROM SRC T1 
INNER JOIN SRC T2 ON (LENGTH(T1.TABLE_NAME) = LENGTH(T2.TABLE_NAME))
WHERE T1.TABLE_NAME != T2.TABLE_NAME AND
      INSTR(T2.TABLE_NAME||T2.TABLE_NAME, T1.TABLE_NAME) != 0;
