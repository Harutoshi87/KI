-- [V] SEQUENCE : 순차번호 생성기. 대부분 인위적인 PK 사용 목적
DROP SEQUENCE FRIEND_SQ;
CREATE SEQUENCE FRIEND_SQ
    START WITH 10 -- 1부터 생성(기본값)
    INCREMENT BY -1 -- 1씩 증가(기본값)
    MAXVALUE 9999 -- 최대값
    MINVALUE -9999 -- 최소값
    NOCYCLE       
    NOCACHE; -- CACHE 메모리를 사용하지 않음
SELECT FRIEND_SQ.NEXTVAL FROM DUAL; -- NEXTVAL(순차번호 생성), DUAL : ORACLE이 제공하는 테이블(1행 1열짜리 테이블)
SELECT FRIEND_SQ.CURRVAL FROM DUAL; -- CURRVAL(현재까지 진행된 순차번호)

-- EX1. SEQUENCE를 이용한 FRIEND 테이블
DROP TABLE FRIEND;
CREATE TABLE FRIEND(
    NO NUMBER(5) PRIMARY KEY,
    NAME VARCHAR2(30) NOT NULL,
    TEL VARCHAR2(20) UNIQUE,
    ADDRESS VARCHAR2(255),
    LAST_MODIFY DATE DEFAULT SYSDATE
);
DROP SEQUENCE FRIEND_SQ;
CREATE SEQUENCE FRIEND_SQ
    MAXVALUE 99999
    NOCACHE
    NOCYCLE;

INSERT INTO FRIEND (NO, NAME, TEL, ADDRESS)
    VALUES (FRIEND_SQ.NEXTVAL, '홍길동', NULL, '신림'); -- 여러번 실행 가능
SELECT NO, NAME, TEL, ADDRESS,
     TO_CHAR(LAST_MODIFY, 'RR/MM/DD AM HH:MI:SS') LAST_MODIFY
    FROM FRIEND;
INSERT INTO FRIEND
    VALUES (FRIEND_SQ.NEXTVAL, '김길동', '010-9999-9999', '봉천', SYSDATE);
SELECT * FROM FRIEND;

/*
<연습문제> 
아래의 요구사항을 만족하는 데이터베이스를 설계하고, 테이블을 생성, 데이터를 입력하는 SQL문을 조건에 맞게 작성하시오.
[제출 파일]
ERD 캡처한 png파일(exERD.png)과  sql 작성 파일
[요구사항]
(1) 같은 이름의 테이블이나 시퀀스가 있을 수 있으니 먼저 삭제하고 테이블을 생성하시오
(2) MEMBER 테이블은 필드 별로 다음의 조건을 지켜 생성하시오.
	① mNO(번호) : 주키(시퀀스 이용)
	② mNAME(이름) : NULL값을 입력할 수 없다
	③ mPW(비밀번호) : 반드시 1~8글자 이내의 문자를 입력한다. CHECK(LENGTH(mPW)BETWEEN 1 AND 8)
	④ mEMAIL(메일) : 모든 데이터는 EMAIL 필드값이 모두 다르게 입력된다.UNIQUE
	⑤ mPOINT(포인트) : 0이상의 값만 입력할 수 있다.
	⑥ mRDATE(가입일) : 입력하지 않을 시, 기본적으로 현재날짜로 입력된다.DEFAULT SYSDATE
⑦ LEVELNO : MEMBER_LEVEL 테이블의 LEVELNO 필드를 참조하는 외래키
(3) MEMBER_LEVEL 테이블은 필드 별로 다음의 제약조건을 지킨다.
	① LEVELNO : 주키
	② LEVELNAME : NULL값을 입력할 수 없다	
(4) MEMBER 테이블의 mNO번호는 시퀀스(MEMBER_MNO_SQ)를 생성한 뒤 자동생성 번호로 입력


[입력될 데이터 내용]
[MEMBER 테이블]
mNO mNAME  mPW  mMAIL            mPOINT  mRDATE  LEVELNO
1     홍길동   aa     hong@hong.com      0      24/09/26     0
2     신길동   bb     sin@sin.com        1000     22/04/01     1
[MEMBER_LEVEL 테이블]
LEVELNO LEVELNAME
-1           black
0            일반
1            실버
2            골드
[테스트 출력 내용]
mNO mNAME   mRDATE          mMAIL       point   levelname
   1   홍길동   2022-03-10   hong@hong.com    0     일반고객
   2   신길동   2022-04-01   sin@sin.com       1000   실버고객
*/
CREATE TABLE MEMBER_LEVEL(
    LEVELNO NUMBER(2) PRIMARY KEY,
    LEVELNAME VARCHAR2(10)
);
INSERT INTO MEMBER_LEVEL VALUES (-1, 'black');
INSERT INTO MEMBER_LEVEL VALUES (0, '일반');
INSERT INTO MEMBER_LEVEL VALUES (1, '실버');
INSERT INTO MEMBER_LEVEL VALUES (2, '골드');
SELECT * FROM MEMBER_LEVEL;

CREATE TABLE MEMBER(
    mNO NUMBER(4) PRIMARY KEY,
    mNAME VARCHAR2(20),
    mPW VARCHAR2(8),
    mEMAIL VARCHAR2(30) UNIQUE,
    mPOINT NUMBER(9) CHECK(mPOINT >= 0),
    mRDATE DATE DEFAULT SYSDATE,
    LEVELNO NUMBER(2),
    FOREIGN KEY(LEVELNO) REFERENCES MEMBER_LEVEL(LEVELNO)
);
CREATE SEQUENCE MEMBER_SQ
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

INSERT INTO MEMBER VALUES (MEMBER_SQ.NEXTVAL, '홍길동', 'aa', 'hong@hong.com', 0, '24/09/26', 0);
INSERT INTO MEMBER VALUES (MEMBER_SQ.NEXTVAL, '신길동', 'bb', 'stn@stn.com', 1000, '22/04/01', 1);
SELECT * FROM MEMBER;
SELECT mNO, mNAME, TO_CHAR(mRDATE, 'YYYY-MM-DD') mRDATE, mEMAIL mMAIL, mPOINT point, LEVELNAME||'고객' levelname
    FROM MEMBER M, MEMBER_LEVEL L
    WHERE M.LEVELNO=L.LEVELNO;









