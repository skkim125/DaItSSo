//
//  ErrorManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/21/24.
//

import UIKit
import Alamofire

enum SearchError: String, Error {
    case isEmptyResult = "검색결과가 없습니다."
    case networkError = "네트워크 연결을 확인하세요"
    case inValidURL = "유효하지 않은 링크입니다."

}

class ErrorManager {
    static let shared = ErrorManager()
    
    private init() { }
    
    func checkSearchResults(result: Result<Shopping, AFError>) throws {
        switch result {
        case .success(let value):
            guard value.total == 0 else { return }
            throw SearchError.isEmptyResult
        case .failure(let error):
            throw SearchError.networkError
        }
    }
    
    func checkLink(item: Item) throws {
        if item.link.isEmpty {
            throw SearchError.inValidURL
        }
    }
}
