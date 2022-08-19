//
//  SaingsModel.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import Foundation

final class SayingsResponce: Codable {
    let status: String
    let data: [SayingModel]
}

final class SayingModel: Codable {
    let id: Int
    let text, author: String
    let image: String
    var lang: Lang
}

enum Lang: String, Codable {
    case en = "en"
    case ru = "ru"
}
