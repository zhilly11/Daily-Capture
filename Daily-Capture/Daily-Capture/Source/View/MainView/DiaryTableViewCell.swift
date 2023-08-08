//  Daily-Capture - DiaryTableViewCell.swift
//  Created by zhilly, vetto on 2023/06/30

import UIKit
import SnapKit

final class DiaryTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: - UI Components
    
    private let thumbnail: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "rays"))
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label: UILabel = .init()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "rays"))
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let createdAtLabel: UILabel = {
        let label: UILabel = .init()
        
        label.textColor = .black
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let titleAndBodyStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    // MARK: - Initializer
    
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
    
    // MARK: - Methods
    
    private func setupViews() {
        [titleLabel,
         bodyLabel].forEach(titleAndBodyStackView.addArrangedSubview(_:))
        [thumbnail,
         titleAndBodyStackView,
         weatherImage,
         createdAtLabel].forEach(contentView.addSubview(_:))
        
        thumbnail.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.leading.equalTo(contentView.layoutMarginsGuide)
        }
        
        weatherImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.trailing.equalTo(contentView.layoutMarginsGuide)
        }
        
        createdAtLabel.snp.makeConstraints {
            $0.trailing.bottom.equalTo(contentView.layoutMarginsGuide)
        }
        
        titleAndBodyStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView.layoutMarginsGuide)
            $0.leading.equalTo(thumbnail.snp_trailingMargin).offset(20)
            $0.trailing.equalTo(createdAtLabel.snp_leadingMargin).offset(-20)
        }
    }
    
    func configure(with diary: Diary) {
        thumbnail.image = diary.pictures.first
        titleLabel.text = diary.title
        bodyLabel.text = diary.content
        weatherImage.image = diary.weather
        createdAtLabel.text = "06/30"
    }
}
