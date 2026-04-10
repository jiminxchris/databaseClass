
SELECT PROD_DATE , raw_weight
FROM fms.PROD_RESULT;

SELECT PROD_DATE , sum(raw_weight)
FROM fms.PROD_RESULT
GROUP BY PROD_DATE;

SELECT m.code_desc, c.CHICK_NO
FROM fms.MASTER_CODE m, fms.CHICK_INFO c
WHERE m.column_nm = 'breeds'
AND m.code = c.BREEDS;

SELECT p.prod_date,
(
	SELECT m.code_desc
	FROM fms.MASTER_CODE m
	WHERE m.column_nm = 'breeds'
	AND m.code = c.BREEDS
),
sum(p.raw_weight)
FROM fms.PROD_RESULT p,
fms.CHICK_INFO c
WHERE p.CHICK_NO = c.CHICK_NO
GROUP BY p.PROD_DATE, c.BREEDS;

SELECT p.PROD_DATE,m.CODE_DESC,sum(p.RAW_WEIGHT)
FROM fms.PROD_RESULT p
JOIN fms.CHICK_INFO c
ON p.CHICK_NO = c.CHICK_NO 
JOIN fms.MASTER_CODE m
ON c.BREEDS = m.CODE 
AND m.COLUMN_NM ='breeds' 
GROUP BY p.PROD_DATE, m.CODE_DESC;


SELECT *
FROM fms.BREEDS_PROD;


-- 뷰 테이블
SELECT
a.prod_date,
(
	SELECT m.code_desc "breeds_nm"
	FROM fms.master_code m
	WHERE m.column_nm = 'breeds'
	AND m.code = b.breeds
),
sum(a.raw_weight) "total_sum"
FROM
	fms.prod_result a,
	fms.chick_info b
WHERE
	a.chick_no = b.chick_no
GROUP BY a.prod_date, b.breeds;


SELECT
a.prod_date, b.breeds,
(
	SELECT m.code_desc "breeds_nm"
	FROM fms.master_code m
	WHERE m.column_nm = 'breeds'
	AND m.code = b.breeds
),
sum(a.raw_weight) "total_sum"
FROM
	fms.prod_result a,
	fms.chick_info b
WHERE
	a.chick_no = b.chick_no
GROUP BY a.prod_date, b.breeds;


SELECT m.code, m.code_desc "breeds_nm"
FROM fms.master_code m
WHERE m.column_nm = 'breeds';
-- AND m.code = b.breeds

SELECT m.code, m.code_desc "breeds_nm", b.breeds
FROM fms.master_code m, fms.chick_info b
WHERE m.column_nm = 'breeds'
AND m.code = b.breeds;


SELECT to_char(PROD_DATE, 'YYYYMM'),
sum(CASE WHEN BREEDS_NM='Cornish' THEN TOTAL_SUM ELSE 0 END) AS "Cornish_Total",
sum(CASE WHEN BREEDS_NM='Cochin' THEN TOTAL_SUM ELSE 0 END) AS "Cochin_Total",
sum(CASE WHEN BREEDS_NM='Brahma' THEN TOTAL_SUM ELSE 0 END) AS "Brahma_Total",
sum(CASE WHEN BREEDS_NM='Dorking' THEN TOTAL_SUM ELSE 0 END) AS "Dorking_Total",
sum(TOTAL_SUM) AS monthly_total
FROM fms.breeds_prod
GROUP BY to_char(PROD_DATE, 'YYYYMM');

SELECT * FROM fms.breeds_prod;

-- daily_shipment_summary 뷰 만들어보기
CREATE OR REPLACE VIEW fms.daily_shipment_summary(
ship_date, customer_nm, breeds_nm, total_no, total_chicks)
as
SELECT s.ARRIVAL_DATE AS ship_date, 
s.CUSTOMER AS customer_nm, 
m.CODE_DESC AS breeds_nm, 
count(DISTINCT(s.ORDER_NO)) AS total_no, 
count(s.CHICK_NO) AS total_chicks
FROM fms.SHIP_RESULT s
JOIN fms.CHICK_INFO c
ON s.CHICK_NO = c.CHICK_NO 
JOIN fms.MASTER_CODE m
ON c.BREEDS = m.CODE 
AND m.COLUMN_NM ='breeds'
GROUP BY s.ARRIVAL_DATE, s.CUSTOMER, m.CODE_DESC;

SELECT *
FROM fms.daily_shipment_summary
WHERE customer_nm = 'YESYES';


SELECT HATCHDAY,
sum(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male,
sum(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female
FROM fms.CHICK_INFO
GROUP BY hatchday;


CREATE EXTENSION IF NOT EXISTS tablefunc;

crosstab()

SELECT chick_no, 'body_temp' AS health, body_temp AS cond
FROM fms.health_cond
union
SELECT chick_no, 'breath_rate' AS health, breath_rate AS cond
FROM fms.health_cond
union
SELECT chick_no, 'feed_intake' AS health, feed_intake AS cond
FROM fms.health_cond;

SELECT chick_no,
unnest(ARRAY['body_temp', 'breath_rate', 'feed_intake']) AS health,
unnest(ARRAY[body_temp,breath_rate, feed_intake ]) AS cond
FROM fms.health_cond;

INSERT INTO fms.master_code
VALUES 
('breeds', 'txt', 'A1', 'Aoss'),
('breeds', 'txt', 'B1', 'Boss'),
('breeds', 'txt', 'C1', 'Coss');

SELECT * FROM fms.master_code WHERE column_nm = 'breeds';

UPDATE fms.master_code
SET code_desc = '암컷'
WHERE column_nm = 'gender' AND code = 'F';

UPDATE fms.env_cond
SET humid = 60
WHERE humid IS null AND farm = 'A';

SELECT * FROM fms.master_code WHERE column_nm = 'gender';

DELETE FROM fms.MASTER_CODE
WHERE code = 'A1';
DELETE FROM fms.MASTER_CODE
WHERE code = 'B1';


CREATE OR REPLACE FUNCTION one()
RETURNS integer AS $$
	select 1;
$$ LANGUAGE SQL;

select one();

CREATE OR REPLACE FUNCTION one_plpgsql()
RETURNS integer AS $$
begin
	return 1;
end;
$$ LANGUAGE plpgsql;

select one_plpgsql();

CREATE OR REPLACE FUNCTION one_plpgsql2()
RETURNS integer AS $$
declare
	result_val integer;
begin
	select 1 into result_val;
	return result_val;
end;
$$ LANGUAGE plpgsql;

select one_plpgsql2();

-- a, b -> a + b
CREATE OR REPLACE FUNCTION add_a_b(a integer, b integer)
RETURNS integer AS $$
	select a + b;
$$ LANGUAGE SQL;

SELECT add_a_b(3, 4);

CREATE OR REPLACE FUNCTION add_a_b_plpgsql(a integer, b integer)
RETURNS integer AS $$
begin
	return a + b;
end;
$$ LANGUAGE plpgsql;

SELECT add_a_b_plpgsql(5, 4);


SELECT EGG_WEIGHT
FROM fms.CHICK_INFO
WHERE chick_no = 'A2310001';

-- A2310001 -> 65
SELECT get_chickweight('A2310003'); -- 65

CREATE OR REPLACE FUNCTION get_chickweight(chick_no varchar)
RETURNS integer AS $$
	SELECT EGG_WEIGHT
	FROM fms.CHICK_INFO
	WHERE CHICK_INFO.chick_no = get_chickweight.chick_no;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION my_func(in_val integer)
RETURNS table(f1 int, f2 text) AS $$
	select in_val, in_val::text || ' is text' ;
$$ LANGUAGE SQL;

SELECT * from my_func(100);


CREATE OR REPLACE FUNCTION get_chickinfo_table()
RETURNS table(chick_no varchar, egg_weight integer) AS $$
	select chick_no, egg_weight from fms.chick_info;
$$ LANGUAGE SQL;

SELECT * from get_chickinfo_table();

select chick_no, egg_weight from fms.chick_info;

CREATE OR REPLACE VIEW fms.view_farm_ship_summary AS
SELECT 
ci.farm,
sr.customer,
COUNT(*) AS shipped_count
FROM fms.prod_result pr
JOIN fms.chick_info ci ON pr.chick_no = ci.chick_no
JOIN fms.ship_result sr ON pr.chick_no = sr.chick_no
WHERE pr.pass_fail = 'P'
GROUP BY ci.farm, sr.customer;

SELECT * FROM fms.view_farm_ship_summary
WHERE farm='B';

-- 위의 뷰를 함수로 
CREATE OR REPLACE FUNCTION fms.get_farm_ship_summary(farm_param VARCHAR)
RETURNS table(
fram varchar,
customer varchar,
shipped_count integer
) AS $$
	SELECT 
	ci.farm,
	sr.customer,
	COUNT(*) AS shipped_count
	FROM fms.prod_result pr
	JOIN fms.chick_info ci ON pr.chick_no = ci.chick_no
	JOIN fms.ship_result sr ON pr.chick_no = sr.chick_no
	WHERE pr.pass_fail = 'P'
		and ci.farm = farm_param
	GROUP BY ci.farm, sr.customer;
$$ LANGUAGE SQL;

SELECT * FROM fms.get_farm_ship_summary('B');


SELECT *
FROM fms.MASTER_CODE
WHERE code = 'R1';

-- 미션 
-- 1
SELECT chick_no, raw_weight,
  CASE 
    WHEN raw_weight < 1000 THEN 'S'
    WHEN raw_weight BETWEEN 1000 AND 1100 THEN 'M'
    ELSE 'L' 
  END AS grade
FROM fms.prod_result;

-- 2
SELECT * FROM fms.chick_info 
WHERE farm='A' AND gender='M'
UNION
SELECT * FROM fms.chick_info 
WHERE farm='B' AND gender='F';

-- 3
SELECT chick_no, TO_CHAR(hatchday, 'YYYY년 MM월 DD일') 
FROM fms.chick_info;

-- 4
SELECT s.* 
FROM fms.ship_result s
JOIN fms.prod_result p ON s.chick_no = p.chick_no
WHERE s.destination = '부산' AND p.pass_fail = 'P';

-- 5
CREATE VIEW fms.breeds_stats AS
SELECT breeds, COUNT(*) AS total, AVG(raw_weight) AS avg_weight
FROM fms.prod_result p
JOIN fms.chick_info c ON p.chick_no = c.chick_no
GROUP BY breeds;

-- 6
SELECT chick_no, 
  CASE SUBSTR(chick_no,1,1)
    WHEN 'A' THEN 'A농장'
    WHEN 'B' THEN 'B농장'
  END AS farm_name
FROM fms.chick_info;

-- 7
SELECT h.chick_no,
  CASE 
    WHEN body_temp > 45 THEN '위험'
    WHEN body_temp > 41 THEN '주의' 
    ELSE '정상'
  END AS status
FROM fms.health_cond h
WHERE check_date = '2023-01-30';

-- 병아리 생산 합격률 계산
SELECT c.farm,
       COUNT(CASE WHEN p.pass_fail = 'P' THEN 1 END) * 100.0 / COUNT(*) AS pass_rate
FROM fms.prod_result p
JOIN fms.chick_info c ON p.chick_no = c.chick_no
GROUP BY c.farm;

-- 평균보다 체온 높은 병아리와 해당 농장명
SELECT h.chick_no, h.body_temp, c.farm
FROM fms.health_cond h
JOIN fms.chick_info c ON h.chick_no = c.chick_no
WHERE h.body_temp > (
    SELECT AVG(body_temp)
    FROM fms.health_cond
);

-- 특정 농장 생산 합격 생닭 제품의 출하 목적지 별 합계 보기
CREATE OR REPLACE VIEW fms.view_farm_ship_summary AS
SELECT 
    ci.farm,
    sr.customer,
    COUNT(*) AS shipped_count
FROM fms.prod_result pr
JOIN fms.chick_info ci ON pr.chick_no = ci.chick_no
JOIN fms.ship_result sr ON pr.chick_no = sr.chick_no
WHERE pr.pass_fail = 'P'
GROUP BY ci.farm, sr.customer;

SELECT * 
FROM fms.view_farm_ship_summary
WHERE farm = 'A';

-- 날짜별 농장별 생산 마릿수 시각화
SELECT
    prod_date,
    SUM(CASE WHEN farm = 'A' THEN 1 ELSE 0 END) AS "Farm A",
    SUM(CASE WHEN farm = 'B' THEN 1 ELSE 0 END) AS "Farm B",
    SUM(CASE WHEN farm = 'C' THEN 1 ELSE 0 END) AS "Farm C"
FROM (
    SELECT pr.prod_date, ci.farm
    FROM fms.prod_result pr
    JOIN fms.chick_info ci ON pr.chick_no = ci.chick_no
) AS sub
GROUP BY prod_date
ORDER BY prod_date;



