import UIKit


// ARC(Automatic Reference Counting)를 통한 메모리 관리

// MRC (Manual 수동관리), ARC(Auto 자동관리)

class Dog {
    var name: String
    var weight: Double
    
    init(name: String, weight: Double) {
        self.name = name
        self.weight = weight
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


var choco: Dog? = Dog(name: "초코", weight: 15.0)  // retain(choco)   RC: 1
var bori: Dog? = Dog(name: "보리", weight: 10.0)   // retain(bori)    RC: 1


choco = nil   // RC: 0
//release(choco)
bori = nil    // RC: 0
//release(bori)


/**========================================================================
 - 예전 언어들은 모든 메모리를 수동 관리했음
 - 실제로 개발자가 모든 메모리 해제 코드까지 삽입해야함 (실수할 가능성 높음)
 

 - retain() 할당 ---> release() 해제
    (RC  +1)           (RC  -1)

 - 개발자는 실제 로직 구현 포함, 메모리 관리에 대한 부담이 있었음 ⭐️


 - 따라서, 현대적 언어들은 대부분 자동 메모리 관리 모델을 사용
 - 스위프트의 경우, 컴파일러가 실제로
   retain() 할당 ---> release() 해제 코드를 삽입한다고 보면됨
 - 컴파일러가 메모리 관리코드를 자동으로 추가해 줌으로써, 프로그램의 메모리 관리에 대한 안정성 증가


 - 단지 아래와 같은 메커니즘의 실행을 수동(Manual)으로 할 것인지,
   자동(Automatic)으로 할 것인지의 차이

 [ARC모델의 기반: 소유정책과 참조카운팅]
   1.소유정책 - 인스턴스는 하나이상의 소유자가 있는 경우 메모리에 유지됨
             (소유자가 없으면, 메모리에서 제거)
   2.참조카운팅 - 인스턴스(나)를 가르키는 소유자수를 카운팅

 - (쉽게 말하면, 인스턴스를 가르키고 있는 RC가 1이상이면 메모리에 유지되고, 0이되면 메모리에서 제거됨)
 =======================================================================**/

// ARC

var dog1: Dog?
var dog2: Dog?
var dog3: Dog?


dog1 = Dog(name: "댕댕이", weight: 7.0)     // RC + 1   RC == 1
dog2 = dog1                               // RC + 1   RC == 2
dog3 = dog1                               // RC + 1   RC == 3


dog3?.name = "깜둥이"
dog2?.name
dog1?.name



dog3 = nil                                // RC - 1   RC == 2
dog2 = nil                                // RC - 1   RC == 1
dog1 = nil                                // RC - 1   RC == 0    // 메모리 해제





// ===============================================================================
// ===============================================================================
// ===============================================================================


// Memory Leak (메모리누수) 현상에 대한 이해

class Dog {
    var name: String
    var owner: Person?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


class Person {
    var name: String
    var pet: Dog?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


var bori: Dog? = Dog(name: "보리")
var gildong: Person? = Person(name: "홍길동")


bori?.owner = gildong
gildong?.pet = bori

// 강한 참조 사이클(Strong Reference Cycle)이 일어남

bori = nil
gildong = nil

// 메모리 해제 안됨!

/**==========================================
 - 객체가 서로를 참조하는 강한 참조 사이클로 인해
 - 변수의 참조에 nil을 할당해도 메모리 해제가 되지 않는
 - 메모리 누수(Memory Leak)의 상황이 발생
=============================================**/


/**===========-메모리 누수 해결방안-===============
 - RC를 고려하여, 참조 해제 순서를 주의해서 코드 작성
    ===> 신경쓸 것이 많음/실수 가능성
 
 - 1) Weak Reference (약한 참조)
 - 2) Unowned Reference (비소유 참조)
=============================================**/



// 1) 약한참조 Weak Reference
class Dog {
    var name: String
    weak var owner: Person?     // weak 키워드 ==> 약한 참조
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제!")
    }
}


class Person {
    var name: String
    weak var pet: Dog?         // weak 키워드 ==> 약한 참조
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제!")
    }
}


var bori: Dog? = Dog(name: "보리")
var gildong: Person? = Person(name: "홍길동")


// 강한 참조 사이클이 일어나지 않음
bori?.owner = gildong
gildong?.pet = bori



// 메모리 해제가 잘됨(사실 이 경우 한쪽만 weak으로 선언해도 상관없음)
bori = nil
gildong = nil
// ... 메모리 해제!


// ⭐️ 약한 참조의 경우, 참조하고 있던 인스턴스가 사라지면 nil로 초기화 되어있음
// nil로 설정하고 접근하면 ---> nil

gildong = nil
bori?.owner // nil   (gildong만 메모리 해제 시켰음에도 nil)





// 2) 비소유 참조 Unowned Reference
class Dog1 {
    var name: String
    unowned var owner: Person1?    // Swift 5.3 이전버전에서는 비소유참조의 경우, 옵셔널 타입 선언이 안되었음
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제!")
    }
}

class Person1 {
    var name: String
    unowned var pet: Dog1? // 비소유
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제!")
    }
}


var bori1: Dog1? = Dog1(name: "보리1")
var gildong1: Person1? = Person1(name: "홍길동1")


// 강한 참조 사이클이 일어나지 않음
bori1?.owner = gildong1
gildong1?.pet = bori1



// 메모리 해제가 잘됨(사실 이 경우 한쪽만 unowned로 선언해도 상관없음)
bori1 = nil
gildong1 = nil
// ... 메모리 해제!



// ⭐️ 비소유 참조의 경우, 참조하고 있던 인스턴스가 사라지면 nil로 초기화 되지 않음
// nil로 설정하고 접근하면 ===> 에러 발생

// 1) 에러발생하는 케이스
gildong1 = nil
bori1?.owner   // error (nil로 초기화 되지 않음 에러 발생)

// 2) 에러가 발생하지 않게 하려면
gildong1 = nil
bori1?.owner = nil      // 에러 발생하지 않게 하려면, nil로 재설정 필요 ⭐️
bori1?.owner


//
//
