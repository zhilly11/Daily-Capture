//  Daily-Capture - CalendarViewContoller.swift
//  Created by zhilly, vetto on 2023/07/26

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class CalendarViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: CalendarViewModel
    private let disposeBag: DisposeBag = .init()
    weak var delegate: DateSendableDelegate?
    
    // MARK: - UI Components
    
    private let calendarView: DiaryCalendarView = .init()
    
    // MARK: - Initializer

    init(viewModel: CalendarViewModel) {
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
        let saveButton: UIButton = UIButton(type: .custom)
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addAction(UIAction(handler: { _ in
            self.tappedSaveButton()
        }), for: .touchUpInside)
        
        let cancelButton: UIButton = UIButton(type: .custom)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addAction(UIAction(handler: { _ in
            self.tappedCancelButton()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    private func tappedCancelButton() {
        dismiss(animated: true)
    }
    
    private func tappedSaveButton() {
        delegate?.sendDate(viewModel.getSelectedDate)
        dismiss(animated: true)
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        viewModel.changeDate(date: dateComponents?.date)
    }
}
