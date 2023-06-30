//  Daily-Capture - DiaryTableViewCell.swift
//  Created by zhilly, vetto on 2023/06/30

import UIKit
import SnapKit

final class DiaryTableViewCell: UITableViewCell, ReusableView {
    
    private let thumbnail: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "rays"))
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {

    }
    
    private func setupViews() {
        [thumbnail].forEach(contentView.addSubview(_:))
        
        thumbnail.snp.makeConstraints {
            $0.width.height.equalTo(100).priority(.high)
            $0.top.leading.bottom.equalToSuperview().inset(10)
        }
    }
}
