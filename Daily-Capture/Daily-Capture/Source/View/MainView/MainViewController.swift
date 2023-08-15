//  Daily-Capture - MainViewController.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    // MARK: - Properties
    private var userSelectedDate: Date? {
        didSet {
            if let date = userSelectedDate {
                viewModel.setupDiary(date: date)
            }
        }
    }
    private let viewModel: MainViewModel
    private let disposeBag: DisposeBag = .init()
    
    // MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        let backgroundImage: UIImage = .init()
        
        searchBar.backgroundImage = backgroundImage
        searchBar.placeholder = "검색"
        searchBar.setValue("취소", forKey: "cancelButtonText")
        
        return searchBar
    }()
    
    private let calendarView: UICalendarView = {
        let calendarView: UICalendarView = .init()
        let gregorianCalendar: Calendar = .init(identifier: .gregorian)
        let fromDateComponents: DateComponents = .init(calendar: Calendar(identifier: .gregorian),
                                                       year: 2022,
                                                       month: 1,
                                                       day: 1)
        guard let fromDate = fromDateComponents.date else {
            return UICalendarView()
        }
        
        let calendarViewDateRange: DateInterval = .init(start: fromDate, end: Date())
        
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        calendarView.availableDateRange = calendarViewDateRange
        
        return calendarView
    }()
    
    private let tableView: UITableView = {
        let tableView: UITableView = .init(frame: .zero, style: .insetGrouped)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    private let floatingButton: UIButton = {
        let button: UIButton = .init(type: .custom)
        let configuration: UIImage.SymbolConfiguration = .init(pointSize: 65,
                                                               weight: .regular,
                                                               scale: .default)
        
        button.layer.cornerRadius = button.frame.width / 2
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "plus.circle.fill",
                                withConfiguration: configuration), for: .normal)
        button.tintColor = .tintColor
        button.clipsToBounds = true
        
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    // MARK: - Methods
    
    private func configure() {
        setupView()
        setupLayout()
        setupDelegate()
        setupCalendar()
        setupFloatingButton()
        bindTableViewData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [searchBar, calendarView, tableView, floatingButton].forEach(view.addSubview(_:))
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(50)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(self.searchBar.snp_bottomMargin)
            $0.leading.trailing.equalTo(safeArea)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.bottom.trailing.equalTo(safeArea).offset(-30)
        }
    }
    
    private func setupSearchLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        calendarView.isHidden = true
        floatingButton.isHidden = true
        
        tableView.snp.removeConstraints()
        tableView.bringSubviewToFront(calendarView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func endSearch() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        calendarView.isHidden = false
        floatingButton.isHidden = false
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        if let date = userSelectedDate {
            viewModel.setupDiary(date: date)
        }
    }
    
    private func setupDelegate() {
        searchBar.delegate = self
        tableView.delegate = self
        calendarView.delegate = self
    }
    
    private func setupCalendar() {
        let dateSelection: UICalendarSelectionSingleDate = .init(delegate: self)
        let currentDate: Date = .init()
        let calendar: Calendar = Calendar.current
        let year: Int = calendar.component(.year, from: currentDate)
        let month: Int = calendar.component(.month, from: currentDate)
        let day: Int = calendar.component(.day, from: currentDate)
        
        dateSelection.setSelected(DateComponents(year: year, month: month, day: day),
                                  animated: false)
        calendarView.selectionBehavior = dateSelection
    }
    
    private func setupFloatingButton() {
        let buttonAction: UIAction = UIAction { action in
            let storyboard = UIStoryboard(name: "EditTableViewController", bundle: nil)
            
            guard let editDiaryViewController = storyboard.instantiateInitialViewController() else {
                return
            }
            
            let navigationController = UINavigationController(rootViewController: editDiaryViewController)
            
            self.present(navigationController, animated: true, completion: nil)
        }
            
        floatingButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func bindTableViewData() {
        viewModel.diaryList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DiaryTableViewCell.reuseIdentifier,
                                         cellType: DiaryTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MainViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        if let nowSelectedDate = dateComponents {
            self.userSelectedDate = nowSelectedDate.date
        }
    }
}

extension MainViewController: UICalendarViewDelegate {
    func calendarView(
        _ calendarView: UICalendarView,
        decorationFor dateComponents: DateComponents
    ) -> UICalendarView.Decoration? {
        guard let date = dateComponents.date else { return nil }
        var diariesCount: Int = 0
        
        do {
            let diaries: [Diary] = try DiaryManager.shared.fetchObjects(date: date)
            diariesCount = diaries.count

        } catch {
            print(error.localizedDescription)
        }
        
        if diariesCount > 0 {
            return UICalendarView.Decoration.default(color: .tintColor, size: .medium)
        }
        
        return nil
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        setupSearchLayout()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        endSearch()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchBar.searchTextField.text = nil
        endSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchDiary(keyword: searchText)
    }
}
