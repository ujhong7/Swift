import Foundation
import PlaygroundSupport
// 플레이 그라운드 작업 중간에 멈추지 않게 하기 위함
// (비동기작업으로 인해, 플레이그라운드의 모든 작업이 끝난다고 인식할 수 있기때문에 사용)
PlaygroundPage.current.needsIndefiniteExecution = true


// 비동기프로그래밍에 대한 이해
// "디폴트 글로벌큐 생성", "비동기적으로"
DispatchQueue.global().async {
    // 다른 쓰레드로 보낼 작업을 배치
}

// 클로저는 작업을 하나로 묶음 ⭐️
// 전체가 하나의 작업 -> 내부적으로는 동기적으로 동작 ⭐️
DispatchQueue.global().async {
    print("task1 시작")
    print("task1-1")
    print("task1-2")
    print("task1-3")
    print("task1 종료")
}

// 위의 코드와 아래코드는 전혀 다르다. 순서를 보장할 수 없음
// 아래의 코드는 작업이 3개로 분할된 개념
DispatchQueue.global().async {
    print("task2 시작")
}

DispatchQueue.global().async {
    print("task2-1")
}

DispatchQueue.global().async {
    print("task2-2")
}

DispatchQueue.global().async {
    print("task2-3")
}

DispatchQueue.global().async {
    print("task2 종료")
}

/* 실행할 때마다 항상 다름
 task2-2
 task2-1
 task2 종료
 task2-3
 task2 시작
*/


// ========================================================================
// ========================================================================

// 동기적인 함수의 정의
func task1() {
    print("Task 1 시작")
    sleep(2)
    print("Task 1 완료★")
}

func task2() {
    print("Task 2 시작")
    sleep(2)
    print("Task 2 완료★")
}

func task3() {
    print("Task 3 시작")
    sleep(2)
    print("Task 3 완료★")
}

// 비동기적인 함수의 정의
func task4() {
    DispatchQueue.global().async {
        print("Task 4 시작")
        sleep(2)
        print("Task 4 완료★")
    }
}

func task5() {
    DispatchQueue.global().async {
        print("Task 5 시작")
        sleep(2)
        print("Task 5 완료★")
    }
}

func task6() {
    DispatchQueue.global().async {
        print("Task 6 시작")
        sleep(2)
        print("Task 6 완료★")
    }
}

task1()   // 일이 끝나야 다음줄로 이동 (내부 동기)
task2()   // 일이 끝나야 다음줄로 이동 (내부 동기)
task3()   // 일이 끝나야 다음줄로 이동 (내부 동기)

/*
Task 1 시작
Task 1 완료★
Task 2 시작
Task 2 완료★
Task 3 시작
Task 3 완료★
*/


// 내부적으로 비동기처리가 되어있는 함수들
task4()   // 일이 끝나지 않아도 다음줄로 이동 (내부 비동기)
task5()   // 일이 끝나지 않아도 다음줄로 이동 (내부 비동기)
task6()   // 일이 끝나지 않아도 다음줄로 이동 (내부 비동기)

/*
 Task 4 시작
 Task 5 시작
 Task 6 시작
 Task 5 완료★
 Task 6 완료★
 Task 4 완료★
*/


// ========================================================================
// ========================================================================



// Serial 직렬큐
let serialQueue = DispatchQueue(label:"com.inflearn.serial")

serialQueue.async {
    task1()
}

serialQueue.async {
    task2()
}

serialQueue.async {
    task3()
}

/* 직렬큐 (순서대로 작업을 보냄)
   비동기적으로 보내더라도, 순서대로 출력
Task 1 시작
Task 1 완료★
Task 2 시작
Task 2 완료★
Task 3 시작
Task 3 완료★
*/

// Concurrent 동시큐
let concurrentQueue = DispatchQueue.global()


concurrentQueue.async {
    task1()
}

concurrentQueue.async {
    task2()
}

concurrentQueue.async {
    task3()
}


/*
 Task 1 시작
 Task 3 시작
 Task 2 시작
 Task 3 완료★
 Task 2 완료★
 Task 1 완료★
*/


// ========================================================================
// ========================================================================


// 큐(Queue/대기열)의 종류

// 메인큐 = 메인쓰레드("쓰레드 1번"을 의미), 한개뿐이고 Serial큐
let mainQueue = DispatchQueue.main

// 글로벌큐 = 6가지 Qos를 가지고 있는 글로벌(전역) 대기열
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
let defaultQueue = DispatchQueue.global()  // 디폴트 글로벌큐
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)
let unspecifiedQueue = DispatchQueue.global(qos: .unspecified)

// 프라이빗(커스텀)큐 = 기본적인 설정은 Serial, 다만 Concurrent설정도 가능
let privateQueue = DispatchQueue(label: "com.inflearn.serial")


// 플레이그라운드 vs 실제 앱 (주의)
// 실제 앱에서는 UI관련작업들이 DispatchQueue.main(메인큐)에서 동작하지만,
// 플레이 그라운드에서는 DispatchQueue.global()(글로벌 디폴트큐)에서 동작한다. 따라서 플레이그라운드에서는 메인큐에 일을 시키면 안된다.
// DispatchQueue.main ====> 앱에서는 UI를 담당
// DispatchQueue.global() ====> 플레이그라운드에서 프린트영역를 담당


// ========================================================================
// ========================================================================

// UI업데이트는 메인 쓰레드에서
// 유저인터페이스(즉, 화면)와 관련된 작업은 메인쓰레드에서 진행해야 함
var imageView: UIImageView? = nil

let url = URL(string: "https://bit.ly/32ps0DI")!

// URL세션은 내부적으로 비동기로 처리된 함수임.
URLSession.shared.dataTask(with: url) { (data, response, error) in
    
    if error != nil{
        print("에러있음")
    }
    
    guard let imageData = data else { return }
    
    // 즉, 데이터를 가지고 이미지로 변형하는 코드
    let photoImage = UIImage(data: imageData)
    
    // 🎾 이미지 표시는 DispatchQueue.main에서 🎾
    DispatchQueue.main.async {
        imageView?.image = photoImage
    }
    
    
}.resume()

// UI와 관련된 일은 다시 메인쓰레드로 보내야 함
DispatchQueue.global().async {
    
    // 비동기적인 작업들 ===> 네트워크 통신 (데이터 다운로드)
    
    DispatchQueue.main.async {
        // UI와 관련된 작업은
    }
}


// ========================================================================
// ========================================================================


// 올바른 비동기함수의 설계
// 리턴(return)이 아닌 콜백함수를 통해, 끝나는 시점을 알려줘야 한다.

// 함수(메서드)를 아래처럼 설계하면 절대 안된다.
func getImages(with urlString: String) -> UIImage? {
    
    let url = URL(string: urlString)!
    
    var photoImage: UIImage? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
    }.resume()

    
    return photoImage    // 항상 nil 이 나옴
}

getImages(with: "https://bit.ly/32ps0DI")    // 무조건 nil로 리턴함 ⭐️



// 올바른 함수(메서드)의 설계 - 콜백함수의 사용법
func properlyGetImages(with urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
    
    let url = URL(string: urlString)!
    
    var photoImage: UIImage? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
        completionHandler(photoImage)
        
    }.resume()
    
}

// 올바르게 설계한 함수 실행
properlyGetImages(with: "https://bit.ly/32ps0DI") { (image) in
    
    // 처리 관련 코드 넣는 곳...
    
    DispatchQueue.main.async {
        // UI관련작업의 처리는 여기서
    }
    
}


// ========================================================================
// ========================================================================


// 클로저의 강한 참조 주의!
// 강한참조가 일어나고, (서로가 서로를 가리키는) 강한 참조 사이클은 일어나지 않지만
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
}

localScopeFunction()
//글로벌큐에서 출력하기: 뷰컨

//뷰컨 메모리 해제
/**=======================================================
 - (글로벌큐)클로저가 강하게 캡처하기 때문에, 뷰컨트롤러의 RC가 유지되어
 - 뷰컨트롤러가 해제되었음에도, 3초뒤에 출력하고 난 후 해제됨
 - (강한 순환 참조가 일어나진 않지만, 뷰컨트롤러가 필요없음에도 오래 머무름)

 - 그리고 뷰컨트롤러가 사라졌음에도, 출력하는 일을 계속함
=========================================================**/



// 약한참조
class ViewController1: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        // 강한 참조 사이클이 일어나지 않지만, 굳이 뷰컨트롤러를 길게 잡아둘 필요가 없다면
        // weak self로 선언
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            sleep(3)
            print("글로벌큐에서 출력하기: \(weakSelf.name)")
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
//뷰컨 메모리 해제

//글로벌큐에서 출력하기: nil
/**=======================================================
 - 뷰컨트롤러를 오래동안 잡아두지 않음
 - 뷰컨트롤러가 사라지면 ===> 출력하는 일을 계속하지 않도록 할 수 있음
   (if let 바인딩 또는 guard let 바인딩까지 더해서 return 가능하도록)
=========================================================**/



// ========================================================================
// ========================================================================


// 작업을 오랫동안 실행하는 함수가 있다고 가정
func longtimePrint(name: String) -> String {
    print("프린트 - 1")
    sleep(1)
    print("프린트 - 2")
    sleep(1)
    print("프린트 - 3 이름:\(name)")
    sleep(1)
    print("프린트 - 4")
    sleep(1)
    print("프린트 - 5")
    return "작업 종료"
}

longtimePrint(name: "잡스")
// 프린트 - 1
// 프린트 - 2
// 프린트 - 3 이름:잡스
// 프린트 - 4
// 프린트 - 5


// 동기함수를 비동기함수로 만들기!
// 작업을 오랫동안 실행하는데, 동기적으로 동작하는 함수를
// 비동기적으로 동작하도록 만들어, 반복적으로 사용하도록 만들기
// 내부적으로 다른 큐로 비동기적으로 보내서 처리
func asyncLongtimePrint(name: String, completion: @escaping (String) -> Void) {
    DispatchQueue.global().async {
        let n = longtimePrint(name: name)
        completion(n)
    }
}

//asyncLongtimePrint(name: "잡스", completion: <#T##(String) -> Void#>)

asyncLongtimePrint(name: "잡스") { (result) in
    print(result)
    
    // 메인쓰레드에서 처리해야하는 일이라면,
//    DispatchQueue.main.async {
//        print(result)
//    }
}



// ========================================================================
// ========================================================================


// URLSession은 비동기 메서드!
// API중에는 내부적으로 비동기처리가 된 메서드들이 존재
let movieURL = "https://bit.ly/2QF3ID2"

// 1. URL 구조체 만들기
let url = URL(string: movieURL)!

// 2. URLSession 만들기 (네트워킹을 하는 객체 - 브라우저 같은 역할)
let session = URLSession.shared

// 3. 세션에 (일시정지 상태로)작업 부여
let task = session.dataTask(with: url) { (data, response, error) in
    if error != nil {
        print(error!)
        return
    }

    guard let safeData = data else {
        return
    }

    print(String(decoding: safeData, as: UTF8.self))

}

// 4.작업시작
task.resume()   // 일시정지된 상태로 작업이 시작하기 때문

// URLSession 사용하기! ➡︎ 내부적으로 비동기 동작한다는 것을 알고 써야함
print("출력 - 1")

URLSession.shared.dataTask(with: url) { (data, response, error) in
    if error != nil {
        print(error!)
        return
    }
    
    guard let safeData = data else {
        return
    }
    
    print(String(decoding: safeData, as: UTF8.self))
    
}.resume()

print("출력 - 2")


// 출력 - 1
// 출력 - 2
// ... data



// ========================================================================
// ========================================================================


// 동시큐에서 직렬큐로 보내기
// Thread-safe하지 않을때, 처리하는 방법

// 배열은 여러쓰레드에서 동시에 접근하면 문제가 생길 수 있다.
var array = [String]()

let serialQueue = DispatchQueue(label: "serial")

for i in 1...20 {
    DispatchQueue.global().async {
        print("\(i)")
        //array.append("\(i)")    //  <===== 동시큐에서 실행하면 동시다발적으로 배열의 메모리에 접근
        
        serialQueue.async {        // 올바른 처리 ⭐️
            array.append("\(i)")
        }
    }
}
























sleep(4)
// 작업이 종료되었으니 플레이그라운드 실행 종료 Ok.
PlaygroundPage.current.finishExecution()
