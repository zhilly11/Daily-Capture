//  Daily-Capture - MainViewController.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit
import Foundation

import RxCocoa
import RxSwift
import SnapKit
import Then

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
    private let calendarView: DiaryCalendarView = .init()
    
    private let searchBar = UISearchBar().then {
        $0.backgroundImage = UIImage()
        $0.placeholder = "검색"
        $0.setValue("취소", forKey: "cancelButtonText")
    }
    
    private let tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.register(DiaryTableViewCell.self,
                    forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }
    
    private let addDiaryButton = UIButton(type: .contactAdd).then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
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
        setupAddDiaryButton()
        bindTableViewData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [addDiaryButton, searchBar, calendarView, tableView].forEach(view.addSubview(_:))
        
        addDiaryButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeArea)
            $0.height.width.equalTo(50)
        }
        
        searchBar.snp.makeConstraints {
            $0.trailing.equalTo(addDiaryButton.snp.leading)
            $0.top.leading.equalTo(safeArea)
            $0.height.equalTo(50)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(self.searchBar.snp_bottomMargin)
            $0.leading.trailing.equalTo(safeArea)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view)
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
        userSelectedDate = currentDate
    }
    
    private func setupAddDiaryButton() {
        let buttonAction: UIAction = UIAction { action in
            self.presentEditViewController(with: nil)
        }
        
        addDiaryButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func presentEditViewController(with diary: Diary?) {
        let storyboard: UIStoryboard = .init(name: "EditTableViewController", bundle: nil)
        let editViewModel: EditViewModel
        
        if let diary {
            editViewModel = .init(diary: diary)
        } else {
            editViewModel = .init()
        }
        
        let editDiaryViewController = storyboard.instantiateInitialViewController { coder -> EditTableViewController in
            return .init(coder, editViewModel) ?? EditTableViewController(viewModel: editViewModel)
        }
        
        if let editDiaryViewController {
            editDiaryViewController.dateDelegate = self
            let navigationController: UINavigationController = .init(rootViewController: editDiaryViewController)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            let alert: UIAlertController = AlertFactory.make(.failure(title: "새로운 일기 쓰기 실패",
                                                                      message: "나중에 다시 시도해주세요"))
            self.present(alert, animated: true)
        }
    }
    
    private func bindTableViewData() {
        viewModel.diaryList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DiaryTableViewCell.reuseIdentifier,
                                         cellType: DiaryTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Diary.self)
            .subscribe { diary in
                let detailViewModel: DetailViewModel = .init(diary: diary)
                let detailViewController: DetailViewController = .init(viewModel: detailViewModel)
                detailViewController.dateDelegate = self
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setupSearchLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        calendarView.isHidden = true
        addDiaryButton.isHidden = true
        
        searchBar.snp.removeConstraints()
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(50)
        }
        
        tableView.snp.removeConstraints()
        tableView.bringSubviewToFront(calendarView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view)
        }
        
        do {
            try viewModel.searchDiary(keyword: "")
        } catch {
            let alert: UIAlertController = AlertFactory.make(.failure(title: "일기 검색 실패",
                                                                      message: "나중에 다시 시도해주세요."))
            self.present(alert, animated: true)
        }
    }
    
    private func endSearch() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        calendarView.isHidden = false
        addDiaryButton.isHidden = false
        
        addDiaryButton.snp.removeConstraints()
        searchBar.snp.removeConstraints()
        
        addDiaryButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeArea)
            $0.height.width.equalTo(50)
        }
        
        searchBar.snp.makeConstraints {
            $0.trailing.equalTo(addDiaryButton.snp.leading)
            $0.top.leading.equalTo(safeArea)
            $0.height.equalTo(50)
        }
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view)
        }
        
        if let date = userSelectedDate {
            viewModel.setupDiary(date: date)
        }
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
        do {
            try viewModel.searchDiary(keyword: "")
        } catch {
            let alert: UIAlertController = AlertFactory.make(.failure(title: "일기 검색 실패",
                                                                      message: "나중에 다시 시도해주세요."))
            self.present(alert, animated: true)
        }
    }
}

extension MainViewController: DateSendableDelegate {
    func sendDate(_ date: Date) {
        reloadView(date: date)
    }
    
    func reloadView(date: Date) {
        viewModel.setupDiary(date: self.userSelectedDate!)
        reloadCalendarView(date: self.userSelectedDate!)
        reloadCalendarView(date: date)
    }
    
    func reloadCalendarView(date: Date) {
        let dateComponent = date.convertToDay()
        
        calendarView.reloadDecorations(forDateComponents: [dateComponent], animated: true)
    }
}
