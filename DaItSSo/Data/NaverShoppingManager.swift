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
    
    func callRequest<T: Decodable>(decodableType: T.Type, query: String, start: Int, sort: SortType, display: Int, completionHandler: @escaping (T?, ErrorType.APIError?)-> ()) {
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "openapi.naver.com"
        component.path = "/v1/search/shop.json"
        component.queryItems = [
            URLQueryItem(name: "query", value: "\(query)"),
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "display", value: "\(display)"),
            URLQueryItem(name: "sort", value: "\(sort.rawValue)")
        ]
        
        guard let url = component.url else { return }
        var request = URLRequest(url: url, timeoutInterval: 3)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.key
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil, .inValidURL)
                    
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, .noData)
                    
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, .inValidRespnose)
                    
                    return
                }
                
                guard response.statusCode == 200 else {
                    
                    switch response.statusCode {
                    case 400:
                        print("요청변수 명이 잘못되었습니다.")
                    case 401:
                        print("인증에 실패하였습니다.")
                    case 403:
                        print("허용되지 않은 호출입니다.")
                    case 404:
                        print("요청 URL이 잘못되었습니다.")
                    case 405:
                        print("메서드를 허용할 수 없습니다.")
                    case 429:
                        print("호출 한도가 초과되었습니다.")
                    case 500:
                        print("네이버 서버 오류입니다.")
                        completionHandler(nil, .serverError)
                    default:
                        print(response.statusCode)
                    }
                    
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    
                    completionHandler(result, nil)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
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
