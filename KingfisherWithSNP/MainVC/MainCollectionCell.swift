//
//  MainCollectionCell.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 18.08.22.
//

import UIKit

class MainCollectionCell: UICollectionViewCell {
    
    static var cellWidth: CGFloat = UIScreen.main.bounds.width - 40.0
    
    func setupCell(with saying: SayingModel) {
        self.backgroundColor = .black
    }
}
