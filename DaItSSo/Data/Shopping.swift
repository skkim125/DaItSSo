//
//  Shopping.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

struct Shopping: Decodable {
    let total: Int
    let items: [MyShopping]
}

