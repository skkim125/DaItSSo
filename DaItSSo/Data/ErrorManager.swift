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
    
    enum APIError: String, Error {
        case inValidURL = "잘못된 URL입니다."
        case inValidRespnose = "잘못된 서버 응답입니다."
        case noData = "데이터가 존재하지 않습니다."
    }
    
    enum ResponseStatusCode: String {
        case parameterError = "요청변수 명이 잘못되었습니다."
        case authorizationError = "인증에 실패하였습니다."
        case disallowRequest = "허용되지 않은 호출입니다."
        case inValidURL = "요청 URL이 잘못되었습니다."
        case disallowMethod = "메서드를 허용할 수 없습니다."
        case overRequest = "호출 한도가 초과되었습니다."
        case serverError = "네이버 서버 오류입니다."
    }
}

final class ErrorManager {
    
    private init() { }
    
    static let shared = ErrorManager()
    
    func checkSearchBarText(text: String) throws {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count > 0 else { throw ErrorType.SearchError.isEmptySearchText }
        
        return
    }
    
    func checkSearchResults(result: Shopping) throws {
        guard result.total == 0 else { return }
        throw ErrorType.SearchError.isEmptyResult
    }
    
    func checkLink(myShopping: MyShopping) throws {
        if myShopping.link.isEmpty {
            throw ErrorType.SearchError.isEmptyURL
        }
    }
}
