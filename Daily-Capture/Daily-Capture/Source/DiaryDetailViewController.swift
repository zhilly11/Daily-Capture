//  Daily-Capture - DiaryDetailViewController.swift
//  Created by zhilly, vetto on 2023/06/30

import UIKit
import SnapKit

final class DiaryDetailViewController: UIViewController {
    private var diaryDetailViewModel: DiaryDetailViewModel?
    
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
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
        
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
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .blue
        textView.text = "hi"
        
        return textView
    }()
    
    init(diaryDetailViewModel: DiaryDetailViewModel) {
        self.diaryDetailViewModel = diaryDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configure()
        configureNavigation()
    }
    
    private func configure() {
        let safeArea = view.safeAreaLayoutGuide
        
        [imageScrollView, titleTextField, contentTextView].forEach(diaryDetailStackView.addArrangedSubview(_:))
        diaryDetailScrollView.addSubview(diaryDetailStackView)
        view.addSubview(diaryDetailScrollView)
        
        diaryDetailScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        diaryDetailStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.equalTo(diaryDetailScrollView.contentLayoutGuide)
        }
        imageScrollView.snp.makeConstraints { make in
            make.width.equalTo(diaryDetailScrollView)
            make.height.equalTo(300)
        }
        contentTextView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }
    }
    
    private func configureNavigation() {
        let navigationView = createStackView()
        
        navigationItem.titleView = navigationView
    }
    
    private func createStackView() -> UIStackView {
        navigationTitleLabel.text = "Date"
        
        let stackView: UIStackView = .init(arrangedSubviews: [navigationImageView, navigationTitleLabel])
        
        stackView.axis = .horizontal
        
        return stackView
    }
    
}

extension DiaryDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
        
        pageControl.currentPage = Int(round(size))
    }
}
