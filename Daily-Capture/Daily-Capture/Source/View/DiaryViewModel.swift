//  Daily-Capture - DiaryViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import UIKit.UIImage
import RxSwift

final class DiaryViewModel {
    var pictures: BehaviorSubject<[UIImage]> = .init(value: [])
    var title: BehaviorSubject<String> = .init(value: "제목을 입력하세요.")
    var content: BehaviorSubject<String?> = .init(value: "내용을 입력하세요.")
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: nil)
    
    func changeCreatedAt(date: Date) {
        createdAt.onNext(date)
    }
    
    func changeWeather(image: UIImage?) {
        weather.onNext(image)
    }
}
