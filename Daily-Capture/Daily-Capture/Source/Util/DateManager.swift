//  Daily-Capture - DateManager.swift
//  Created by zhilly, vetto on 2023/07/28

import Foundation

struct DateManger {
    static let shared = DateManger()
    
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }()
    
    func convertToDate(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        return dateFormatter.string(from: date)
    }
}

extension DateFormatter {
    static func convertToDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd."
        
        return dateFormatter.string(from: date)
    }
}
