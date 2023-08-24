//  Daily-Capture - EditViewModel.swift
//  Created by zhilly, vetto on 2023/08/10

import Foundation

import RxSwift

final class EditViewModel {
    // MARK: - Properties

    private var diary: Diary
    var selectedPictures: BehaviorSubject<[UIImage]> = .init(
        value: [UIImage(systemName: "photo.on.rectangle")!]
    )
    var title: BehaviorSubject<String> = .init(value: "")
    var content: BehaviorSubject<String?> = .init(value: "내용을 입력하세요.")
    var createdAt: BehaviorSubject<Date> = .init(value: Date())
    var weather: BehaviorSubject<UIImage?> = .init(value: UIImage(named: "clear"))
    
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
    
    func saveDiary() throws {
        let diaryManager: DiaryManager = .shared
        
        diary.pictures = try self.selectedPictures.value()
        diary.title = try self.title.value()
        diary.content = try self.content.value()
        diary.createdAt = try self.createdAt.value()
        diary.weather = try self.weather.value()

        try diaryManager.add(self.diary)
    }
    
    private func setupDiary() {
        selectedPictures.onNext(diary.pictures)
        title.onNext(diary.title)
        content.onNext(diary.content)
        createdAt.onNext(diary.createdAt)
        weather.onNext(diary.weather)
    }
    
    private func setupNewDiary() {
        
    }
}
