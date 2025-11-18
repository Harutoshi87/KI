-- DCL(계정 생성, 권한 부여, 권한 박탈, 계정 삭제)
-- DDL(제약 조건 FK, SEQUENCE 없음)
-- DML(and:&&, or:||, 연결 연산자 대신 concat 함수 사용, OUTER JOIN)

-- -----------
-- ※ DCL ※ --
-- -----------
create user user01 identified by 'password';
grant all privileges on *.* to user01; -- 권한 부여
drop user user01; -- 계정 삭제




