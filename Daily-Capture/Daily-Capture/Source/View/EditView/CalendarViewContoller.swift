//  Daily-Capture - CalendarViewContoller.swift
//  Created by zhilly, vetto on 2023/07/26

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CalendarViewController: UIViewController {
    private let calendarView: UICalendarView = {
        let calendarView: UICalendarView = .init()
        let gregorianCalendar: Calendar = .init(identifier: .gregorian)
        
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [calendarView].forEach(view.addSubview(_:))
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
    }
}
