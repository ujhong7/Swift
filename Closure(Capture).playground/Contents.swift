import UIKit



// ⭐️ 클로저에서 값을 캡쳐한다는 것은..
func doSomething() {
    var message = "Hi"
    
    // 클로저 범위 시작
    var num = 10
    let closure = { print(num) }
    // 클로저 범위 끝
    
    print(message)
}

// 클로저 내부에서 외부 변수인 num을 사용하기 때문에
// num의 값을 클로저 내부적으로 저장하고 있는데
// 이것을 '클로저에 의해 num의 값이 캡쳐되었다' 라고 표현한다.

// message라는 변수는 클로저 내부에서 사용하지 않기 때문에
// 클로저에 의해 값이 캡쳐되지 않는다.

// =================================================







// ⭐️ 클로저의 값 캡쳐방식
// 클로저는 값을 캡쳐할때
// value/reference타입에 관계없이 reference capture한다.
// (타입에 관계없이 캡쳐하는 값들을 참조함!)
func doSomething2() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = {
        print("num check #3 = \(num)")
    }
    
    num = 20
    print("num check #2 = \(num)")
    closure()
}

//  결과
// num check #1 = 0
// num check #2 = 20
// num check #3 = 20

// 클로저는 num이라는 외부 변수를 클로저 내부에서 사용하기 때문에
// num을 캡쳐한다. 어떻게? reference capture
// 즉, num이란 변수를 참조한다.

// 따라서 클로저를 실행하기 전에 num이라는 값을 외부에서 변경하면
// 클로저 내부에서 사용하는 num의 값 또한 변경된다.
// 또한 클로저 내부에서 num의 값을 변경하면
// 클로저 외부에 있는 num의 값도 변경된다.

// =================================================





//  Value Type으로 Capture를 하고 싶으면 어떻게 해야할까?
// ⭐️ 클로저의 캡쳐 리스트
// 클로저의 시작인 { 의 바로 옆에
// []를 이용해 캡쳐할 멤버를 나열한다. 이때in 키워드도 꼭 함께 작성한다.
// let closure = { [num, num2] in }
func doSomething3() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = { [num] in
        print("num check #3 = \(num)")
    }
    
    num = 20
    print("num check #2 = \(num)")
    closure()
}

// Value Type의 경우,
// Value Capture하고 싶은 변수를 리스트로 명시해주는것이다.

//  결과
// num check #1 = 0
// num check #2 = 20
// num check #3 = 0

// 한가지 더 유의할점은
// Value Type으로 캡쳐할 경우
// Closure를 선언할 당시 num의 값을
// Const Value Type으로 캡쳐한다
// (즉, '상수'로 캡쳐된다는 것)
// 따라서 closure 내부에서 Value Capture된 값을 변경할 수 없다.

// 정리하자면
// 클로저는 기본적으로 Value Type의 값도 Reference Capture를 하지만,
// 클로져 캡쳐 리스트를 이용하면 Const Value Type으로 캡쳐가 가능하다.

// =================================================






// ⭐️ Reference Type의 값을 복사해서 Capture 할 순 없을까?
// 캡쳐 리스트를 작성한다고 해도, Reference Type은 Reference Capture를 한다.

// 그럼 Reference Type은 클로저 캡쳐 리스트를 작성할 필요가 없을까?
// no, 클로저와 ARC를 보면 언제 쓰는지 이해할 수 있다.

// =================================================





// ⭐️ 클로저와 ARC
class Human {
    var name = ""
    lazy var getName: () -> String = {
        return self.name
    }
    
    init(name: String) {
        self.name = name
    }
 
    deinit {
        print("Human Deinit!")
    }
}

var hong: Human? = .init(name: "jhong")
print(hong!.getName())

// hong 이라는 인스턴스를 만들고
// 클로저로 작성되어 있는 getName이란 지연 저장 프로퍼티를 호출했음
// 그리고 더 이상 hong이란 인스턴스가 필요없어서 인스턴스에 nil을 할당함
hong = nil
// 이 인스턴스에 다른 변수를 대입한 적이 없기때문에
// 인스턴스 RC가 0이 되며 deinit이 호출되어야 하는데 불리지 않는다.
// 비밀은 클로저에 있다!


// 클로저의 강한 순환 참조
// 클로저는 참조 타입으로, Heap에 살고 있다.
// 생성한 Human이라는 인스턴스는 getName을 호출하는 순간
// getName이라는 클로저가 Heap에 할당되며
// 이 클로저를 참조할 것이다.

// 그런데 getName이라는 클로저를 보면
// self를 통해 Human이란 인스턴스의 프로퍼티에 접근하고 있다.
// 클로저는 Reference 값을 캡쳐할 때 기본적으로 'Strong'으로 캡쳐한다.
// 따라서 이때, Human이라는 인스턴스의 Reference Count가 증가한다.
// Human인스턴스는 클로저를 참조하고
// 클로저는 Human인스턴스를 참조하기 때문에
// 서로가 서로를 참조해 둘 다 메모리에서 해제되지 않는 강한 순한 참조가 발생해 버린것이다.


// 해결방법
// weak & unowned와 캡쳐리스트를 사용하면 된다.
// self에 대한 참조를 Closure Capture Lists를 이용해 weak, unowned로 캡쳐한다.
class Human2 {
    var name = ""
    
    lazy var getName: () -> String? = { [weak self] in  // ⭐️
        return self?.name
    }
    
    init(name: String) {
        self.name = name
    }
 
    deinit {
        print("Human Deinit!")
    }
}
// 이렇게 클로저 리스트를 통해 강한 순한 참조를 해결해 줄 수 있다.
// deinit 정상 실행된다.



