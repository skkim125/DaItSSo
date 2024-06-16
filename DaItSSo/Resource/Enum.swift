//
//  Enum.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

enum SetNavigationTitle {
    case main(String)
    case firstProfile
    case search(String)
    case searchDetail(String)
    case editProfile
    case setting
    
    var navTitle: String {
        switch self {
        case .main(let nickname):
            "\(nickname)'s DaItSSo"
        case .search(let shopping):
            "\(shopping)"
        case .searchDetail(let detail):
            "\(detail)"
        case .setting:
            "Setting"
        case .firstProfile:
            "PROFILE SETTING"
        case .editProfile:
            "EDIT PROFILE"
        }
    }
}

enum ProfileImg: String, CaseIterable {
    case profile_0, profile_1, profile_2, profile_3, profile_4, profile_5, profile_6, profile_7, profile_8, profile_9, profile_10, profile_11
}

enum ProfileImgType {
    case isSelected
    case unSelected
    
    var borderWidth: CGFloat {
        switch self {
        case .isSelected:
            3
        case .unSelected:
            1
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .isSelected:
            UIColor.appMainColor.cgColor
        case .unSelected:
            UIColor.appLightGray.cgColor
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .isSelected:
            1
        case .unSelected:
            0.5
        }
    }
}

enum CheckNickname {
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

enum SortType: String {
    case sim
    case date
    case asc
    case dsc
    
    var sortTitle: String {
        switch self {
        case .sim:
            "정확도"
        case .date:
            "날짜순"
        case .asc:
            "가격낮은순"
        case .dsc:
            "가격높은순"
        }
    }
}

enum Setting: String, CaseIterable {
    case myProfile
    case myShopping = "나의 장바구니 목록"
    case qna = "자주 묻는 질문"
    case inquire = "1:1 문의하기"
    case alarm = "알림 설정"
    case deleteId = "탈퇴하기"
}
