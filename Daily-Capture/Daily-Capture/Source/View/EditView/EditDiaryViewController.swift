//  Daily-Capture - EditDiaryViewController.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import UIKit

final class EditDiaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .gray
    }
}
