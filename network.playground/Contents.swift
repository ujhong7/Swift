import UIKit

// JSON데이터를 스위프트 코드로 변환
// https://app.quicktype.io/

// 세션 -> 연결상태 유지 (영어 뜻: 기간,시간)
// 일정 시간동안 같은 브라우저(사용자)로부터 들어오는 연결 상태를 일정하게 유지시키는 기술(상태)


// 네트워크 통신(서버와의 통신)의 기초
// 요청(request) -> 서버데이터(JSON) -> 분석(parse) -> 변환(우리가 쓰려는 Struct/Class)



// ⭐️ 서버에서 주는 데이터의 형태 ================================

struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let rank: String
    let movieNm: String
    let audiCnt: String
    let audiAcc: String
    let openDt: String
}


// ⭐️ 내가 만들고 싶은 데이터 (우리가 쓰려는 Struct/Class) ===========
struct Movie {
    static var movieId: Int = 0   // 아이디가 하나씩 부여되도록 만듦
    let movieName: String
    let rank: Int
    let openDate: String
    let todayAudience: Int
    let totalAudience: Int
    
    init(movieNm: String, rank: String, openDate: String, audiCnt: String, accAudi: String) {
        self.movieName = movieNm
        self.rank = Int(rank)!
        self.openDate = openDate
        self.todayAudience = Int(audiCnt)!
        self.totalAudience = Int(accAudi)!
        Movie.movieId += 1
    }
}
// ========================================================







// ⭐️ 서버와 통신 ============================================

struct MovieDataManager{
    
    // 0. URL 주소
    let movieURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    let myKey = "7a526456eb8e084eb294715e006df16f"
    
    func fetchMovie(date: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(movieURL)&key=\(myKey)&targetDt=\(date)"
        performRequest(with: urlString) { movies in
            completion(movies)
        }
    }
    
    func performRequest(with urlString: String, completion: @escaping ([Movie]?) -> Void) {
        print(#function)
        
        // 1. URL 구조체 만들기
        guard let url = URL(string: urlString) else { return }
        
        // 2. URLSession 만들기 (네트워킹을 하는 객체 - 브라우저 같은 역할)
        let session = URLSession(configuration: .default)
        
        // 3. 세션에 작업 부여
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                completion(nil)
                return
            }
            
            
            // 데이터 분석하기
            if let movies = self.parseJSON1(safeData) {
                //print("parse")
                completion(movies)
            } else {
                completion(nil)
            }
        }
        
        // 4.Start the task
        task.resume()   // 일시정지된 상태로 작업이 시작하기 때문
    }
    
    
    
    // ⭐️ 받아온 데이터를 우리가 쓰기 좋게 변환하는 과정 (분석) ================================

    func parseJSON1(_ movieData: Data) -> [Movie]? {
        print(#function)
        
        let decoder = JSONDecoder()
        
        do {
            // 스위프트5
            // 자동으로 원하는 클래스/구조체 형태로 분석
            // JSONDecoder
            
            
            let decodedData = try decoder.decode(MovieData.self, from: movieData)

            let dailyLists = decodedData.boxOfficeResult.dailyBoxOfficeList
            
            
            // 고차함수를 이용해 movie배열 생성 ⭐️
            let myMovielists = dailyLists.map {
                Movie(movieNm: $0.movieNm, rank: $0.rank, openDate: $0.openDt, audiCnt: $0.audiCnt, accAudi: $0.audiAcc)
            }
            
            return myMovielists
            
        } catch {
            //print(error.localizedDescription)
            
            // (파싱 실패 에러)
            print("파싱 실패")
            
            return nil
        }
    }
}

// ========================================================





// 뷰컨트롤러에서 일어나는 일

// 빈 배열
var downloadedMovies = [Movie]()

// 데이터를 다운로드 및 분석/변환하는 구조체
let movieManager = MovieDataManager()

// 실제 다운로드 코드
movieManager.fetchMovie(date: "20210201") { movies in
    
    if let movies = movies{
        
        // 배열 받아서 빈배열 넣기
        downloadedMovies = movies
        dump(downloadedMovies)
        
        print("전체 영화 갯수 확인: \(Movie.movieId)")
    }else{
        print("영화데이터가 없습니다. 또는 다운로드에 실패했습니다.")
    }
}











