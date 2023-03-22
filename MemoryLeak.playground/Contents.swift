import UIKit

// 메모리 누수(MemoryLeak)의 사례
// 강한참조 사이클로 인한 메모리누수의 사례

class Dog{
    var name = "초코"
    
    var run: (() -> Void)?
    
    func walk(){
        print("\(self.name)가 걷는다.")
    }
    
    func saveClosure(){
        // 클로저를 인스턴스의 변수에 저장
        run = {
            print("\(self.name)가 뛴다.")
        }
    }
    
    // 강한 참조 사이클 해결!
//    func saveClosure(){
//        run = { [weak self] in
//            print("\(self?.name)가 뛴다.")
//        }
//    }
    
    
    deinit {
        print("\(self.name) 메모리 해제")
    }
}


func doSomething(){
    let choco: Dog? = Dog()
}
doSomething() // 초코 메모리 해제


func doSomething2(){
    let choco: Dog? = Dog()
    choco?.saveClosure() // 강한 참조사이클 일어남 (메모리 누수가 일어남)
}
doSomething2() // 메모리 누수



