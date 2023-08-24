//  Daily-Capture - DetailViewModel.swift
//  Created by zhilly, vetto on 2023/08/22

import Foundation

import RxSwift

final class DetailViewModel {
    // MARK: - Properties
    
    private (set) var diary: Diary 
    var selectedPictures: BehaviorSubject<[UIImage]> = .init(value: [])
    var title: BehaviorSubject<String> = .init(value: "")
    var content: BehaviorSubject<String?> = .init(value: nil)
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: nil)
    
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
    
    // MARK: - Initializer
    
    init(diary: Diary) {
        self.diary = diary
        
        updateDiary(diary: diary)
    }
    
    // MARK: - Methods
    
    func updateDiary(diary: Diary) {
        selectedPictures.onNext(diary.pictures)
        createdAt.onNext(diary.createdAt)
        title.onNext(diary.title)
        content.onNext(diary.content)
        weather.onNext(diary.weather)
    }
}
