//  Daily-Capture - EditDiaryViewController.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import UIKit

final class EditDiaryViewController: UIViewController {
    private var DiaryViewModel: DiaryViewModel?
    
    private let navigationImageView: UIImageView = {
        let imageView: UIImageView = .init()
        
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let navigationTitleLabel: UILabel = .init()
    
    private let diaryDetailScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let diaryDetailStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = .init()
        
        pageControl.backgroundColor = .gray
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.currentPage = 0
        
        return pageControl
    }()
    
    private let titleTextField: UITextField = {
        let textField: UITextField = .init()
        
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.text = "hello"
        
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text = "hi"
        
        return textView
    }()
    
    private let button1: UIButton = {
        let button: UIButton = .init()
        
        button.backgroundColor = .systemGray
        
        return button
    }()
    
    private let button2: UIButton = {
        let button: UIButton = .init()
        
        button.backgroundColor = .systemGray2
        
        return button
    }()
    
    private let button3: UIButton = {
        let button: UIButton = .init()
        
        button.backgroundColor = .systemGray3
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    init(viewModel: DiaryViewModel) {
        self.DiaryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupStackView()
        configure()
    }
    
    private func configure() {
        let safeArea = view.safeAreaLayoutGuide
        
        [imageScrollView, titleTextField, contentTextView, stackView].forEach(diaryDetailStackView.addArrangedSubview(_:))
        diaryDetailScrollView.addSubview(diaryDetailStackView)
        view.addSubview(diaryDetailScrollView)
        
        diaryDetailScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        diaryDetailStackView.snp.makeConstraints { make in
            make.edges.equalTo(diaryDetailScrollView.contentLayoutGuide)
        }
        imageScrollView.snp.makeConstraints { make in
            make.width.equalTo(diaryDetailScrollView)
            make.height.equalTo(300)
        }
        contentTextView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupStackView() {
        [button1, button2, button3].forEach(stackView.addArrangedSubview(_:))
        
        button1.addAction(UIAction(handler: { _ in
            print("button1")
        }), for: .touchUpInside)
        button2.addAction(UIAction(handler: { _ in
            print("button2")
        }), for: .touchUpInside)
        button3.addAction(UIAction(handler: { _ in
            print("button3")
        }), for: .touchUpInside)
    }
}
