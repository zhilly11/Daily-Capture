//  Daily-Capture - CalendarViewModel.swift
//  Created by zhilly, vetto on 2023/07/27

import RxSwift

final class CalendarViewModel {
    var dateText: BehaviorSubject<String?> = .init(value: nil)
    
    init(text: String? = nil) {
        self.dateText.onNext(text)
    }
    
    func changeDate(date: Date?) {
        guard let date else {
            return
        }
        dateText.onNext(DateManger.shared.convertToDate(from: date))
    }
}
