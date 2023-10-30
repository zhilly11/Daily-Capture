//  Daily-Capture - ExitAlert.swift
//  Created by zhilly, vetto on 2023/09/04

import UIKit

final class ExitAlert: UIAlertController {
    private let confirmAction: UIAlertAction = .init(title: "확인", style: .cancel) { _ in
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(confirmAction)
    }
}
