//  Daily-Capture - MainViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation

import RxSwift

final class MainViewModel {
    // MARK: - Properties

    let diaryList: BehaviorSubject<[Diary]> = .init(value: [])
    private let disposeBag: DisposeBag = .init()
    private let diaryManager: DiaryManager = DiaryManager.shared
    
    // MARK: - Initializer

    init() {
        let nowDate: Date = .init()
        setupDiary(date: nowDate)
    }
    
    // MARK: - Methods

    func setupDiary(date createAt: Date) {
        do {
            let diaries: [Diary] = try diaryManager.fetchObjects(date: createAt)
            diaryList.onNext(diaries)
        } catch {
            fatalError("Diaries Fetch Failed")
        }
    }
    
    func searchDiary(keyword: String) throws {
        var diaries: [Diary]
        
        if keyword == "" {
            diaries = try diaryManager.fetchObjects()
        } else {
            diaries = try diaryManager.search(keyword: keyword)
        }
        
        diaryList.onNext(diaries)
    }
}
