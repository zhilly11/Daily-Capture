//  Daily-Capture - MainViewController.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - Properties

    
    // MARK: - UI Components

    private let calendarView: UICalendarView = {
        let calendarView: UICalendarView = .init()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Methods
    
    private func configure() {
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [calendarView].forEach(view.addSubview(_:))
        
        calendarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(self.view.snp.centerYWithinMargins)
        }
    }
}
