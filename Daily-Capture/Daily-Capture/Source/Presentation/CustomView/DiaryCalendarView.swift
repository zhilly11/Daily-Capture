//  Daily-Capture - DiaryCalendarView.swift
//  Created by zhilly, vetto on 2023/10/30

import UIKit

final class DiaryCalendarView: UICalendarView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let gregorianCalendar: Calendar = .init(identifier: .gregorian)
        let fromDateComponents: DateComponents = .init(calendar: Calendar(identifier: .gregorian),
                                                       year: 2022,
                                                       month: 1,
                                                       day: 1)
        guard let fromDate = fromDateComponents.date else { return }
        let calendarViewDateRange: DateInterval = .init(start: fromDate, end: Date())
        
        self.calendar = gregorianCalendar
        self.locale = Locale(identifier: "ko_KR")
        self.fontDesign = .rounded
        self.availableDateRange = calendarViewDateRange
    }
}
