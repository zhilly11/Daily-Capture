//  Daily-Capture - EditViewModel.swift
//  Created by zhilly, vetto on 2023/08/10

import Foundation
import PhotosUI

import RxSwift

final class EditViewModel {
    // MARK: - Properties

    private var diary: Diary
    var isNewDiary: Bool = false
    var selections: [String: PHPickerResult] = [:]
    var selectedAssetIdentifiers: [String] = []
    let selectedPictures: BehaviorSubject<[UIImage]> = .init(value: [UIImage(systemName: "photo.on.rectangle")!])
    var viewTitle: BehaviorSubject<String> = .init(value: "새로운 일기")
    let title: BehaviorSubject<String> = .init(value: "")
    let content: BehaviorSubject<String?> = .init(value: "내용을 입력하세요.")
    let createdAt: BehaviorSubject<Date> = .init(value: Date())
    let weather: BehaviorSubject<UIImage?> = .init(value: UIImage(named: "clear"))
    
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
    
    var isSavable: Observable<Bool> {
        return Observable.combineLatest(title, content)
            .map { title, content in
                guard let content = content else { return false }
                
                if title.count > 0 && content.count > 0 && content != "내용을 입력하세요." {
                    return true
                } else {
                    return false
                }
            }
    }
    
    // MARK: - Initializer
    
    init() {
        self.diary = Diary(pictures: [],
                           title: .init(),
                           content: nil,
                           createdAt: .init(),
                           weather: nil)
        self.isNewDiary = true
    }

    init(diary: Diary) {
        self.diary = diary
        setupDiary()
    }
    
    // MARK: - Methods

    func updateDate(date: Date) {
        createdAt.onNext(date)
    }
    
    func updateWeather(image: UIImage?) {
        weather.onNext(image)
    }
    
    func updatePictures(pictures: [UIImage]) {
        selectedPictures.onNext(pictures)
    }
    
    func createChangedDairy() throws -> Diary {
        let diary: Diary = .init(pictures: try selectedPictures.value(),
                                 title: try title.value(),
                                 content: try content.value(),
                                 createdAt: try createdAt.value(),
                                 weather: try weather.value())
        return diary
    }
    
    func saveDiary() throws {
        if isNewDiary {
            try createDiary()
        } else {
            try updateDiary()
        }
    }
    
    func createDiary() throws {
        let diaryManager: DiaryManager = .shared
        
        diary.pictures = try self.selectedPictures.value()
        diary.title = try self.title.value()
        diary.content = try self.content.value()
        diary.createdAt = try self.createdAt.value()
        diary.weather = try self.weather.value()

        try diaryManager.add(self.diary)
    }
    
    func updateDiary() throws {
        let diaryManager: DiaryManager = .shared
        
        diary.pictures = try self.selectedPictures.value()
        diary.title = try self.title.value()
        diary.content = try self.content.value()
        diary.createdAt = try self.createdAt.value()
        diary.weather = try self.weather.value()

        try diaryManager.update(self.diary)
    }
    
    func createDate() throws -> Date {
        return try createdAt.value()
    }
    
    private func setupDiary() {
        viewTitle.onNext("일기 편집")
        selectedPictures.onNext(diary.pictures)
        title.onNext(diary.title)
        content.onNext(diary.content)
        createdAt.onNext(diary.createdAt)
        weather.onNext(diary.weather)
    }
}
