//
//  RecentSearch.swift
//  DaItSSo
//
//  Created by 김상규 on 6/17/24.
//

import Foundation

struct RecentSearchList: Codable {
    var recentSearchList: [RecentSearch]
}

struct RecentSearch: Codable {
    var search: String
    var searchDate: Date
}
