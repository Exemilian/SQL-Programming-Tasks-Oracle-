--Condition
--Create a table to store the product catalog:
--create table catalog(text varchar2(4000));
--where text is information about products, specified in the format:
--Product code1/Product type1-Product name1:Product price1;Code
--product2/Product type2-Product name2:Product price2;Code
--product3/Product type3-Product name3:Product price3;...;Code
--productN/Product typeN-
--Product nameN:Product priceN
--Requirements for the format of product information:
-- - Products are separated by semicolons, after the last product there is a period no comma;
-- - The product code is separated by a slash symbol and has a length from 1 to 6 characters, only numbers are allowed;
-- - The product type has a non-fixed length, separated by a symbol “minus” (with an en dash), contains any characters;
-- - The product name has an unfixed length and is separated colon, contains any characters;
-- - The price of a product may have a fractional value, but it may be an integer and the fractional part can be separated by a period or a comma;
-- - In the code, type, name, price, presence is unacceptable any of the following delimiter characters (characters not allowed semicolon, slash, minus, colon).
--Fill out the table with product data:
--insert into catalog values ??('125/refrigerator-Indesit SB200
--T:17999.99;50/microwave-Samsung MT479:7499.99;103320/teakettle-Bosch
--TWK189:4890.32');
--insert into catalog values ??('05/pan-
--Tefal 040 80:849.00;125/pan-Tefal E20
--60:3599.2;434031/iron-Braun Texstyle 535:5490.01');
--commit;
--In one SQL Query you need to display a table of products,
--sorted by ascending product code, then by product type.

WITH HELPER AS (
    SELECT DISTINCT REGEXP_SUBSTR(TEXT, '[^;]+', 1, LEVEL) TXT1
    FROM CATALOG 
    CONNECT BY REGEXP_SUBSTR(TEXT, '[^;]+', 1, LEVEL) IS NOT NULL
)
SELECT LPAD(SUBSTR(TXT1, 1, INSTR(TXT1, '/') - 1), 6, 0) "??? ??????",
       INITCAP(SUBSTR(TXT1, INSTR(TXT1, '/') + 1, INSTR(TXT1, '-') - INSTR(TXT1, '/') - 1)) "??? ??????",
       SUBSTR(TXT1, INSTR(TXT1, '-') + 1, INSTR(TXT1, ':') - INSTR(TXT1, '-') - 1) "???????????? ??????",
       TO_NUMBER(REPLACE(SUBSTR(TXT1, INSTR(TXT1, ':') + 1), ',', '.')) "???? ??????"
FROM HELPER
ORDER BY 1, 2;
