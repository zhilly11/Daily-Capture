//  Daily-Capture - DiaryTableViewCell.swift
//  Created by zhilly, vetto on 2023/06/30

import UIKit

import SnapKit
import Then

final class DiaryTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: - UI Components
    
    private let thumbnail = UIImageView().then {
        $0.image = UIImage(systemName: "rays")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private let bodyLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .body)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 5
    }
    
    private let weatherImage = UIImageView().then {
        $0.image = UIImage(systemName: "rays")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let createdAtLabel = UILabel().then {
        $0.text = "0000.\n00.00."
        $0.textColor = .black
        $0.textAlignment = .right
        $0.font = .preferredFont(forTextStyle: .caption2)
        $0.numberOfLines = 2
    }
    
    private let titleAndBodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
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
        super.prepareForReuse()
        
        thumbnail.image = nil
        titleLabel.text = nil
        bodyLabel.text = nil
        createdAtLabel.text = nil
        weatherImage.image = nil
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
            $0.trailing.bottom.equalTo(contentView.layoutMarginsGuide).priority(.high)
            $0.width.equalTo(45)
        }
        
        titleAndBodyStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView.layoutMarginsGuide)
            $0.leading.equalTo(thumbnail.snp_trailingMargin).offset(20)
            $0.trailing.equalTo(createdAtLabel.snp_leadingMargin).offset(-20)
        }
    }
    
    func configure(with diary: Diary) {
        thumbnail.image = diary.pictures.first
        
        if diary.title == "" {
            titleLabel.text = "제목 없음"
        } else {
            titleLabel.text = diary.title
        }
        
        if diary.content == "" {
            bodyLabel.text = "내용 없음"
        } else {
            bodyLabel.text = diary.content
        }
        
        weatherImage.image = diary.weather
        
        let createdAtString: String = DateFormatter.convertToDate(from: diary.createdAt)
        
        if let index = createdAtString.firstIndex(of: ".") {
            let newString = createdAtString.replacingCharacters(in: index...index, with: ".\n")
            createdAtLabel.text = newString
        } else {
            createdAtLabel.text = createdAtString
        }
    }
}
