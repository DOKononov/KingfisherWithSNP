//
//  MainVC.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import UIKit
import SnapKit
//import Kingfisher

class MainVC: UIViewController {
    
    private var viewModel: MainVCProtocol = MainVCViewModel()
    
    private lazy var collectionMargin: CGFloat = 40
    private lazy var collectionInset: CGFloat = 20
    private lazy var cellWidth: CGFloat = 0 {
        didSet {
            cellHeight = cellWidth * 1.3
        }
    }
    private lazy var cellHeight: CGFloat = 0
    private var currentPage = 0
    
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        cellWidth = UIScreen.main.bounds.width - collectionMargin * 2
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = collectionInset
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.backgroundColor = .green
        collection.showsHorizontalScrollIndicator = false
        
        collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "\(MainCollectionCell.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayout()
        setupAppearence()
        bind()
        viewModel.loadSaings()
        print(viewModel.saings.count)
        
    }
    
    
    private func addSubviews() {
        self.view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupAppearence() {
        self.view.backgroundColor = UIColor(red: 244 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    }
    
    private func bind() {
        viewModel.contentDidChanged = {
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - CollectionView
extension MainVC: UICollectionViewDelegate,  UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.saings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCollectionCell.self)", for: indexPath) as? MainCollectionCell
        cell?.setupCell(with: viewModel.saings[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = cellWidth + collectionInset
        let targetXContentOffset = targetContentOffset.pointee.x
        let contentWidth = collectionView.contentSize.width
        var newPage = CGFloat(currentPage)
        
        if velocity.x == 0 {
            newPage = ( targetXContentOffset - pageWidth / 2.0 ) / pageWidth + 1.0
        } else {
            newPage = CGFloat(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            
            if newPage < 0 {
                newPage = 0
            }
            
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth - 1)
            }
        }
        currentPage = Int(newPage)
        let point = CGPoint(x: newPage * pageWidth, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }

}
