//  Daily-Capture - CalendarViewModel.swift
//  Created by zhilly, vetto on 2023/07/27

import RxSwift

final class CalendarViewModel {
    private var selectedDate: Date {
        didSet {
            dateText.onNext(DateManger.shared.convertToDate(from: selectedDate))
        }
    }
    let dateText: BehaviorSubject<String?>
    var getSelectedDate: Date {
        get {
            return selectedDate
        }
    }
    
    init(date: Date = Date()) {
        self.selectedDate = date
        self.dateText = .init(value: DateManger.shared.convertToDate(from: date))
    }
    
    func changeDate(date: Date?) {
        guard let date else {
            return
        }
        selectedDate = date
    }
}
