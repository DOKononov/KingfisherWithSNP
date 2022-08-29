//
//  MainVCViewModel.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import Foundation

protocol MainVCProtocol {
    var saings: [SayingModel] { get set }
    //можно возвращать () -> () вместо () -> Void. Возможно так симпотичнее))
    //знаю, но мне такая запись больше нравиться тк нет месива из скобок
    var contentDidChanged: (() -> Void)? { get set }
    func loadSaings()
}

final class MainVCViewModel: MainVCProtocol {
    
    var saings: [SayingModel] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    //можно возвращать () -> () вместо () -> Void. Возможно так симпотичнее))
    //знаю, но мне такая запись больше нравиться тк нет месива из скобок
    var contentDidChanged: (() -> Void)?
    
    func loadSaings() {
        NetworkService.shared.loadSaings { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let saings):
                self.saings = saings.filter({ $0.lang == .ru})
            }
        }
    }
    
}
