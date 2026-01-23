use sqldb;

-- 대용량 데이터 삽입해보기
-- 필드의 데이터타입이 longtext이다.
-- longtext는 4gb만큼 text데이터를 넣을 수 있는 것을 이미 배웠다.
drop table if exists maxtbl;
create table maxtbl(
	col1 longtext,
    col2 longtext
);
desc maxtbl;
-- 'A'문자는 1바이트이고, '신'이라는 한글은 3바이트이다.
-- 십만번을 반복해서 컬럼에다가 각각 대입한 것이다.
insert into maxtbl values (repeat('A', 100000), repeat('신', 100000));
select *
  from maxtbl;
  
select length(col1), length(col2)  -- col1은 0.95MB, col2는 0.28MB 정도가 들어가 있다.
  from maxtbl;
  
-- 분명히 longtext는 4gb저장할 수 있다고 했는데 1000만 바이트(9.5MB) 저장이 안된다고
-- 에러가 났다.이 때는 mysql에 대한 설정을 좀 바꿔줘야 한다.
-- C:\ProgramData\MySQL\MySQL Server 8.0\my.ini파일에 max_allow_packet부분이 기본적으로 
-- 4MB로 설정되어 있는 걸 확인할수 있다. 이것을 4096MB로 바꿔주면 된다.
-- 설정이 바뀌면 재부팅을 하는것이 원칙이나, cmd창을 관리자모드로 열고
-- net stop mysql을 치자. 그럼 mysql서버가 중지되고, net start mysql을 치면 서비스를 
-- 시작하여 적용이 된다.이제 아래코드를 치면 에러가 발생하지 아니한다.  
insert into maxtbl values (repeat('B', 10000000), repeat('가', 10000000));

-- 분명 4GB로 설정을 했음에도 불구하고 1GB로 max_allow_packet이 출력된다.
show variables like 'max%';  
-- my.ini파일의 변경이 있다면, mysql서비스를 중단하고 재시작하는 행위가 필요하다.
show variables like 'secure%';  

-- 테이블의 내용을 텍스트 파일 내보내기
select *
  from usertbl
  into outfile 'C:\\SQL\\Movies\\usertbl_copy.txt' character set utf8mb4
  fields terminated by ',' optionally enclosed by '"'
  escaped by '\\'
  lines terminated by '\n';
  -- FIELDS TERMINATED BY → 컬럼 구분자
  -- OPTIONALLY ENCLOSED BY → 문자열 보호용 따옴표
  -- ESCAPED BY → 특수문자 탈출
  -- LINES TERMINATED BY → 행 끝 표시
  -- id,name,addr,height\n
  -- kim,"서울,강남",180\n
  -- park,"부산 \"해운대\"",175\n
  -- , → 컬럼 구분
  -- " → 문자열 감쌈
  -- \" → 따옴표 자체
  -- \n → 행 종료
  
-- 테이블의 내용을 csv 파일로 내보내기
select *
  from employees.employees
  into outfile 'C:\\SQL\\Movies\\employees_copy.csv' character set utf8mb4
  fields terminated by ',' optionally enclosed by '"'
  escaped by '\\'
  lines terminated by '\n';
  
-- 외부의 데이터를 가져와보자. 먼저 테이블 생성하도록 하자.
drop table if exists membertbl;
-- ★like를 활용하면 테이블의 구조뿐만 아니라 제약조건까지 다 복사해온다.★
create table membertbl like usertbl;

desc membertbl;
select *
  from membertbl;

-- 외부 텍스트파일을 테이블로 읽어들이기
load data infile 'C:\\SQL\\Movies\\usertbl_copy.txt'
	into table membertbl character set utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by '\n';
-- ignore 1 rows; -- ★제목줄이 있을 때 1행을 무시하고 테이블에 행을 저장해라.★

truncate membertbl;

select *
  from membertbl;
  
-- 엑셀파일을 읽어들이기 위한 테이블 생성
drop table if exists employees_test;
create table employees_test like employees.employees;
desc employees_test;
select *
  from employees_test;
  
-- 외부 엑셀 파일을 테이블에 읽어들이기  
load data infile 'C:\\SQL\\Movies\\employees_copy.csv'
	into table employees_test character set utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows; -- 제목줄이 있을때 1행을 무시하고 테이블에 행을 저장해라.

select *
  from employees_test;

-- 위에서 파일을 내보내고, 테이블로 읽어들이기 등 정말 중요하다.(현업 사용 多)
-- 명령어를 잘 이해하고 사용할 것.

drop database moviedb;
create database moviedb;

use moviedb;
-- 동영상(바이너리 파일)과 시나리오를 저장하기 위한 테이블 생성함
drop table if exists movietbl;
create table movietbl(
	movie_id int auto_increment primary key,
    movie_title varchar(30),
    movie_director varchar(20),
    movie_star varchar(20),
    movie_script longtext,
    movie_film longblob
) default charset=utf8mb4;

desc movietbl;


-- 쿼리를 날린 후에, Lost Connection to Mysql Server during query에러가 뜰 때가 있다.
-- 이 에러를 해결하기 위해서는 Edit-> Preferences -> SQL Editor -> DBMS connection read time out의 값에
-- 3,600초(1시간)를 설정을 해주면 에러가 해결될 것이다.

-- 텍스트 파일, 동영상을 테이블 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1',
  load_file('C:\\SQL\\Movies\\Mohikan.txt'),load_file('C:\\SQL\\Movies\\test.mp4'));

-- 아래와 같이 한글로 된 파일명을 주면 테이블에 저장이 되질 않으므로 영문으로 이름을
-- 바꿔서 업로드를 하도록 하자.
-- insert into movietbl values (null, 'mysql2', 'oracle2', '대표2',
--  load_file('C:\\SQL\\Movies\\모히칸.txt'),load_file('C:\\SQL\\Movies\\테스트.mp4'));


-- 텍스트 파일, 한글파일(.docx)을 테이블 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1',
  load_file('C:\\SQL\\Movies\\Mohikan.txt'),load_file('C:\\SQL\\Movies\\dbms.docx'));

-- 텍스트 파일, 엑셀파일(.csv)을 테이블 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1',
  load_file('C:\\SQL\\Movies\\Mohikan.txt'),load_file('C:\\SQL\\Movies\\employees_copy.csv'));

-- 텍스트 파일, 이미지파일(.png)을 테이블 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1',
  load_file('C:\\SQL\\Movies\\Mohikan.txt'),load_file('C:\\SQL\\Movies\\mysql_logo.png'));

select *
  from movietbl;
  
-- 동영상 다운받기
select movie_film 
  from movietbl
 where movie_id = 1
 into dumpfile 'C:\\SQL\\Movies\\test_copy.mp4';
 
 -- 한글파일 다운받기
select movie_film 
  from movietbl
 where movie_id = 3
 into dumpfile 'C:\\SQL\\Movies\\dbms_copy.docx';

 -- 엑셀파일 다운받기
select movie_film 
  from movietbl
 where movie_id = 4
 into dumpfile 'C:\\SQL\\Movies\\employees_copy.csv';
 
-- 이미지 파일 다운받기
select movie_film 
  from movietbl
 where movie_id = 5
 into dumpfile 'C:\\SQL\\Movies\\mysql_logo_copy.png';

-- optimize table 테이블명 : 대량의 데이터를 삭제를 했던가, 테이블에 잦은 변화가 있을 경우
-- 사용하면 유용하다.미사용 영역을 해제해주고, 데이터 파일을 최적화할 수가 있다.
optimize table movietbl;








