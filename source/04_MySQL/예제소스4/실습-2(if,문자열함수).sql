use sqldb;

-- if함수는 '만약에 ~~이라면'이라는 뜻이다. 즉 1000>2000수식의 결과가
-- 참이면, 1번째 인자값을 출력하고, 거짓이면 2번째 인자값을 출력을 한다.
select if(1000 < 2000, '참입니다','거짓입니다');

-- ifnull은 1번째 인자값에 따라 널이면 2번째 인자값이 출력되고,
-- 1번째 인자값이 널이 아니면, 1번째 값을 출력을 한다.
select ifnull(null, 'null이군요'), ifnull(1000, 'null이군요');

-- nullif는 두 개의 인자값이 같으면 널을 출력하고,
-- 두개의 인자값이 다르면 첫번째 인자값을 출력한다.
select nullif(1000,1000), nullif(1000,2000);

-- 프로그래밍 언어에서 switch구문과 유사하다.
-- case는 함수가 아니라 연산자라고 이해를 해야 한다.
-- case...when...then...else...end형태가 문법이니까 알아두자
select case 10
	when 1 then '일'
    when 5 then '오'
    when 10 then '십'
    when 100 then '백'
	else '해당되는 값이 없음'
end;

-- 문자열 함수
-- ascii함수는 인자의 값을 아스키코드값으로 출력한다.
-- char함수는 숫자로 준 내용을 문자로 나타낸다.
select ascii('B'), char(97);

-- mysql의 문자셋은 utf-8을 사용한다.utf-8인 경우는 영문은 1바이트,
-- 한글은 3바이트로 사용이된다.
-- bit_length()는 주어진 문자열의 바이트수 * 8해서 비트수를 리턴하는 함수.
select bit_length('abc');

-- char_length()는 문자열의 문자의 수를 출력한다.
select char_length('가나다'), char_length('abc');

-- length함수는 인자값의 바이트 수를 출력한다.
select length('안녕하세요');

-- 문자열을 연결해주는 함수가 concat()이다.
select concat(100, '은 ', '100과 같다');

-- concat_ws()는 첫번째 주어진 구분자로 문자열 서로 연결해주는 함수이다.
select concat_ws('-','년','05','08');

-- elt함수는 첫 번째 주어진 값의 위치로 가서 있는 것을 출력한다.
-- 찾는 값이 없으면 null을 리턴한다.
select elt(2,'일','이','삼');

-- field함수는 첫 번째 주어진 값의 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select field('이','일','이','삼');
-- find_in_set함수는 첫 번째 주어진 값의 구분자를 가지고 문자열의 문자 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select find_in_set('이','일,이,삼');
-- instr함수는 첫 번째 문자열값에서 두번째 값이 있으면 그 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select instr('일이삼사','이');
-- locate함수는 인자값의 위치만 다를뿐 instr함수와 동일하다.
select locate('일', '일이삼사');

-- format()는 엑셀의 round()와 유사하다. 소숫점자리를 지정해서 반올림을 해준다.
-- 1000단위도 구분해줌.
select format(77777.11151, 3);

-- 2진수, 16진수, 8진수로 변화해주는 함수
select bin(10), hex(30), oct(10);

-- insert함수는 replace개념이 같다. 2번째 자리부터 3자리를 ???대치해달라.
select insert('11111', 2, 3, '???');

-- left함수는 왼쪽에서 3자, right함수는 오른쪽에서 3자를 출력한다.
select left('가나다라마', 3), right('가나다라마', 3);

-- 대소문자로 변환을 해주는 함수 4가지 있다.원하는 함수를 사용하면 된다.
select lower('ABCabc'), upper('ABCabc');
select lcase('ABCabc'),ucase('ABCabc');

-- 공백을 제거해주는 함수, 왼쪽공백 제거(ltrim), 오른쪽 공백 제거(rtrim)
select ltrim('     데이터'), rtrim('데이터    ');
-- trim함수는 앞뒤 공백을 제거하는 함수이다.중간에 공백은 제거하지 못한다.
select trim('   데이터 베이스   ');

-- repeat함수는 인자값을 반복해준다.
select repeat('신은혁', 5);

-- replace()는 문자열 치환 함수이다.
select replace('mysql데이터베이스', '데이터', 'data');

-- reverse함수는 주어진 인자값을 거꾸로 출력을 한다.
select reverse("신은혁");

-- space()는 공백을 만들어준다.
select concat('나의', space(50), '데이터베이스');

-- substring()문자열을 잘라내서 출력한다.
select substring('데이터베이스', 4 ,3);

-- substring_index()는 구분자 .을 기준으로 하여 2번째 이후는 출력하지 않는다.
-- -2를 주었을때는 오른쪽부터 시작해서 2번째 이후는 출력하지 않는다.
select substring_index('데이터베이스.my.sql', '.', 2);
select substring_index('데이터베이스.my.sql', '.', -2);