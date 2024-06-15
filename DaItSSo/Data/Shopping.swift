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

struct MyShopping: Codable {
    var item: Item
    var addDate: String
    var save: Bool
    
    var addDateStr: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertDate = dateFormatter.date(from: addDate)!
        
        return convertDate
    }
}
