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
            "\(nickname)" + "'s DaItSSo"
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
    
    var borderColor: UIColor {
        switch self {
        case .isSelected:
            .appMainColor
        case .unSelected:
            .appLightGray
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

enum SortType: String {
    case sim = "정확도"
    case date = "날짜순"
    case dsc = "가격높은순"
    case asc = "가격낮은순"
    
    var buttonTag: Int {
        switch self {
        case .sim:
            0
        case .date:
            1
        case .dsc:
            2
        case .asc:
            3
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
