//  Daily-Capture - CoreDataManager.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import CoreData

final class DiaryManager: CoreDataManageable {
    static let shared: DiaryManager = DiaryManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = .init(name: "CoreDataDiary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func add(_ diary: Diary?) throws {
        guard let entity: NSEntityDescription = NSEntityDescription.entity(
            forEntityName: "DiaryData", in: context
        ) else {
            throw CoreDataError.failedFetchEntity
        }
        
        let diaryObject: NSManagedObject = .init(entity: entity, insertInto: context)
        var imageData: [Data] = .init()
        
        if let diary = diary {
            diary.pictures.forEach { picture in
                if let data = picture.jpegData(compressionQuality: 1.0) {
                    imageData.append(data)
                }
            }
        }
        
        diaryObject.setValue(diary?.title, forKey: "title")
        diaryObject.setValue(diary?.content, forKey: "content")
        diaryObject.setValue(diary?.createdAt, forKey: "createdAt")
        diaryObject.setValue(diary?.weather?.pngData(), forKey: "weather")
        diaryObject.setValue(imageData, forKey: "pictures")
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchObjects(date: Date) throws -> [Diary] {
        let startDate: Date = date.startOfDay()
        let endDate: Date = date.endOfDay()
        let predicate: NSPredicate = .init(format: "createdAt >= %@ AND createdAt <= %@",
                                           startDate as NSDate,
                                           endDate as NSDate)
        
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.predicate = predicate
        
        let result: [DiaryData] = try context.fetch(fetchRequest)
        
        return result.compactMap({ Diary(from: $0) })
    }
    
    func update(_ diary: Diary) throws {
        guard let objectID: NSManagedObjectID = fetchObjectID(from: diary.objectID) else {
            throw CoreDataError.invalidObjectID
        }
        let diaryObject: NSManagedObject = context.object(with: objectID)
        
        var imageData: [Data] = .init()
        
        diary.pictures.forEach { picture in
            if let data = picture.jpegData(compressionQuality: 1.0) {
                imageData.append(data)
            }
        }
        
        diaryObject.setValue(diary.title, forKey: "title")
        diaryObject.setValue(diary.content, forKey: "content")
        diaryObject.setValue(diary.createdAt, forKey: "createdAd")
        diaryObject.setValue(diary.weather, forKey: "weather")
        diaryObject.setValue(imageData, forKey: "pictures")
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func remove(_ diary: Diary) throws {
        guard let objectID: NSManagedObjectID = fetchObjectID(from: diary.objectID) else {
            throw CoreDataError.invalidObjectID
        }
        let object: NSManagedObject = context.object(with: objectID)
        
        context.delete(object)
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func search(keyword: String) throws -> [Diary] {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@",
            keyword,
            keyword
        )
        
        do {
            let result: [DiaryData] = try context.fetch(fetchRequest)
            var diaries: [Diary] = []
            
            result.forEach { diaryData in
                if let diary = Diary(from: diaryData) {
                    diaries.append(diary)
                }
            }
            
            return diaries
        } catch {
            throw error
        }
    }
    
    private func fetchObjectID(from diaryID: String?) -> NSManagedObjectID? {
        guard let diaryID: String = diaryID,
              let objectURL: URL = URL(string: diaryID),
              let storeCoordinator: NSPersistentStoreCoordinator = context.persistentStoreCoordinator,
              let objectID: NSManagedObjectID = storeCoordinator.managedObjectID(
                forURIRepresentation: objectURL
              ) else { return nil }
        
        return objectID
    }
}
