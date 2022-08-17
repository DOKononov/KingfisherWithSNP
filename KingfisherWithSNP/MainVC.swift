//
//  MainVC.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import UIKit
import SnapKit
import Kingfisher

class MainVC: UIViewController {
    
    let urlStr = "https://unsplash.com/photos/Vi03Hj9EzQw/download?ixid=MnwxMjA3fDB8MXxhbGx8OHx8fHx8fDJ8fDE2NjA3NDg0MTI&force=true&w=640"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setupLayouts()
        guard let url = URL(string: urlStr) else {return}
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource, placeholder: nil, options: nil, completionHandler: nil)
    }
    

    private func addSubViews() {
        self.view.addSubview(imageView)
    }
    private func setupLayouts() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view).offset(20)
            make.bottom.trailing.equalTo(self.view).offset(-20)
        }
    }

}
