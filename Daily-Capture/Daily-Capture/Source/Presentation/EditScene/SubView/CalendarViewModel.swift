//  Daily-Capture - CalendarViewModel.swift
//  Created by zhilly, vetto on 2023/07/27

import RxSwift

final class CalendarViewModel {
    // MARK: - Properties

    private var selectedDate: Date {
        didSet {
            dateText.onNext(DateFormatter.convertToDate(from: selectedDate))
        }
    }
    let dateText: BehaviorSubject<String?>
    var getSelectedDate: Date {
        get {
            return selectedDate
        }
    }
    
    // MARK: - Initializer

    init(date: Date = Date()) {
        self.selectedDate = date
        self.dateText = .init(value: DateFormatter.convertToDate(from: date))
    }
    
    // MARK: - Methods

    func changeDate(date: Date?) {
        guard let date else {
            return
        }
        selectedDate = date
    }
}
