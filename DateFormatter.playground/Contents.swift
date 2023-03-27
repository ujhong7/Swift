import UIKit



// DateFormatter

// 날짜와 시간을 원하는 형식의 문자열(String)으로 변환하는 방법을 제공하는 클래스
// RFC 3339 표준으로 작성 (스위프트가 아닌 다른 표준을 사용)


// Date를 특정형식의 문자열로 변환하려면 ➞ (1)지역설정 + (2)시간대설정 + (3)날짜형식 + (4)시간형식

// 날짜 + 시간  <======>  String
let formatter = DateFormatter()

/**==========================================
 (1) 지역 설정
============================================**/

// 나라 / 지역마다 날짜와 시간을 표시하는 형식과 언어가 다름
//formatter.locale = Locale(identifier: "ko_KR")
// "2021년 5월 8일 토요일 오후 11시 44분 24초 대한민국 표준시"

formatter.locale = Locale(identifier: "en_US")
// "Saturday, May 8, 2021 at 11:45:51 PM Korean Standard Time"

/**==========================================
 (2) 시간대 설정(기본설정이 있긴 하지만)
============================================**/

formatter.timeZone = TimeZone.current


// ===========================================================================
// ===========================================================================


// 표시하려는 날짜와 시간 설정

/**==========================================
  1) (애플이 미리 만들어 놓은) 기존 형식으로 생성
============================================**/
 
// (1) 날짜 형식 선택
formatter.dateStyle = .full           // "Tuesday, April 13, 2021"
//formatter.dateStyle = .long         // "April 13, 2021"
//formatter.dateStyle = .medium       // "Apr 13, 2021"
//formatter.dateStyle = .none         // (날짜 없어짐)
//formatter.dateStyle = .short        // "4/13/21"


// (2) 시간 형식 선택
formatter.timeStyle = .full           // "2:53:12 PM Korean Standard Time"
//formatter.timeStyle = .long         // "2:54:52 PM GMT+9"
//formatter.timeStyle = .medium       // "2:55:12 PM"
//formatter.timeStyle = .none         // (시간 없어짐)
//formatter.timeStyle = .short        // "2:55 PM"


// 실제 변환하기 (날짜 + 시간) ===> 원하는 형식
let someString1 = formatter.string(from: Date())
print(someString1)



/**==========================================
  2) 커스텀 형식으로 생성
============================================**/

//formatter.locale = Locale(identifier: "ko_KR")
//formatter.dateFormat = "yyyy/MM/dd"
formatter.dateFormat = "yyyy년 MMMM d일 (E)"


let someString2 = formatter.string(from: Date())
print(someString2)                  // 2023년 March 28일 (Tue)


// 문자열로 만드는 메서드
//formatter.string(from: <#T##Date#>)
 



/**==============================================================================================
 - 날짜/시간 형식: http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns (유니코드에서 지정)
 ===============================================================================================**/


// 반대로, (형식)문자열에서 Date로 변환하는 것도 가능
let newFormatter = DateFormatter()
newFormatter.dateFormat = "yyyy/MM/dd"

let someDate = newFormatter.date(from: "2021/07/12")!
print(someDate)


// ===========================================================================
// ===========================================================================


// 두 날짜 범위 출력 코드 구현
let start = Date()                                  // "Mar 28, 2023 at 1:01 AM"
let end = start.addingTimeInterval(3600 * 24 * 60)  // "May 27, 2023 at 1:01 AM"


let formatter2 = DateFormatter()
formatter2.locale = Locale(identifier: "ko_KR")
formatter2.timeZone = TimeZone.current
//formatter2.timeZone = TimeZone(identifier: "Asia/Seoul")

formatter2.dateStyle = .long
formatter2.timeStyle = .none


print("기간: \(formatter2.string(from: start)) - \(formatter2.string(from: end))")
// 기간: 2023년 3월 28일 - 2023년 5월 27일



// ===========================================================================
// ===========================================================================



// 프로젝트에서 활용예시
struct InstagramPost {
    let title: String = "제목"
    let description: String = "내용설명"
    
    private let date: Date = Date()  // 게시물 생성을 현재날짜로
    
    // 날짜를 문자열 형태로 바꿔서 리턴하는 계산 속성
    var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            //formatter.locale = Locale(identifier: Locale.autoupdatingCurrent.identifier)
            
            // 애플이 만들어 놓은
            formatter.dateStyle = .medium
            formatter.timeStyle = .full
            
            // 개발자가 직접 설정한
            //formatter.dateFormat = "yyyy/MM/dd"
            
            return formatter.string(from: date)
        }
    }
}


let post1 = InstagramPost()
print(post1.dateString)         // 2023. 3. 28. 오전 1시 8분 19초 대한민국 표준시


// ===========================================================================

// DateComponents를 활용해, 원하는 특정날짜/시간 생성하기

var components = DateComponents()    // 구조체 (날짜/시간의 요소들을 다룰 수 있는)
components.year = 2021
components.month = 1
components.day = 1

components.hour = 12
components.minute = 30
components.second = 0


let specifiedDate: Date = Calendar.current.date(from: components)!      // "Jan 1, 2021 at 12:30 PM"
print(specifiedDate)                                                    // "2021-01-01 03:30:00 +0000\n"




// 조금 더 세련된 방식으로 구현
// 구조체의 확장이용해서 Date에 생성자 구현

extension Date {
    // 구조체 실패가능 생성자로 구현
    init?(y year: Int, m month: Int, d day: Int) {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil  // 날짜 생성할 수 없다면 nil리턴
        }
        
        self = date      //구조체이기 때문에, self에 새로운 인스턴스를 할당하는 방식으로 초기화가능
    }
}




let someDate = Date(y: 2021, m: 1, d: 1)      // 특정날짜(시점) 객체 생성
let someDate2 = Date(y: 2021, m: 7, d: 10)
