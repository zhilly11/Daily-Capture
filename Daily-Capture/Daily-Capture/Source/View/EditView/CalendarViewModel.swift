//  Daily-Capture - CalendarViewModel.swift
//  Created by zhilly, vetto on 2023/07/27

import RxSwift
import Foundation

final class CalendarViewModel {
    private var selectedDate: Date {
        didSet(date) {
            dateText.onNext(DateManger.shared.convertToDate(from: date))
        }
    }
    let dateText: BehaviorSubject<String?> = .init(value: nil)
    var getSelectedDate: Date {
        get {
            return selectedDate
        }
    }
    
    init(date: Date = Date()) {
        self.selectedDate = date
    }
    
    func changeDate(date: Date?) {
        guard let date else {
            return
        }
        selectedDate = date
    }
}
