-- json(javascript object notation)데이터
-- 타 언어들에 종속되지 않고 서로 교환을 할 수 있는 데이터 포맷 형태
use sqldb;

select *
  from usertbl;

-- usertbl에서 180이상 되는 데이터를 키와 값의 형태의 json데이터 포맷형태로 변환하고 있다.
-- 여기서 키는 이름이고 값은 username컬럼에 있는 데이터가 되는 것이다.
select json_object('username', username, 'height', height) as 'JSON값'
  from usertbl
 where height >= 180;
 
 -- json이라는 변수에다가 문자열을 저장하고 있다. 단, json포맷 형태로 저장함.
 set @json = '{ "usertbl" :
	   [
			{"username" : "임재범", "height" : 182},
            {"username" : "이승기", "height" : 182},
            {"username" : "성시경", "height" : 186}       
       ]
}';

select @json;
-- json변수에 대입된 문자열이 json형태인지 확인함(맞으면 1을 리턴, 틀리면 0을 리턴)
select json_valid(@json);

-- json_search()함수는 성시경이 몇번째 인덱스에 있느냐를 리턴해주는 함수이다.
-- json데이터는 배열개념으로 되어 있기 때문에 0부터 시작하니깐 2를 리턴을 한다.
-- 그리고, 인자값 중 'one'이 있는데 이것은 문법이라서 넣어준 것이다.
select json_search(@json, 'one', '성시경');

-- json_extract()함수는 주어진 인덱스의 실제 값을 가지고 오는 함수이다.
select json_extract(@json, '$.usertbl[1].username' );

-- json_insert()함수는 0번째 인덱스에다가 mdate를 삽입하는 함수이다.
select json_insert(@json, '$.usertbl[0].mdate','2020-02-17');

-- json_replace()함수는 0번째 인덱스에다가 username을 신은혁으로 바꾸어주는 함수이다.
select json_replace(@json, '$.usertbl[0].username', '신은혁');

-- json_remove()함수는 0번째 인덱스를 삭제하시오.
select json_remove(@json, '$.usertbl[0]');

select *
  from usertbl; 
  
select *
  from buytbl;
  
select json_array('userid', userid, 'prodname', prodname, 
			      'groupname', groupname, 'amount', amount)
  from buytbl;