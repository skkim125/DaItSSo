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
        case isEmptyResult = "검색결과가 없습니다."
        case networkError = "네트워크 연결을 확인하세요"
        case inValidURL = "유효하지 않은 링크입니다."
        
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
    
    func checkSearchResults(result: Result<Shopping, AFError>) throws {
        switch result {
        case .success(let value):
            guard value.total == 0 else { return }
            throw ErrorType.SearchError.isEmptyResult
        case .failure(let error):
            throw ErrorType.SearchError.networkError
        }
    }
    
    func checkLink(item: Item) throws {
        if item.link.isEmpty {
            throw ErrorType.SearchError.inValidURL
        }
    }
}
