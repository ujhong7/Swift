import UIKit


// @escaping 키워드

/**==========================================================================
 - 원칙적으로 함수의 실행이 종료되면 파라미터로 쓰이는 클로저도 제거됨
 - @escaping 키워드는 ⭐️클로저를 제거하지 않고 함수에서 탈출시킴(함수가 종료되어도 클로저가 존재하도록 함)
 - ==> 클로저가 함수의 실행흐름(스택프레임)을 벗어날 수 있도록 함
 ============================================================================**/
 


/**===========================================
 @escaping 사용의 대표적인 경우
 - 1) 어떤 함수의 내부에 존재하는 클로저(함수)를 외부 변수에 저장
 - 2) GCD (비동기 코드의 사용)
 =============================================**/


// 예제1
var aSavedFunction: () -> () = { print("출력") }

aSavedFunction() // 출력

func performEscaping(closure: @escaping ()->()) {
    aSavedFunction = closure // 클로저를 실행하는 것이 아니라, aSavedFunction 변수에 저장
}

performEscaping {
    print("다르게 출력")
}

aSavedFunction() // 다르게 출력

// 예제2 (GCD 비동기 코드)
func performEscaping2(closure: @escaping (String)->()){
    var name = "홍길동"
    
    DispatchQueue.main.asyncAfter(deadline: .now()+1){
        closure(name)
    }
}


performEscaping2 { str in
    print("이름 출력하기: \(str)") // 1초 후 출력
}



// =============================================================================


// @autoclosure 키워드

/**========================================================================
 - 파라미터가 없는 클로저만 가능
 - 일반적으로 클로저 형태로 써도되지만, 너무 번거로울때 사용
 - 번거로움을 해결해주지만, 실제 코드가 명확해 보이지 않을 수 있으므로 사용 지양(애플 공식 문서)
 - 잘 사용하지 않음. 읽기위한 문법
==========================================================================**/

func someFunction(closure: @autoclosure () -> Bool){
    if closure(){
        print("참")
    }else{
        print("거짓")
    }
}

var num = 1

someFunction(closure: num == 1) // 참



// autoclosure는 기본적으로 non-ecaping 특성을 가지고 있음

func someAutoClosure(closure: @autoclosure @escaping () -> String) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        print("소개합니다: \(closure())")
    }
}


someAutoClosure(closure: "제니") // 3초 후 출력
