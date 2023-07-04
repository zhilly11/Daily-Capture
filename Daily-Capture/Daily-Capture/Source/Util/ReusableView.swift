//  Daily-Capture - ReusableView.swift
//  Created by zhilly, vetto on 2023/06/30

import UIKit.UIView

protocol ReusableView: UIView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
