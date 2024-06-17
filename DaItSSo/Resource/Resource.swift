//
//  Resource.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

extension UIViewController {
    @objc func keyboardDismiss() {
        view.endEditing(true)
    }
}

extension UIColor {
    static let appMainColor = #colorLiteral(red: 0.937254902, green: 0.537254902, blue: 0.2784313725, alpha: 1)
    static let appBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let appGray = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    static let appDarkGray = #colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
    static let appLightGray = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
    static let appWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

extension UIImage {
    static let backButtonImg = UIImage(systemName: "chevron.backward")!
}

extension String {
    
    static var specialStringArray = ["@", "#", "$", "%"]
    
    static func formatInt(int: String) -> String {
        let i = Int(int)!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let result = formatter.string(for: i)!
        
        return result
    }
    
    static func removeTag(title: String) -> String {
        var removeTag = title.replacingOccurrences(of: "<b>", with: "")
        removeTag = removeTag.replacingOccurrences(of: "</b>", with: "")
        
        return removeTag
    }
}

extension DateFormatter {
    static func customDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertDate = dateFormatter.string(from: date)
        
        return convertDate
    }
}
