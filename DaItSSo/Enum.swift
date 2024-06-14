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
