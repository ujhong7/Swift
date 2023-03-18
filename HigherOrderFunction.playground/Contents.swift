import UIKit

// 고차함수

/*
 - 고차원의 함수
 - 함수를 파라미터로 사용하거나, 함수실행의 결과를 함수로 리턴하는 함수
 
 - 일반적으로 함수형 언어를 지향하는 언어들에 기본적으로 구현되어 있음
 
 - 1) map
 - 2) filter
 - 3) reduce
 
 - 추가적으로: forEach, compactMap, flatMap
 
 - Sequence, Collection 프로토콜을 따르는 컬렉션 (배열,딕셔너리,세트 등)에 기본적으로 구현되어 있는 함수
 - Optional타입에도 구현되어 있음
 */


// ====================================================

//  ⭐️ map 함수
//  - 기존 배열등의 각 아이템을 새롭게 매핑해서(매핑방식은 클로저가 제공)
//    새로운 배열을 리턴하는 함수
//  - 각 아이템을 매핑, 변형해서 새로운 배열을 만들때 사용

let numbers = [1, 2, 3, 4, 5]
// numbers.map(<#T##transform: (Int) throws -> T##(Int) throws -> T#>)

var newNumbers = numbers.map { num in
    return "숫자: \(num)"
}

newNumbers = numbers.map{ "숫자: \($0)" }
print(newNumbers)   // ["숫자: 1", "숫자: 2", "숫자: 3", "숫자: 4", "숫자: 5"]



var alphabet = ["A", "B", "C", "D"]
// names.map(<#T##transform: (String) throws -> T##(String) throws -> T#>)

var newAlphabet = alphabet.map { (name) -> String in
    return name + "'s good'"
}
print(newAlphabet) // ["A's good'", "B's good'", "C's good'", "D's good'"]
                         

// ====================================================


// ⭐️ filter 함수
// - 기존 배열 등의 각 아이템 조건(조건은 클로저가 제공)을 확인 후,
//   참(true)을 만족하는 아이템을 걸러내서 새로운 배열을 리턴
// - (각 아이템을 필터링해서, 걸러내서 새로운 배열을 만들때 사용)

let names = ["Apple", "Black", "Circle", "Dream", "Blue"]
// names.filter(<#T##isIncluded: (String) throws -> Bool##(String) throws -> Bool#>)

var newNames = names.filter { (name) -> Bool in
    return name.contains("B")
}
print(newNames) // ["Black", "Blue"]


let array = [1, 2, 3, 4, 5, 6, 7, 8]
var evenNumberArray = array.filter { num in
    return num % 2 == 0
}

evenNumberArray = array.filter{ $0 % 2 == 0}
print(evenNumberArray) // [2, 4, 6, 8]

evenNumberArray = array.filter{ $0 % 2 == 0}.filter{ $0 < 5}
print(evenNumberArray) // [2, 4]


// ====================================================


// ⭐️ reduce 함수
// - 기존 배열 등의 각 아이템을 클로저가 제공하는 방식으로 결합해서
//   마지막 결과값을 리턴 (초기값 제공할 필요)
// - 각 아이템을 결합해서 단 하나의 값으로 리턴


var numbersArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

//numbersArray.reduce(<#T##initialResult: Result##Result#>, <#T##nextPartialResult: (Result, Int) throws -> Result##(Result, Int) throws -> Result#>)

var resultSum = numbersArray.reduce(0) { (sum, num) in
    return sum + num
}

print(resultSum) // 55

resultSum = numbersArray.reduce(100) { $0 - $1 }

print(resultSum) // 45

// ====================================================


// ⭐️ map / filter / reduece 의 활용

numbersArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 위의 배열 중에, 홀수만 제곱해서, 그 숫자를 다 더한 값은?
var newResult = numbersArray
                        .filter { $0 % 2 != 0 }
                        .map { $0 * $0 }
                        .reduce(0) { $0 + $1 }

print(newResult)


// 1, 9, 25, 49, 81 ===> 165



// ====================================================
// ====================================================


// ⭐️ forEach 함수

// - 기존 배열 등의 각 아이템을 활용해서
//   각 아이템별로 특정 작업(작업 방식은 클로저가 제공)을 실행
// - (각 아이템을 활용해서 각각 특정 작업을 실행할때 사용)

let immutableArray = [1, 2, 3, 4, 5]


immutableArray.forEach { num in
    print(num)
}

immutableArray.forEach { print("숫자: \($0)") }

// 숫자: 1
// 숫자: 2
// 숫자: 3
// 숫자: 4
// 숫자: 5

// ====================================================

// ⭐️ compactMap 함수

// - 기존 배열 등의 각 아이템을 새롭게 매핑해서(매핑방식은 클로저가 제공)
//   변형하되, 옵셔널 요소는 제거하고, 새로운 배열을 리턴
// - (map + 옵셔널제거)
// - 옵셔널은 빼고, 컴팩트(compact)하게
// - (옵셔널 바인딩의 기능까지 내장)

let stringArray: [String?] = ["A", nil, "B", nil, "C"]
var newStringArray = stringArray.compactMap { $0 }
print(newStringArray) // ["A", "B", "C"]


let numberss = [-2, -1, 0, 1, 2]
var positiveNumbers = numberss.compactMap { $0 >= 0 ? $0 : nil }

print(positiveNumbers) // [0, 1, 2]

// 사실 이런 경우는 filter로 가능
//numbers.filter { $0 >= 0 }

// compactMap은 아래와 같은 방식으로도 구현 가능
newStringArray = stringArray.filter { $0 != nil }.map { $0! }
print(newStringArray) // ["A", "B", "C"]


