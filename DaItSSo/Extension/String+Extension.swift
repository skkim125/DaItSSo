//
//  String+Extension.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import Foundation

extension String {
    
    static var specialStringArray = ["@", "#", "$", "%"]
    
    static func formatInt(int: String) -> String {
        guard let integer = Int(int) else { return ""}
            return String(integer.formatted())
    }
    
    static func removeTag(title: String) -> String {
        var removeTag = title.replacingOccurrences(of: "<b>", with: "")
        removeTag = removeTag.replacingOccurrences(of: "</b>", with: "")
        
        return removeTag
    }
}
