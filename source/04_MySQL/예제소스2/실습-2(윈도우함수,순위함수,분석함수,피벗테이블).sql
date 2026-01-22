use sqldb;
-- 순위 매기기 row_number() over()
-- 같은 키가 존재해도 순위를 정해버린다.
select row_number() over(order by height desc) as '키 순위', username, addr, height
  from usertbl;
  
-- 같은 키가 존재하면 이름으로 순위 정해보기
select row_number() over(order by height desc, username asc) as '키 순위',
	   username, addr, height
  from usertbl;

-- rank() over(), 일반적으로 가장 많이 사용되는 순위함수 
-- 같은 키가 존재하면 동일한 등수로 만들고 동일한 등수의 수만큼 띄우고 순위를 정하기
select rank() over(order by height desc) as '키 순위', username, addr, height
  from usertbl;

-- dense_rank() over() 
-- 같은 키가 존재하면 동일한 등수로 만들고 동일한 등수의 수만큼 띄우지 않고 순위를 정하기
select dense_rank() over(order by height desc) as '키 순위', username, addr, height
  from usertbl;
  
-- over(partition by 컬럼명), 컬럼명에 따라서 그룹 지어서 그룹 안에서 순위를 정하기
select addr, username, height,
       row_number() over(partition by addr order by height desc) as '지역별 키순위'
  from usertbl;

select addr, username, height,
       rank() over(partition by addr order by height desc) as '지역별 키순위'
  from usertbl;
  
-- ntile(정수), 해당하는 row개수에 그룹으로 나누어주는 함수
select ntile(2) over(order by height desc) as '반번호', username, addr, height
  from usertbl;

select ntile(4) over(order by height desc) as '반번호', username, addr, height
  from usertbl;
  
-- 분석 함수
-- lead(컬럼명, offset, default) : 현재 row를 기준으로 다음 행을 참조
-- lag(컬럼명, offset, default) : 현재 row를 기준으로 이전 행을 참조
select username, addr, height as '키',
       height - (lead(height, 1, 0) over(order by height desc)) as '다음 사람과 키 차이'
  from usertbl;
  
select username, addr, height as '키',
       height - (lag(height, 1, 0) over(order by height desc)) as '이전 사람과 키 차이'
  from usertbl;
  
-- 지역별 최대키와 차이
-- first_value(컬럼) : 정렬된 값 중에서 첫 번째 값을 의미한다.
-- last_value(컬럼) : 정렬된 값 중에서 맨 마지막 값을 의미한다.
select addr, username, height as '키',
	   height - (first_value(height) over(partition by addr order by height desc))
       as '지역별 최대키와 차이'
  from usertbl;

-- last_value()사용할 때는 반드시 over절에 
-- rows between unbounded preceding and unbounded following : 정렬 결과의 처음과 끝을 대상으로 함.
-- “윈도우 함수가 계산할 범위를 ‘전체 파티션’으로 명시하기 위해” 필요
-- 현재 행 기준이 아니라, 그룹 전체를 범위로 계산하라는 뜻
select addr, username, height as '키',
	   height - (last_value(height) over(partition by addr order by height desc 
                 rows between unbounded preceding and unbounded following ))
       as '지역별 최소키와 차이'
  from usertbl;

 -- 누적 백분율 함수 cume_dist() : 0~1사이를 리턴을 해준다.
 select addr, username, height as '키',
        (cume_dist() over(partition by addr order by height desc)) * 100 as '누적인원 백분율'
   from usertbl;
   
-- 간단한 피벗 테이블 만들어서 실습을 해보도록 하자.
drop table if exists pivot;
create table pivot (
	uname varchar(10),
    season varchar(5),
    amount int
);

insert into pivot values 
('김범수','겨울',10),('윤종신','여름',15),
('김범수','가을',25),('김범수','봄',5),
('김범수','봄',37),('윤종신','겨울',40),
('김범수','여름',14),('김범수','겨울',22),
('김범수','겨울',22),('윤종신','여름',64);

select *
  from pivot;

-- 피벗 테이블을 만드는 첫 번째 방법(sum(), case when ... then... end)
select uname,
       sum(case when season='봄' then amount end) as '봄',
       sum(case when season='여름' then amount end) as '여름',
       sum(case when season='가을' then amount end) as '가을',
       sum(case when season='겨울' then amount end) as '겨울'
  from pivot
group by uname;

-- 피벗 테이블을 만드는 두 번째 방법(sum(), if())
-- IF(조건식, 참일 때 값, 거짓일 때 값)
select uname,
       -- 만약에 season이 봄이면 amount을 sum을 해라.
       sum(if(season='봄', amount, 0)) as '봄',
       sum(if(season='여름', amount, 0)) as '여름',
       sum(if(season='가을', amount, 0)) as '가을',
       sum(if(season='겨울', amount, 0)) as '겨울'
  from pivot
group by uname;

select season,
	   sum(if(uname='김범수', amount, 0)) as '김범수',
       sum(if(uname='윤종신', amount, 0)) as '윤종신',
       sum(amount) as '합계'
  from pivot
group by season
order by sum(amount)









  
  

