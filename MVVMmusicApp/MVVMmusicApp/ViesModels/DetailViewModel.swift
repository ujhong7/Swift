//
//  DetailViewModel.swift
//  MVVMmusicApp
//
//  Created by yujaehong on 2023/07/29.
//

import UIKit

class DetailViewModel {
    
    var music: Music?
    
    var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    // 뷰를 위한 데이터 (Output)
    var albumImage: UIImage? {
        didSet {
            onCompleted(albumImage)
        }
    }
    
    // Output
    var songNameString: String? {
        return music?.songName
    }
    
    var onCompleted: (UIImage?) -> Void = { _ in }
    
    
    // Logic (기타 순수 로직 등) (APIService에 위치시켜도 됨)
    func loadImage() {
        guard let urlString = self.imageURL,
              let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.albumImage = image
            }
        }
    }
    
}
