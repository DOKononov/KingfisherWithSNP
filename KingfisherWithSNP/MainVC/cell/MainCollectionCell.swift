//
//  MainCollectionCell.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 18.08.22.
//

import UIKit
import Kingfisher

final class MainCollectionCell: UICollectionViewCell {
        
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let sayingLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupCell(with saying: SayingModel) {
        self.backgroundColor = .white
        addSubviews()
        setupLayout()
        loadImage(saying: saying)
        layer.cornerRadius = 20
        sayingLabel.text = saying.text
        saying.author != "" ? (authorLabel.text = saying.author) : (authorLabel.text = "no name")
    }
    
    private func addSubviews() {
        self.addSubview(imageView)
        self.addSubview(sayingLabel)
        self.addSubview(authorLabel)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(imageView.snp.width)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(authorLabel.font.lineHeight)
            make.top.greaterThanOrEqualTo(sayingLabel.snp.bottom).offset(16)
        }
        
        sayingLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        sayingLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func loadImage(saying: SayingModel) {
        imageView.kf.indicatorType = .activity
        guard let url = URL(string: saying.image) else {return}
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource, placeholder: nil, options: nil) { result in
            switch result {
            case .failure(_):
                self.imageView.image = UIImage(named: "imagePlaceholder")
            case .success(_):
                break
            }
        }
    }
}
