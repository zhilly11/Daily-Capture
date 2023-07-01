//  Daily-Capture - MainViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import RxSwift

final class MainViewModel {
    let diaryList: BehaviorSubject<[Diary]> = .init(value: [])
    private let disposeBag: DisposeBag = .init()
    
    init(nowDate: Date) {
        setupDiary(date: nowDate)
    }
    
    // TODO: CoreData에서 날씨로 검색해서 데이터 가져온 후에 List에 넣어주기
    func setupDiary(date createAt: Date?) {
        print("setup Diary!")
    }
}
