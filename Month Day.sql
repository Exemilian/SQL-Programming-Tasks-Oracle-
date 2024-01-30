--Condition
--Using access only to the DUAL table, build an SQL query,
--returning a single column containing the calendar for a given month
--given year:
--• day number in the month (two digits),
--• full name of the month in English in capital letters (upper case),
--• year (four digits),
--• full name of the day of the week in
--English in lowercase letters (lowercase).
--Each "subfield" must be separated from the next by one space. IN
--The result should not contain leading or trailing spaces. Quantity
--The returned rows must exactly match the number of days in the current
--month. The rows should be ordered by the number of days in the month according to increasing.

UNDEFINE DAT;
DEFINE DAT = '2.-0004';
SELECT REGEXP_REPLACE(TO_CHAR(TO_DATE('&DAT', 'MM.SYYYY') + LEVEL - 1, 'DD MONTH SYYYY'), '[ ]+' , ' ') 
       || ' ' || (CASE
                    WHEN EXTRACT (YEAR FROM TO_DATE('&DAT', 'MM.SYYYY')) > 0 
                        THEN TO_CHAR(TO_DATE('&DAT', 'MM.SYYYY') + LEVEL - 1, 'DAY')
                    ELSE (CASE TO_CHAR(TO_DATE('&DAT', 'MM.SYYYY') + LEVEL - 1, 'FMDAY')
                            WHEN 'MONDAY' THEN 'WEDNESDAY'
                            WHEN 'TUESDAY' THEN 'THURSDAY'
                            WHEN 'WEDNESDAY' THEN 'FRIDAY'
                            WHEN 'THURSDAY' THEN 'SATURDAY'
                            WHEN 'FRIDAY' THEN 'SUNDAY'
                            WHEN 'SATURDAY' THEN 'MONDAY' 
                            ELSE 'TUESDAY' END)
                   END) KALENDAR
FROM DUAL
CONNECT BY TO_DATE('&DAT', 'MM.SYYYY') + LEVEL - 1 <= LAST_DAY(TO_DATE('&DAT', 'MM.SYYYY'));
