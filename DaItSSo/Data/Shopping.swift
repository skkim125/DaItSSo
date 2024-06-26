//
//  Shopping.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

struct Shopping: Decodable {
    let total: Int
    let items: [Item]
}

struct Item: Hashable, Codable {
    let title: String
    let image: String
    let mallName: String
    let lprice: String
    let link: String
    let productId: String
}
