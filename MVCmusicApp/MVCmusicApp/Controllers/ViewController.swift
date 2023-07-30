//
//  ViewController.swift
//  MVCmusicApp
//
//  Created by yujaehong on 2023/07/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    let apiManager = APIService()
    
    // 데이터(모델) (일반적으로 뷰컨트롤러가 가지고 있다) ⭐️⭐️⭐️
    var music: Music? {
        didSet {
            DispatchQueue.main.async {
                self.configureUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureUI() {
        self.albumNameLabel.text = self.music?.albumName
        self.songNameLabel.text = self.music?.songName
        self.artistNameLabel.text = self.music?.artistName
    }
    
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        apiManager.fetchMusic { [weak self] result in
            switch result {
            case .success(let music):
                self?.music = music
            case .failure(let error):
                switch error {
                case .dataError:
                    print("데이터 에러")
                case .networkingError:
                    print("네트워킹 에러")
                case .parseError:
                    print("파싱 에러")
                }
            }
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        guard let music = self.music else { return }
        
        // 스토리보드 인스턴스 생성
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.modalPresentationStyle = .fullScreen
        
        // 네트워킹 매니저 전달 (힙 주소 복사해서 전달)
        detailVC.apiManager = self.apiManager
        
        // 다음화면에서 필요한 데이터 전달 ⭐️
        detailVC.songName = music.songName
        detailVC.imageURL = music.imageUrl
        
        self.present(detailVC, animated: true)
    }
    
    //. 
}

