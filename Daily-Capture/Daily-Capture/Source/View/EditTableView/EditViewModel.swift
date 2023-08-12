//  Daily-Capture - EditViewModel.swift
//  Created by zhilly, vetto on 2023/08/10

import Foundation
import RxSwift

final class EditViewModel {
    private var diary: Diary
    
    var selectedPictures: BehaviorSubject<[UIImage]> = .init(
        value: [UIImage(systemName: "1.circle")!,
                UIImage(systemName: "2.circle")!,
                UIImage(systemName: "3.circle")!,
                UIImage(systemName: "4.circle")!,
                UIImage(systemName: "5.circle")!]
    )
    var title: BehaviorSubject<String> = .init(value: "")
    var content: BehaviorSubject<String?> = .init(value: "내용을 입력하세요.")
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: UIImage(systemName: "sun.min"))
    var numberOfPictures: Int {
        get {
            do {
                let pictures: [UIImage] = try selectedPictures.value()
                
                return pictures.count
            } catch {
                print("error")
            }
            return 0
        }
    }
    
    init() {
        self.diary = Diary(pictures: [],
                           title: .init(),
                           content: nil,
                           createdAt: .init(),
                           weather: nil)
    }
    
    func updateDate(date: Date) {
        createdAt.onNext(date)
    }
    
    func updateWeather(image: UIImage?) {
        weather.onNext(image)
    }
    
    func updatePictures(pictures: [UIImage]) {
        selectedPictures.onNext(pictures)
    }
    
    func saveDiary() throws {
        let diaryManager: DiaryManager = .shared
        
        diary.pictures = try self.selectedPictures.value()
        diary.title = try self.title.value()
        diary.content = try self.content.value()
        diary.createdAt = try self.createdAt.value()
        diary.weather = try self.weather.value()

        try diaryManager.add(self.diary)
    }
}