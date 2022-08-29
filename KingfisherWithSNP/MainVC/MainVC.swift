//
//  MainVC.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    //var?
    // в bind() переопределяем contentDidChanged()
    private var viewModel: MainVCProtocol = MainVCViewModel()
    //var?
    //исправил
    private let collectionMargin: CGFloat = 32
    private let collectionInset: CGFloat = 16
    //
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 64
    //почему lazy?
    // исправил
    private let cellHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    private var currentPage = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //я бы засетал это сразу в свойстве
//        cellWidth = ScreenSize.shared.screenWidth - collectionMargin * 2
        
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
        collection.backgroundColor = .clear
        
        collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "\(MainCollectionCell.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //зачем var, если это не lazy
    private let welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Начни свой день с цитаты!"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //с этим прикольно что запарился, но в целом обычно это будет бэковая картинка)
    private let firstCircle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = ScreenSize.shared.screenWidth(1.4) / 2
        circle.backgroundColor = UIColor(red: 176 / 255, green: 128 / 255, blue: 246 / 255, alpha: 1)
        return circle
    }()
    
    private let secondCircle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = ScreenSize.shared.screenWidth(1.1) / 2
        circle.backgroundColor = UIColor(red: 219 / 255, green: 199 / 255, blue: 247 / 255, alpha: 0.9)
        return circle
    }()
    
    private let continueButtom: UIButton = {
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.equalToSuperview().offset(collectionInset)
            make.trailing.equalToSuperview().offset(-collectionInset)
        }
        
        continueButtom.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-collectionInset)
            make.leading.equalToSuperview().offset(collectionInset)
            make.trailing.equalToSuperview().offset(-collectionInset)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(continueButtom.snp.top).offset(-collectionInset)
            make.top.equalTo(welcomLabel.snp.bottom).offset(collectionInset)
            make.height.equalTo(cellHeight)
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
        //здесь потенциальный retain cycle (но почему то не могу отследить, хотя все факты на лицо). Сможешь объяснить почему он здесь есть или его нет?))
        //сегда так работал с MVVM. Никогда не сталкивался с проблемами при этом. Предположу что есть риск возникновения дедлока и необходимо добавить [weak self]?
        viewModel.contentDidChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
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
        //это лучше засетапить в самой ячейке, но не обязательно. Зависит от кейса. Просто возьми за правило стараться максимально освобождать контроллер.
        //согласен. убрал в setupCell()
//        cell?.layer.cornerRadius = 20
        return cell ?? UICollectionViewCell()
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = cellWidth + collectionInset
        var newPage = currentPage

        if velocity.x != 0 {
            newPage = velocity.x > 0 ? currentPage + 1 : currentPage - 1
            if newPage < 0 {
                newPage = viewModel.saings.count - 1
            }
            if newPage > viewModel.saings.count - 1 {
                newPage = 0
            }
        }

        currentPage = newPage
        let point = CGPoint (x: CGFloat(newPage) * pageWidth, y: 0)
        targetContentOffset.pointee = point
        
    }
    
}
