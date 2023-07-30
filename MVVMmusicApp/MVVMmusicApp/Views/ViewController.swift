//
//  ViewController.swift
//  MVVMmusicApp
//
//  Created by yujaehong on 2023/07/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var viewModel: MusicViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MusicViewModel()
        
        // 데이터 변경이 완료된 후, 클로저에서 어떤 일을 할지 정의 (할당)
        self.viewModel.onCompleted = { [weak self] _ in
            DispatchQueue.main.async {
                self?.albumNameLabel.text = self?.viewModel.albumNameString
                self?.songNameLabel.text = self?.viewModel.songNameString
                self?.artistNameLabel.text = self?.viewModel.artistNameString
            }
        }
        
    }


    @IBAction func startButtonTapped(_ sender: UIButton) {
        viewModel.handleButtonTapped()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard viewModel.music != nil else { return }
        
        // 다음 화면의 뷰컨트롤러가 가져야 하는 뷰모델
        let detailVM = DetailViewModel()
        
        // 뷰모델들이 가져야 하는 데이터
        detailVM.music = viewModel.music
        detailVM.imageURL = viewModel.music?.imageUrl
        
        // 다음 화면 뷰컨트롤러
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        // 뷰모델 전달
        detailVC.viewModel = detailVM
        
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true)
    }
    
    // 
}

