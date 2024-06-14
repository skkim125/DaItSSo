//
//  Enum.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

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
