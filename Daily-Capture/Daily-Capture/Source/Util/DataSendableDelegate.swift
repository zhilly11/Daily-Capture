//  Daily-Capture - DataSendableDelegate.swift
//  Created by zhilly, vetto on 2023/07/31

import UIKit

protocol DataSendableDelegate: AnyObject {
    func sendDate(image: UIImage?)
    func sendDate(date: Date)
}
