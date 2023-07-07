//  Daily-Capture - CoreDataManageable.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation

protocol CoreDataManageable {
    associatedtype Object: ManagedObjectModel
    
    func add(_ object: Object) throws
    func fetchObjects(date: Date) throws -> [Object]
    func update(_ object: Object) throws
    func remove(_ object: Object) throws
    func search(keyword: String) throws -> [Object]
}
