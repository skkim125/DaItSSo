//
//  NaverShoppingManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/20/24.
//

import Foundation
import Alamofire

class NaverShoppingManager {
    
    private init() { }
    
    static let shared = NaverShoppingManager()
    
    typealias CompletionHandler = (Shopping?, AFError?)-> ()
    
    func callRequest(keyword: String, start: Int, sort: SortType, display: Int, completionHandler: @escaping CompletionHandler) {
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
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func setResultLabelText(result: Shopping?) -> String {
        if let result = result {
            guard result.total > 0 else {
                return ""
            }
            return String.formatInt(int: "\(result.total)") + "개의 검색결과"
        } else {
            return ""
        }
    }
    
    func returnSearchResults(result: Shopping?, start: Int, searchResults: [Item]) -> [Item] {
        var array = searchResults
        
        if let result = result {
            
            if start == 1 {
                array = result.items
            } else {
                array.append(contentsOf: result.items)
            }
            
            return array
        } else {
            return array
        }
    }
}

