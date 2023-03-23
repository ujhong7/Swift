import UIKit

// 캡쳐리스트 실제 사용 예시



// 강한 참조의 경우
// 강한 참조가 일어나고, (서로가 서로를 가르키는) 강한 참조 사이클은 아니지만,
// 생각해볼 부분이 있다
class ViewController: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        DispatchQueue.global().async {
            sleep(3)
            print("글로벌큐에서 출력하기: \(self.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction() {
    let vc = ViewController()
    vc.doSomething()
}                              // 이 함수는 이미 종료 ==> vc변수 없음

localScopeFunction()
// (3초후)
// 글로벌큐에서 출력하기: 뷰컨
// 뷰컨 메모리 해제




// 약한 참조의 경우
class ViewController1: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        // 강한 참조 사이클이 일어나지 않지만, 굳이 뷰컨트롤러를 길게 잡아둘 필요가 없다면
        // weak self로 선언
        DispatchQueue.global().async { [weak self] in
            //guard let weakSelf = self else { return }
            sleep(3)
            print("글로벌큐에서 출력하기: \(self?.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction1() {
    let vc = ViewController1()
    vc.doSomething()
}


localScopeFunction1()
// 뷰컨 메모리 해제
// (3초후)
// 글로벌큐에서 출력하기: nil



//
