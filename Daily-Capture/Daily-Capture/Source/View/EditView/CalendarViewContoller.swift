//  Daily-Capture - CalendarViewContoller.swift
//  Created by zhilly, vetto on 2023/07/26

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CalendarViewController: UIViewController {
    private let viewModel: CalendarViewModel
    private let disposeBag: DisposeBag = .init()
    
    private let calendarView: UICalendarView = {
        let calendarView: UICalendarView = .init()
        let gregorianCalendar: Calendar = .init(identifier: .gregorian)
        
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    
    weak var delegate: DataSendableDelegate?
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCalendarView()
        setupLayout()
        setupBindData()
        configureNavigationBarButton()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCalendarView() {
        let singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        calendarView.delegate = self
        calendarView.selectionBehavior = singleDateSelection
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [calendarView].forEach(view.addSubview(_:))
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func setupBindData() {
        viewModel.dateText
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBarButton() {
        let rightButton: UIButton = UIButton(type: .custom)
        rightButton.setTitle("Change", for: .normal)
        rightButton.setTitleColor(.systemBlue, for: .normal)
        rightButton.addAction(UIAction(handler: { _ in
            self.tappedChangeButton()
        }), for: .touchUpInside)
        
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.setTitle("Cancel", for: .normal)
        leftButton.setTitleColor(.systemBlue, for: .normal)
        leftButton.addAction(UIAction(handler: { _ in
            self.tappedCancelButton()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    private func tappedCancelButton() {
        dismiss(animated: true)
    }
    
    private func tappedChangeButton() {
        delegate?.sendDate(date: viewModel.getSelectedDate)
        dismiss(animated: true)
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        viewModel.changeDate(date: dateComponents?.date)
    }
}
