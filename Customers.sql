--Create a Customers table containing 2 columns: Id number(15,0)
--Primary Key and Last_Name varchar2 (40). Create a request that will
--display the value of the Id column and the Group Number of consecutive integers
--values ??with a step of 1. Solve the problem without using analytical functions using the Model section.

WITH SRC AS (
    SELECT 1 ID, 'Mougus' LAST_NAME FROM DUAL
    UNION ALL
    SELECT 2, 'Green' FROM DUAL
    UNION ALL
    SELECT 3, 'Grase' FROM DUAL
    UNION ALL
    SELECT 7, 'Scott' FROM DUAL
    UNION ALL
    SELECT 8, 'Trumen' FROM DUAL
    UNION ALL
    SELECT 10, 'Kochar' FROM DUAL
    UNION ALL
    SELECT 12, 'Drej' FROM DUAL
    UNION ALL
    SELECT 13, 'Kek' FROM DUAL
),
SR AS (
    SELECT ID
    FROM SRC
    ORDER BY ID
),
PREP AS (
    SELECT ROWNUM RN, ID
    FROM SR
)
SELECT ID, VAL "????? ??????"
FROM PREP
MODEL
DIMENSION BY (RN)
MEASURES (ID, CAST (1 AS NUMBER(15, 0)) AS VAL)
RULES (
    VAL[RN > 1] = (CASE 
                        WHEN ID[CV() - 1] = ID[CV()] - 1 THEN VAL[CV() - 1]
                        ELSE VAL[CV() - 1] + 1
                  END)
);
