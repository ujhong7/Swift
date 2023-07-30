//
//  DetailViewController.swift
//  MVCmusicApp
//
//  Created by yujaehong on 2023/07/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    
    var apiManager: APIService?
    
    var songName: String?
    // 이미지 주소만 전달받고, 화면에 들어오면 다운로드 시작
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        self.songNameLabel.text = self.songName
        
        // 이미지 다운로드 (API매니저 사용)
        apiManager?.loadImage(imageURL: self.imageURL, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.albumImageView.image = image
            }
        })
    }

    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

