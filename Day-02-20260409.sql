
-- 이것슨 주석표시입니다.
SELECT * FROM fms.chick_info;

SET search_path TO fms;

SELECT chick_no AS "Chick Num", breeds "품종" FROM chick_info;

SELECT now();

SELECT now() + INTERVAL '1 hour';

SELECT count(*) FROM fms.chick_info;

SELECT count(distinct(breeds)) FROM fms.chick_info; 

SELECT chick_no, hatchday, egg_weight FROM fms.chick_info ORDER BY egg_weight DESC, hatchday ASC, chick_no LIMIT 5 OFFSET 3;

SELECT * FROM fms.chick_info WHERE egg_weight >= 68;

-- 닭알의 무게가 65 이상이면서 69미만인 것들만 필터링
SELECT * FROM fms.chick_info WHERE egg_weight >= 65 AND egg_weight < 69;

-- 닭알의 무게가 65 이상이면서 69미만인 것들만 필터링, 무거운순으로 나열
SELECT * FROM fms.chick_info WHERE egg_weight >= 65 AND egg_weight < 69 ORDER BY egg_weight desc;

-- 부화날짜가 1월 1일 부터 1월 2일 사이인 닭알들만 필터링
SELECT * from fms.chick_info WHERE hatchday BETWEEN '2023-01-01' AND '2023-01-02';

SELECT * from fms.chick_info WHERE hatchday = '2023-01-01' or hatchday ='2023-01-02';

SELECT * from fms.chick_info WHERE breeds in('C1', 'C2');

SELECT * from fms.chick_info WHERE breeds LIKE 'C%';

SELECT * from fms.chick_info WHERE breeds IS NOT NULL;

SELECT * from fms.health_cond WHERE note IS NOT NULL;

-- env_cond 에서 습도가 측정되지 않은 데이터 조회
select * from fms.env_cond where humid is NULL;

-- 출하실적테이블에서 도착지가 부산 혹은 울산인 기록 조회
SELECT * from fms.ship_result WHERE breeds in('부산', 'C2');

-- A2310002
SELECT 
    chick_no, 
    LEFT(chick_no, 1) AS "출신농장",
    '20' || SUBSTRING(chick_no, 2, 2) AS "출생년도",
    SUBSTRING(chick_no, 4, 1) AS "성별",
    RIGHT(chick_no, 4) AS "일련번호"
FROM fms.chick_info 
LIMIT 5;

SELECT chick_no, replace(gender, 'M', 'Male')
FROM fms.chick_info 
LIMIT 5;

-- gender에서 M -> 'Male', F-> 'Female', 성별
SELECT chick_no, REPLACE(replace(gender, 'M', 'Male'), 'F', 'Female') "성별"
FROM fms.chick_info 
LIMIT 5;


SELECT breeds,
count(*),
sum(egg_weight),
avg(egg_weight),
min(egg_weight),
max(egg_weight)
FROM fms.chick_info
GROUP BY breeds;

-- ship_result 고객사별 출하 마릿수 
SELECT customer, count(*)
FROM fms.ship_result
GROUP BY customer;
-- prod_result 생산일자별 생닭의 무게의 합계
SELECT prod_date, sum(raw_weight)
FROM fms.prod_result
GROUP BY prod_date 
ORDER BY prod_date;

SELECT customer, count(*)
FROM fms.ship_result
GROUP BY customer
HAVING count(*) >= 10;

-- arrival_date가 2023-02-05 부터 고객사별로 출하량 중 8개 이상인 고개사만 보여주세요
SELECT customer, count(*)
FROM fms.ship_result
WHERE arrival_date >= '2023-02-05'
GROUP BY customer
HAVING count(*) >= 8
ORDER BY customer;

SELECT now();

SELECT to_char(timestamp '2026-02-01', 'Mon');

-- hatchday, 요일, 병아리들이 태어난 요일만 보여주세요. 
SELECT hatchday, to_char(hatchday, 'Dy')
FROM fms.CHICK_INFO;

SELECT farm, date, humid, nullif(humid, 60)
FROM fms.ENV_COND;

SELECT chick_no, egg_weight,
CASE
	WHEN egg_weight > 69 THEN 'L'
	WHEN egg_weight > 65 THEN 'M'
	ELSE 'S'
END
FROM fms.CHICK_INFO;
