import UIKit

// 캡처현상

// 일반함수
// 함수 내에서 함수를 실행하고, 값을 리턴하는 일반적인 함수
func calculate(number: Int) -> Int {
    
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    
    let result = square(num: number)
    
    return result
}


calculate(number: 10) // 100
calculate(number: 20) // 400
calculate(number: 30) // 900




// 변수를 캡처하는 함수(중첩 함수의 내부 함수) - 캡처 현상의 발생
/**=======================================================
 - 아래와 같은 경우, 중첩함수로 이루어져 있고
 - 내부 함수 외부에 계속 사용해야하는 값이 있기 때문에 캡처 현상이 발생
 
 - (함수/클로저를 변수에 저장하는 시점에 캡처) ==> 클로저도 레퍼런스 타입
=========================================================**/
func calculateFunc() -> ((Int) -> Int) {
    
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    
    return square
}


// 함수를 변수에 할당하는 경우
// (Heap 메모리에 유지를 해야함. 즉, 함수라 하더라도 클로저 방식으로 동작)
var squareFunc = calculateFunc()


squareFunc(10) // 100
squareFunc(20) // 500
squareFunc(30) // 1400


// =============================================================
// =============================================================


// 클로저 캡처 리스트

// 캡쳐리스트의 형태
/**===========================================================
 - 1) 파라미터가 없는 경우

     { [캡처리스트] in

     }


 - 2) 파라미터가 있는 경우

     { [캡처리스트] (파라미터) -> 리턴형 in

     }
 =============================================================**/


// 🔴 값(Value)타입 캡쳐와 캡쳐리스트

// 클로저는 자신이 사용할 외부의 변수를 캡쳐함
var num = 1

let valueCaptureClosure = {
    print("밸류값 출력(캡쳐): \(num)")
}

num = 7
valueCaptureClosure()  // 밸류값 출력(캡쳐): 7

// value타입의 참조(메모리주소)를 캡쳐함
// (즉, 값 자체를 복사해서 가지고 있는 것이 아니고, num의 주소를 캡쳐해서 계속 사용)

num = 1
valueCaptureClosure() // 밸류값 출력(캡쳐): 1


let valueCaptureListClosure = { [num] in
    print("밸류값 출력(캡쳐리스트): \(num)")
}

num = 7
valueCaptureListClosure() // 밸류값 출력(캡쳐리스트): 1

// value타입의 값을 캡쳐함
// (즉, 값 자체를 복사해서 가지고 계속 사용)

// 즉, 값 타입에서는 참조하는 값의 변경을 방지(외부적인 요인에 의한)하고 사용하고자 할때, 사용


// =============================================================

// 🔵 참조(Reference)타입 캡쳐와 캡쳐리스트

class SomeClass {
    var num = 0
}

var x = SomeClass()
var y = SomeClass()

print("참조 초기값(시작값):", x.num, y.num)


let refTypeCapture = { [x] in
    print("참조 출력값(캡쳐리스트):", x.num, y.num)
}

/**============================================
  x - (참조타입) 주소값 캡처, x를 ⭐️직접참조로 가르킴
  y - 변수를 캡처해서, y변수를 가르킴(간접적으로 y도 동일)
==============================================**/

x.num = 1
y.num = 1

print("참조 초기값(숫자 변경한 후):", x.num, y.num) // 1 1

refTypeCapture() // 1 1      ( Not 0 1 )

print("참조 출력값(클로저 실행 후):", x.num, y.num) // 1 1



// 강한 참조 사이클 문제의 해결 - 캡쳐리스트 + weak/unowned
var z = SomeClass()

let refTypeCapture1 = { [weak z] in
    print("참조 출력값(캡쳐리스트):", z?.num)
}
refTypeCapture1() // 참조 출력값(캡쳐리스트): Optional(0)


let refTypeCapture2 = { [unowned z] in
    print("참조 출력값(캡쳐리스트:", z.num)
}
refTypeCapture2() // 참조 출력값(캡쳐리스트: 0



// 캡쳐리스트에서 바인딩하는 것도 가능
var s = SomeClass()

let captureBinding = { [z = s] in  // 내부에서 변수명 바꿔서 사용가능 (외부변수와 헷갈리는 것을 방지)
    print("바인딩의 경우:", z.num)
}

let captureWeakBinding = { [weak z = s] in
    print("Weak 바인딩의 경우:", z?.num)
}

captureBinding() // 바인딩의 경우: 0
captureWeakBinding() // Weak 바인딩의 경우: Optional(0)
