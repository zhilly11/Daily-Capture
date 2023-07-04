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
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let titleAndBodyStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let weatherAndCreatedAtStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .trailing
        stackView.distribution = .fill
        
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
        [titleLabel, bodyLabel].forEach(titleAndBodyStackView.addArrangedSubview(_:))
        [weatherImage, createdAtLabel].forEach(weatherAndCreatedAtStackView.addArrangedSubview(_:))
        [thumbnail,
         titleAndBodyStackView,
         weatherAndCreatedAtStackView].forEach(contentView.addSubview(_:))
        
        thumbnail.snp.makeConstraints {
            $0.width.height.equalTo(50).priority(.high)
            $0.top.leading.equalToSuperview().inset(10).priority(.high)
        }
        
        titleAndBodyStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView.layoutMarginsGuide)
            $0.leading.equalTo(thumbnail.snp_trailingMargin).offset(10)
        }
        
        weatherImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        weatherAndCreatedAtStackView.snp.makeConstraints {
            $0.leading.equalTo(titleAndBodyStackView.snp_trailingMargin).priority(.high)
            $0.trailing.bottom.top.equalTo(contentView.layoutMarginsGuide).priority(.high)
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
