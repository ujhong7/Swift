import UIKit

// 객체 내에서 클로저의 사용




// 일반적인 클로저의 사용(객체 내에서의 사용, self키워드)
/**======================================================================
 - 클로저 내에서 객체의 속성 및 메서드에 접근 시에는 "self키워드"를 반드시 사용해야함
 - (강한 참조를 하고 있다는 것을 표시하기위한 목적) ===> 여기서는 Dog의 RC를 올리는 역할 +1

 - 1) self.name
 - 2) [self]  =====> Swift 5.3이후
 
 - 구조체의 경우, self를 생략하는 것도 가능 (Swift 5.3이후) ⭐️
=========================================================================**/

class Dog{
    var name = "초코"
    
    func doSomething(){
        // 비동기적으로 실행하는 클로저
        // 해당 클로저는 오래동안 저장할 필요가 있음 -> 새로운 스택을 만들어서 실행하기 때문
        DispatchQueue.global().async{
            print("나의 이름은 \(self.name)입니다.")
        }
        
        DispatchQueue.global().async { [self] in
            print("나의 이름은 \(name)입니다.")
        }
        
        
    }
}


var choco = Dog()
choco.doSomething()

// 클로저가 choco인스턴스에 대해 강한 참조는 하지만 (RC + 1)
// 실제 강한 참조 사이클을 일으키진 않음 (서로 가리키는게 아니기 때문)


// ========================================================================
// ========================================================================


// 클로저 캡쳐 리스트 - Strong Reference Cycle(강한 참조 순환) 해결
/**===================================================================
 - 클로저는 기본적으로 캡처 현상이 발생

 - 클로저와 인스턴스가 강한참조로 서로를 가르키고 있다면(Strong Reference Cycle),
   메모리에서 정상적으로 해제되지 않고, 메모리 누수 현상이 발생

 - 캡처리스트 내에서, 약한 참조 또는 비소유 참조를 선언해서 문제해결
===================================================================**/

// 클로저의 강한 참조 해결: 캡처 리스트 + 약한/비소유 참조 선언
// 캡쳐리스트 + weak/unowned

// ⭐️ 클로저를 객체 내에서 사용할때는 대부분 weak과 함께 사용한다고 보면 됨!
class Person{
    let name = "홍길동"
    
    func sayMyName(){
        print("나의 이름은 \(name)입니다.")
    }
    
    func sayMyName1(){
        DispatchQueue.global().async {
            print("나의 이름은 \(self.name)입니다.") // 강하게 가리킴
        }
    }
    
    func sayMyName2(){
        DispatchQueue.global().async { [weak self] in // 약하게 가리킴
            print("나의 이름은 \(self?.name)입니다.")
        }
    }
    
    func sayMyName3(){
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return } // 가드문 처리 -> 객체없으면 일종료
            print("나의 이름은 \(weakSelf.name)입니다. (가드문)")
        }
    }
    
}


let person = Person()

person.sayMyName() // 나의 이름은 홍길동입니다.
person.sayMyName1() // 나의 이름은 홍길동입니다.
person.sayMyName2() // 나의 이름은 Optional("홍길동")입니다.
person.sayMyName3() // 나의 이름은 홍길동입니다. (가드문)

// 
