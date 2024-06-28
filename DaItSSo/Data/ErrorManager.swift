//
//  ErrorManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/21/24.
//

import UIKit
import Alamofire

enum ErrorType {
    enum SearchError: String, Error {
        case isEmptySearchText = "공백없이 한글자 이상 입력해주세요."
        case isEmptyResult = "검색결과가 없습니다."
        case networkError = "네트워크 연결을 확인해주세요."
        case isEmptyURL = "존재하지 않는 링크입니다."
    }
    
    enum CheckNickname: Error {
        case ok, outRange, specialString(String), noNumber
        
        var checkNicknameLabelText: String {
            switch self {
            case .ok:
                "사용할 수 있는 닉네임이에요!"
            case .outRange:
                "2글자 이상 10글자 미만으로 설정해주세요"
            case .specialString(let char):
                "닉네임에 \(char)는 포함할 수 없어요"
            case .noNumber:
                "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    enum APIError: Error {
        case inValidURL
        case inValidRespnose
        case noData
        case serverError
    }
}

class ErrorManager {
    
    private init() { }
    
    static let shared = ErrorManager()
    
    func checkNicknameCondition(nickname: String) throws {
        guard nickname.count >= 2 && nickname.count <= 9 else {
            
            throw ErrorType.CheckNickname.outRange
        }
        
        guard nickname.rangeOfCharacter(from: .decimalDigits) == nil else {
            
            throw ErrorType.CheckNickname.noNumber
        }
        
        for str in String.specialStringArray {
            guard !nickname.contains(str) else {
                
                throw ErrorType.CheckNickname.specialString(str)
            }
        }
    }
    
    func checkSearchBarText(text: String) throws {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count > 0 else { throw ErrorType.SearchError.isEmptySearchText }
        
        return
    }
    
    func checkSearchResults(result: Shopping) throws {
        guard result.total == 0 else { return }
        throw ErrorType.SearchError.isEmptyResult
    }
    
    func checkLink(item: Item) throws {
        if item.link.isEmpty {
            throw ErrorType.SearchError.isEmptyURL
        }
    }
}
