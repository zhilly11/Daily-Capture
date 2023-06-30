//  Daily-Capture - Diary.swift
//  Created by zhilly, vetto on 2023/06/30

import Foundation
import UIKit.UIImage

struct Diary {
    var pictures: [UIImage]
    var title: String
    var content: String?
    var createdAt: Date
    var weather: UIImage?
}
