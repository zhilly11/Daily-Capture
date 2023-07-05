//  Daily-Capture - MainViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import RxSwift

final class MainViewModel {
    let diaryList: BehaviorSubject<[Diary]> = .init(value: [])
    private let disposeBag: DisposeBag = .init()
    private let diaryManager: DiaryManager = DiaryManager.shared
    
    init() {
        let nowDate: Date = .init()
        setupDiary(date: nowDate)
    }
    
    func setupDiary(date createAt: Date) {
        do {
            let diaries: [Diary] = try diaryManager.fetchObjects(date: createAt)
            diaryList.onNext(diaries)
        } catch {
            // TODO: 오류처리 구현 ex) Alert으로 사용자에게 알려주기
            NSLog("Diaries Fetch Failed")
        }
    }
}
