//
//  MainVC.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    private var viewModel: MainVCProtocol = MainVCViewModel()
    
    private  var collectionMargin: CGFloat = 32
    private  var collectionInset: CGFloat = 16
    private lazy var cellWidth: CGFloat = 0 {
        didSet {
            cellHeight = cellWidth * 1.7
        }
    }
    private lazy var cellHeight: CGFloat = 0
    private var currentPage = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        cellWidth = ScreenSize.shared.screenWidth - collectionMargin * 2
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = collectionInset
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        
        collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "\(MainCollectionCell.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    var welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Начни свой день с цитаты!"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var firstCircle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = ScreenSize.shared.screenWidth(1.4) / 2
        circle.backgroundColor = UIColor(red: 176 / 255, green: 128 / 255, blue: 246 / 255, alpha: 1)
        
        return circle
    }()
    
    var secondCircle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = ScreenSize.shared.screenWidth(1.1) / 2
        circle.backgroundColor = UIColor(red: 219 / 255, green: 199 / 255, blue: 247 / 255, alpha: 0.9)
        
        return circle
    }()
    
    var continueButtom: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 248 / 255, green: 134 / 255, blue: 250 / 255, alpha: 1)
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayout()
        setupAppearence()
        bind()
        viewModel.loadSaings()
    }
    
    
    private func addSubviews() {
        view.addSubview(firstCircle)
        view.addSubview(secondCircle)
        view.addSubview(collectionView)
        view.addSubview(welcomLabel)
        view.addSubview(continueButtom)
        
    }
    
    private func setupLayout() {
        
        welcomLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        continueButtom.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(continueButtom.snp.top).offset(-16)
            make.top.equalTo(welcomLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        firstCircle.snp.makeConstraints { make in
            make.centerX.equalTo(view.center.x).offset(ScreenSize.shared.screenWidth(0.1))
            make.centerY.equalTo(view.frame.minY).offset(ScreenSize.shared.screenWidth(0.2))
            make.height.equalTo(ScreenSize.shared.screenWidth(1.4))
            make.width.equalTo(ScreenSize.shared.screenWidth(1.4))
        }
        
        secondCircle.snp.makeConstraints { make in
            make.centerX.equalTo(view.center.x).offset(ScreenSize.shared.screenWidth(0.9))
            make.centerY.equalTo(firstCircle.center.y).offset(ScreenSize.shared.screenWidth(0.8))
            make.height.equalTo(ScreenSize.shared.screenWidth(1.1))
            make.width.equalTo(ScreenSize.shared.screenWidth(1.1))
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
        cell?.layer.cornerRadius = 20
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
