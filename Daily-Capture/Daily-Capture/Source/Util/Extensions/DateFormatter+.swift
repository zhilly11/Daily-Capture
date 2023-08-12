//  Daily-Capture - DateFormatter+.swift
//  Created by zhilly, vetto on 2023/08/12

import Foundation

extension DateFormatter {
    static func convertToDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd."
        
        return dateFormatter.string(from: date)
    }
}
