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












































sleep(4)
// 작업이 종료되었으니 플레이그라운드 실행 종료 Ok.
PlaygroundPage.current.finishExecution()
