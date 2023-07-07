//  Daily-Capture - DiaryViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import UIKit.UIImage
import RxSwift

final class DiaryViewModel {
    var pictures: BehaviorSubject<[UIImage]> = .init(value: [])
    var title: BehaviorSubject<String> = .init(value: "제목")
    var content: BehaviorSubject<String?> = .init(value: nil)
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: nil)
    
    var diary: Diary?
    
    init(diary: Diary) {
        self.diary = diary
    }
}
