let num1 = 21;
let num2 = 25;
let difference = (num1>num2) ? num1-num2 : num2-num1;
// let difference; // 차이값을 저장할 예정
// if (num1>num2){
//     difference = num1 - num2;
// }else{
//     difference = num2 - num1;
// }
// msg = (num1>num2) ? '첫번째 수가 '+difference +'만큼 더 크다' :
//                     (num2>num1)? '두번째 수가 '+difference +'만큼 더 크다' :
//                                     '두 수는 같다';
if (num1>num2){
    var msg = '첫번째 수가 '+difference +'만큼 더 크다';
}else if (num2>num1){
    msg = '두번째 수가 '+difference +'만큼 더 크다';
}else{
    msg = '두 수는 같다'
}
console.log('두 수의 차는', difference);
console.log(msg);