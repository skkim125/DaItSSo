//
//  DateFormatter+Extension.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import Foundation

extension DateFormatter {
    static func customDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertDate = dateFormatter.string(from: date)
        
        return convertDate
    }
}
