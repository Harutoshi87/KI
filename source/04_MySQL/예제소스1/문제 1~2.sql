# 문제 1, 2
create database mydb;
use mydb;

create table dept(
	deptno int not null,
    dname varchar(14),
    loc varchar(13),
    primary key(deptno)
);

-- 만들어진 DEPT테이블에 아래의 데이터를 삽입하라
-- 10, '경리부', '서울'
-- 20, '인사부', '인천'
-- 30, '영업부', '용인'
-- 40, '전산부', '수원'
insert into dept values(10, '경리부','서울');
insert into dept values(20, '인사부','인천');
insert into dept values(30, '영업부','용인');
insert into dept values(40, '전산부','수원');

select *
  from dept;




