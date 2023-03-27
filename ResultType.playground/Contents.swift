import UIKit



// Result타입

/**======================================================
 - 에러가 발생하는 경우, 에러를 따로 외부로 던지는 것이 아니라
 - 리턴 타입 자체를 Result Type(2가지를 다 담을 수 있는)으로 구현해서
 - 함수 실행의 성공과 실패의 정보를 함께 담아서 리턴


 - 실제 Result타입의 내부 구현
 - enum Result<Success, Failure> where Failure : Error
 - https://developer.apple.com/documentation/swift/result


 - Result타입은 열거형
 - case success(연관값)
 - case failure(연관값)
 ========================================================**/


// 에러 정의 (어떤 에러가 발생할지 경우를 미리 정의)
enum HeightError: Error {    //에러 프로토콜 채택 (약속)
    case maxHeight
    case minHeight
}


// throwing함수 (앞에서 배운)
func checkingHeight(height: Int) throws -> Bool {    // (에러를 던잘수 있는 함수 타입이다)
    
    if height > 190 {
        throw HeightError.maxHeight
    } else if height < 130 {
        throw HeightError.minHeight
    } else {
        if height >= 160 {
            return true
        } else {
            return false
        }
    }
}

//
do {
    let _ = try checkingHeight(height: 200)
    print("놀이기구 타는 것 가능")
} catch {
    print("놀이기구 타는 것 불가능")
}


// Result타입을 활용한 에러의 처리
// 에러는 동일하게 정의되어 있다고 가정
// Result타입에는 성공/실패했을 경우에 대한 정보가 다 들어있음
func resultTypeCheckingHeight(height: Int) -> Result<Bool, HeightError> {
    
    if height > 190 {
        return Result.failure(HeightError.maxHeight)
    } else if height < 130 {
        return Result.failure(HeightError.minHeight)
    } else {
        if height >= 160 {
            return Result.success(true)
        } else {
            return Result.success(false)
        }
    }
}

// 리턴값을 받아서
let result = resultTypeCheckingHeight(height: 200)


// 처리
switch result {
case .success(let data):
    print("결과값은 \(data)입니다.")
case .failure(let error):
    print(error)
}




// Result타입의 다양한 활용
// Result타입에는 여러메서드가 존재
// get()메서드는 결과값을 throwing함수처럼 변환가능한 메서드 (Success밸류를 리턴)

do {
    let data = try result.get()
    print("결과값은 \(data)입니다.")
} catch {
    print(error)
}


/**==================================================
 - Result타입을 왜 사용할까?
 
 - 성공/실패의 경우를 깔끔하게 처리가 가능한 타입

 - 기존의 에러처리 패턴을 완전히 대체하려는 목적이 아니라
   개발자에게 에러 처리에 대한 다양한 처리 방법에 대한 옵션을 제공
 ====================================================**/




// ==========================================================================================
// ==========================================================================================




// 네트워킹 코드에서 Reslt타입!

enum NetworkError: Error {
    case someError
}




// 🔴 Result 타입 사용 전
// 튜플타입을 활용, 데이터 전달
func performRequest(with url: String, completion: @escaping (Data?, NetworkError?) -> Void) {
    
    guard let url = URL(string: url) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!)                 // 에러가 발생했음을 출력
            completion(nil, .someError)   // 에러가 발생했으니, nil 전달
            return
        }
        
        guard let safeData = data else {
            completion(nil, .someError)   // 안전하게 옵셔널 바인딩을 하지 못했으니, 데이터는 nil 전달
            return
        }
    
        completion(safeData, nil)
        
    }.resume()
}


performRequest(with: "주소") { data, error in
    // 데이터를 받아서 처리
    if error != nil {
        print(error!)
    }
    
    // 데이터 처리 관련 코드
    
}





// 🔵 Result 타입 사용 후
func performRequest2(with urlString: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!)                     // 에러가 발생했음을 출력
            completion(.failure(.someError))  // 실패 케이스 전달
            return
        }
        
        guard let safeData = data else {
            completion(.failure(.someError))   // 실패 케이스 전달
            return
        }
    
        completion(.success(safeData))      // 성공 케이스 전달
       
        
    }.resume()
}


performRequest2(with: "주소") { result in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        // 데이터 처리 관련 코드
        break
    }
}
