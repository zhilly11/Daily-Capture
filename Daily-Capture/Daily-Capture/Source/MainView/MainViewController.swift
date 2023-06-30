//  Daily-Capture - MainViewController.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: MainViewModel
    
    // MARK: - UI Components
    
    private let calendarView: UICalendarView = {
        let calendarView: UICalendarView = .init()
        let gregorianCalendar: Calendar = .init(identifier: .gregorian)
        
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    
    private let tableView: UITableView = {
        let tableView: UITableView = .init(frame: .zero, style: .plain)
        
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        [calendarView, tableView].forEach(view.addSubview(_:))
        
        calendarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(self.view.snp.centerYWithinMargins)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
    }
}
