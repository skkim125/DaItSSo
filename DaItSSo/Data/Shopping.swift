//
//  Shopping.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

struct Shopping: Codable {
    let total: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let image: String
    let mallName: String
    let lprice: String
    let link: String
}

struct Save: Codable {
    let item: Item
    let save: Bool
}
