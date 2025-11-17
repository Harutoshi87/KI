-- [IV] DDL, DCL, DML(Create Read Update Delete)
/*
(1) DCL (Data Control Language ; 데이터베이스 사용자의 권한 제어):
    사용자 계정 생성 CREATE USER, GRANT(권한 부여)
    권한 박탈       REVOKE       DROP USER(사용자 계정 삭제)
    TRANSACTION 명령어(COMMIT, ROLLBACK)    
(2) DDL (Data Definition Language ; 데이터와 그 구조를 정의):
    테이블 생성 CREATE TABLE, 테이블 구조 변경 ALTER TABLE, 테이블 삭제 DROP TABLE
(3) DML (Data Manipulation Language ; 데이터 검색, 수정 등): CRUD
    입력 INSERT, 검색 SELECT, 수정 UPDATE, 삭제 DELETE - DML은 취소 가능 */

----------------
--- ★ DDL ★ ---
----------------
-- 1. 테이블 생성(CREATE TABLE 테이블명...) : 테이블의 구조를 정의
    -- ORACLE 타입들 : NUMBER(38이하의 자릿수), DATE, VARCHAR2(4000 이하의 바이트 수), CLOB
CREATE TABLE BOOK(
    BOOKID NUMBER(4),       -- BOOKID 필드의 타입은 숫자 4자리
    BOOKNAME VARCHAR2(20),  -- BOOKNAME 필드의 타입은 문자 20바이트(한글 1자 = 3바이트)
    PUBLISHER VARCHAR2(20),
    RDATE     DATE,         -- RDATE 필드의 타입은 DATE형(날짜+시간)
    PRICE     NUMBER(8,2),   -- PRICE 필드의 타입은 숫자 전체 8자리 중 소수점 2자리
    PRIMARY KEY(BOOKID)     -- 제약 조건 : BOOKID를 PRIMARY KEY(주키) 필드로
); -- 한 번만 실행
SELECT * FROM BOOK;
DESC BOOK;
DROP TABLE BOOK; -- 2. 테이블 삭제(DROP TABLE 테이블명)
CREATE TABLE BOOK(
    BOOKID NUMBER(4) PRIMARY KEY, -- BOOKID 필드의 타입은 숫자 4자리
    BOOKNAME VARCHAR2(20),        -- BOOKNAME 필드의 타입은 문자 20바이트(한글 1자 = 3바이트)
    PUBLISHER VARCHAR2(20),
    RDATE     DATE,               -- RDATE 필드의 타입은 DATE형(날짜+시간)
    PRICE     NUMBER(8,2)         -- PRICE 필드의 타입은 숫자 전체 8자리 중 소수점 2자리
);
SELECT * FROM EMP; -- 10, 20, 30부서
SELECT * FROM DEPT; -- 10, 20, 30, 40 부서
INSERT INTO EMP VALUES(7369, '홍길동', NULL, NULL, NULL, NULL, NULL, 40);
-- DEPT와 유사한 DEPT01 테이블 생성 : 
-- DEPTNO(수2-PRIMARY KEY), DNAME(문14), LOC(문13)
CREATE TABLE DEPT01(
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13)
);
INSERT INTO DEPT01 VALUES (10, '전산실', '신림');
SELECT * FROM DEPT01;
ROLLBACK; -- DML 취소하는 DCL
-- EMP와 유사한 EMP01 테이블 생성 : 
-- EMPNO(수4-PK), ENAME(문10), HIREDATE(날), SAL(수7,2), DEPTNO(수2-FOREIGN KEY)
CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10),
    HIREDATE DATE,
    SAL NUMBER(7, 2), -- 소수점 앞 5자리, 소수점 뒤 2자리. 총 7자리
    DEPTNO NUMBER(2) REFERENCES DEPT01(DEPTNO) -- FOREIGN KEY(외래키) 제약 조건
); -- DEPT01는 EMP01의 부모 테이블
DROP TABLE EMP01;
CREATE TABLE EMP01(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10),
    HIREDATE DATE,
    SAL NUMBER(7, 2), -- 소수점 앞 5자리, 소수점 뒤 2자리. 총 7자리
    DEPTNO NUMBER(2), -- FOREIGN KEY(외래키) 제약 조건
    PRIMARY KEY(EMPNO),
    FOREIGN KEY(DEPTNO) REFERENCES DEPT01
);
INSERT INTO EMP01 VALUES(1987, '김동준', SYSDATE, 9999, 10);
COMMIT; -- TRANSACTION 영역에 쌓여 있는 DML 명령어들을 ORACLE에 일괄 적용하는 DCL
SELECT * FROM EMP01;

----------------
--- ★ DML ★ ---
----------------
-- 1. 
   -- (1) INSERT INTO 테이블명 (필드명1, 필드명2, ...) VALUES (값1, 값2, ...);
   -- (2) INSERT INTO 테이블명 VALUES  (값1, 값2, ..., 값N);
SELECT * FROM DEPT01;
INSERT INTO DEPT01 VALUES (50, 'ACCOUNTING', 'SEOUL');
INSERT INTO DEPT01 (DEPTNO, LOC, DNAME) VALUES (60, '신림', '개발');
INSERT INTO DEPT01 (DEPTNO, LOC, DNAME) VALUES (70, NULL, '영업'); -- 명시적으로 NULL 입력
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES (80, '연구'); -- 묵시적으로 NULL 입력
SELECT * FROM DEPT01;
-- SUB QUERY를 이용한 INSERT
    --EX. DEPT 테이블의 20~40 부서의 내용을 DEPT01 테이블에 INSERT
    INSERT INTO DEPT01 SELECT * FROM DEPT WHERE DEPTNO > 10;

-- ※ PDF 1PAGE (교안 4PAGE) 연습문제
/* 다음과 같은 구조로 SAM01 테이블을 생성하시오. 
같은 이름의 테이블이 존재할 수 있으니 , DROP TABLE 로 삭제 후 생성하시오
- SAM01 의 구조 (EMPNO 를 주키로)
• EMPNO( 사번 ) NUMBER(4)
• ENAME( 이름 ) VARCHAR2(10)
• JOB( 직책 ) VARCHAR2(9)
• SAL( 급여 ) NUMBER(7,2)
*/
-- 테이블 삭제
DROP TABLE SAM01;
-- 테이블 생성
CREATE TABLE SAM01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    SAL NUMBER(7, 2)
);
SELECT * FROM SAM01;
-- 한 행씩 INSERT
INSERT INTO SAM01 VALUES (1000, 'APPLE', 'POLICE', 10000);
INSERT INTO SAM01 VALUES (1010, 'BANANA', 'NURSE', 15000);
INSERT INTO SAM01 VALUES (1020, 'ORANGE', 'DOCTOR', 25000);
INSERT INTO SAM01 VALUES (1030, 'VERY', NULL, 25000);
INSERT INTO SAM01 VALUES (1040, 'CAT', NULL, 2000);
SELECT * FROM SAM01;
-- SUB QUERY(10번 부서인 EMP 테이블 EMPNO, ENAME, JOB, SAL 내용)를 이용한 3행 INSERT
INSERT INTO SAM01 SELECT EMPNO, ENAME, JOB, SAL FROM EMP WHERE DEPTNO = 10;
-- TRANSACTION에 쌓여 있는 DML을 ORACLE에 적용시키기
COMMIT;

-- 2. UPDATE 테이블명 SET 필드명1=값1[, 필드명2=값2, ... 필드명N=값N] [WHERE 조건];
DROP TABLE EMP01;
-- SUB QUERY를 이용한 테이블 생성(제약 조건은 가져오지 않고 데이터만 가져옴)
CREATE TABLE EMP01 AS SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP;
SELECT * FROM EMP01;
    -- EX1. 부서번호를 30번으로 수정
    UPDATE EMP01 SET DEPTNO=30;
    SELECT * FROM EMP01;
    ROLLBACK;
    -- EX2. 모든 사원(EMP01)의 급여(SAL)를 10% 인상
    UPDATE EMP01 SET SAL = SAL*1.1;
    SELECT * FROM EMP01;
    ROLLBACK;
    -- EX3. EMP01 테이블에서 10번 부서의 직원을 30번 부서로
    UPDATE EMP01 SET DEPTNO=30 WHERE EMPNO=10;
    SELECT * FROM EMP01;
    ROLLBACK;
    -- EX4. SCOTT의 부서번호를 10으로 JOB은 'MANAGER'로 SAL과 COMM인 500$씩 인상
        -- 입사일은 오늘로, 상사번호는 'KING'의 사번으로 수정
    UPDATE EMP
        SET DEPTNO=10, JOB='MANAGER', SAL=SAL+500, COMM=NVL(COMM, 0)+500, HIREDATE=SYSDATE, MGR=(SELECT EMPNO FROM EMP WHERE ENAME='KING')
        WHERE ENAME='SCOTT';    
SELECT * FROM EMP;
    -- EX5. 모든 사원의 급여와 입사일을 'KING'의 급여와 입사일로 수정
    UPDATE EMP
        SET SAL = (SELECT SAL FROM EMP WHERE ENAME='KING'),
            HIREDATE = (SELECT HIREDATE FROM EMP WHERE ENAME='KING');
            
    UPDATE EMP
        SET (SAL, HIREDATE) = (SELECT SAL, HIREDATE FROM EMP WHERE ENAME='KING')
    SELECT * FROM EMP;
    ROLLBACK;

-- 3. DELETE FROM 테이블명 [WHERE 조건];
DELETE FROM EMP01;
SELECT * FROM EMP01;
ROLLBACK; -- INSERT, UPDATE, DELETE만 취소 가능
DELETE FROM DEPT; -- 삭제 불가 (EMP 테이블이 참조하는 데이터가 있어서)
    -- EX1. EMP01에서 'FORD' 직원 퇴사
    DELETE FROM EMP01 WHERE ENAME='FORD';
    -- EX2. EMP01에서 30번 부서 직원을 삭제
    DELETE FROM EMP01 WHERE DEPTNO=30;
    -- EX3. 부서명이 RESEARCH 부서인 직원을 삭제
    DELETE FROM EMP01
        WHERE DEPTNO=(SELECT DEPTNO FROM DEPT WHERE DNAME='RESEARCH');
    SELECT * FROM EMP01;
    -- EX4. SAM01 테이블에서 JOB이 정해지지 않은 사원 삭제
    SELECT * FROM SAM01;
    DELETE FROM SAM01 WHERE JOB IS NULL;
    -- EX5. SAM01 테이블에서 이름이 ORANGE인 데이터 삭제
    DELETE FROM SAM01 WHERE ENAME='ORANGE';
    SELECT * FROM SAM01; 
    
-- ※ PDF 2~3PAGE (교안 9PAGE) 연습문제















