//
//  MusicViewModel.swift
//  MVVMmusicApp
//
//  Created by yujaehong on 2023/07/29.
//

import Foundation

class MusicViewModel {
    
    let apiManager = APIService()
    
    // 핵심 데이터(모델) (⭐️뷰모델이가지고있다⭐️)
    var music: Music? {
        didSet {
            onCompleted(self.music)
        }
    }
    
    // 뷰를 위한 데이터 (Output)
    var albumNameString: String? {
        return music?.albumName
    }
    var songNameString: String? {
        return music?.songName
    }
    var artistNameString: String? {
        return music?.artistName
    }
    
    var onCompleted: (Music?) -> Void = { _ in }
    
    // Input
    func handleButtonTapped() {
        apiManager.fetchMusic { [weak self] result in
            switch result {
            case .success(let musics):
                // 데이터 생성 완료 (API를 통해 다운로드 -> 파싱완료된)
                self?.music = musics.first
            case .failure(let error):
                switch error {
                case .dataError:
                    print("데이터 에러")
                case .networkingError:
                    print("네트워킹 엘")
                case .parseError:
                    print("파싱 에러")
                }
            }
        }
    }
    
}
