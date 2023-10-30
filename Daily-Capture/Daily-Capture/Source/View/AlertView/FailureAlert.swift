//  Daily-Capture - FailureAlert.swift
//  Created by zhilly, vetto on 2023/09/04

import UIKit

final class FailureAlert: UIAlertController {
    private let cancelAction: UIAlertAction = .init(title: "취소", style: .cancel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(cancelAction)
    }
}
