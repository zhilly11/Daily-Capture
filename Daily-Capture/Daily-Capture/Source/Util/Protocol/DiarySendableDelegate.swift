//  Daily-Capture - DiarySendableDelegate.swift
//  Created by zhilly, vetto on 2023/08/30

protocol DiarySendableDelegate: AnyObject {
    func update(of diary: Diary)
}
