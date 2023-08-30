//  Daily-Capture - Diary.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import UIKit.UIImage

struct Diary: ManagedObjectModel {
    var objectID: String?
    
    var pictures: [UIImage]
    var title: String
    var content: String?
    var createdAt: Date
    var weather: UIImage?
    
    init?(from diaryData: DiaryData) {
        var pictures: [UIImage] = .init()
        
        diaryData.pictures.forEach { data in
            if let image = UIImage(data: data) {
                pictures.append(image)
            }
        }
        
        guard let title: String = diaryData.title,
              let createdAt: Date = diaryData.createdAt else {
            return nil
        }
        
        if let weatherImageData = diaryData.weather {
            self.weather = UIImage(data: weatherImageData)
        }
        
        self.objectID = diaryData.objectID.uriRepresentation().absoluteString
        self.pictures = pictures
        self.title = title
        self.createdAt = createdAt
        self.content = diaryData.content
    }
    
    init(pictures: [UIImage],
         title: String,
         content: String?,
         createdAt: Date,
         weather: UIImage?) {
        self.pictures = pictures
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.weather = weather
    }
}
