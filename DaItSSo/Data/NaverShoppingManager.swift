//
//  NaverShoppingManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/20/24.
//

import Foundation
import Alamofire

class NaverShoppingManager {
    static let shared = NaverShoppingManager()
    
    private init() { }
    
    func callRequest(keyword: String, start: Int, sort: SortType, display: Int, completionHandler: @escaping (Result<Shopping, AFError>)-> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.key
        ]
        
        let param: Parameters = [
            "query": "\(keyword)",
            "start": "\(start)",
            "display": "\(display)",
            "sort": "\(sort.rawValue)",
        ]
        
        AF.request(url, method: .get, parameters: param, headers: header).responseDecodable(of: Shopping.self) { response in
            completionHandler(response.result)
        }
    }
    
    func returnResultLabelText(result: (Result<Shopping, AFError>)) -> String {
        switch result {
        case .success(let value):
            
            return value.total == 0 ? "검색 결과가 없습니다" : "\(String.formatInt(int: "\(value.total)"))개의 검색결과"
            
        case .failure(let error):
            print(error)
            return "네트워크 연결을 확인해주세요"
        }
    }
    
    func returnSearchResults(result: (Result<Shopping, AFError>), start: Int, searchResults: [Item]) -> [Item] {
        var array = searchResults
        switch result {
        case .success(let value):
            
            if start == 1 {
                array = value.items
            } else {
                array.append(contentsOf: value.items)
            }
            
            return array
            
        case .failure(let error):
            print(error)
            return []
        }
    }
}

