//  Daily-Capture - DiaryViewModel.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import UIKit.UIImage
import RxSwift

final class DiaryViewModel {
    var selectedPictures: BehaviorSubject<[UIImage]> = .init(
        value: [UIImage(systemName: "1.circle")!, UIImage(systemName: "2.circle")!, UIImage(systemName: "3.circle")!, UIImage(systemName: "4.circle")!, UIImage(systemName: "5.circle")!]
    )
    var title: BehaviorSubject<String> = .init(value: "제목을 입력하세요.")
    var content: BehaviorSubject<String?> = .init(value: "내용을 입력하세요.")
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: UIImage(systemName: "sun.min"))
    
    func changeCreatedAt(date: Date) {
        createdAt.onNext(date)
    }
    
    func changeWeather(image: UIImage?) {
        weather.onNext(image)
    }
    
    func updatePictures(pictures: [UIImage]) {
        selectedPictures.onNext(pictures)
    }
}
