//
//  DetailViewController.swift
//  MVVMmusicApp
//
//  Created by yujaehong on 2023/07/29.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        viewModel.onCompleted = { [weak self] albumImage in
            self?.albumImageView.image = albumImage
        }
        songNameLabel.text = viewModel.songNameString
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
