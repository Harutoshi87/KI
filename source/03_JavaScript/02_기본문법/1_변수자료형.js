// 자료형 : string, number, boolean, function, object(array), undefined
var variable;
console.log('1. variable 타입 :', typeof(variable), ' - 값 :', variable);
variable = '이름은 \'홍길동\'입니다';
console.log('2. variable 타입 :', typeof(variable), ' - 값 :', variable);
variable = -313131313131.2323;
console.log('3. variable 타입 :', typeof(variable), ' - 값 :', variable);
variable = false;
console.log('4. variable 타입 :', typeof(variable), ' - 값 :', variable);
variable = function(){ 
  alert('함수 속'); /* { ... } 안은 함수의 실행 코드 블록
JS에서 코드 블록, 조건문, 반복문, 함수 정의 모두 {} 안에 작성
함수 호출 시 {} 안의 코드가 실행됨 
파이썬은 **들여쓰기(indent)**로 코드 블록을 구분 */
};
console.log('5. variable 타입 :', typeof(variable), ' - 값 :', variable);
variable = {'name':'홍길동', 'age':20}; // 객체
console.log('6. variable 타입 :', typeof(variable), ' - 값 :', variable.name, variable.age);
variable = ['홍길동', 10, function(){}, true, {'name':'홍길동'}, [1,2,3]]; // 배열 : JS에서 배열은 숫자 인덱스로 요소를 접근함
console.log('7. variable 타입 :', typeof(variable), ' - 값 :', variable.name, variable.age);