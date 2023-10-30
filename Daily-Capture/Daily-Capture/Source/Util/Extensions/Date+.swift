//  Daily-Capture - Date+.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation

extension Date {
    static func localizedDate() -> Date {
        let today: Date = .init()
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let secondsFromGMT: Int = timezone.secondsFromGMT(for: today)
        let currentDate: Date = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        
        return currentDate
    }
    
    func startOfDay() -> Date {
        let calendar: Calendar = Calendar.current
    
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = .init()
        
        components.day = 1
        components.second = -1
        
        let endOfDay: Date? = calendar.date(byAdding: components, to: startOfDay())
        return endOfDay ?? self
    }
    
    func convertToDay() -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)

        return components
    }
}
