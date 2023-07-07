//  Daily-Capture - DiaryData+CoreDataProperties.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import CoreData

extension DiaryData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var pictures: [Data]
    @NSManaged public var title: String?
    @NSManaged public var weather: Data?
}
