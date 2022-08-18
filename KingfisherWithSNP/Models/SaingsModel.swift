//
//  SaingsModel.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import Foundation

struct SayingsResponce: Codable {
    let status: String
    let data: [SayingModel]
}

struct SayingModel: Codable {
    let id: Int
    let text, author: String
    let image: String
    var lang: Lang
}

enum Lang: String, Codable {
    case en = "en"
    case ru = "ru"
}
