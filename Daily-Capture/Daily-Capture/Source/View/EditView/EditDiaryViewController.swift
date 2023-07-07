//  Daily-Capture - EditDiaryViewController.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import UIKit
import Photos
import PhotosUI

final class EditDiaryViewController: UIViewController {
    private var diaryViewModel: DiaryViewModel?
    
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
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = .init()
        
        pageControl.hidesForSinglePage = true
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
        button.setTitle("날씨", for: .normal)
        
        return button
    }()
    
    private let button2: UIButton = {
        let button: UIButton = .init()
        
        button.backgroundColor = .systemGray2
        button.setTitle("날짜", for: .normal)
        
        return button
    }()
    
    private let button3: UIButton = {
        let button: UIButton = .init()
        
        button.backgroundColor = .systemGray3
        button.setTitle("사진", for: .normal)
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    init(viewModel: DiaryViewModel) {
        self.diaryViewModel = viewModel
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
    
    private let imageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "circle"))
        
        return imageView
    }()
    
    private func configure() {
        let safeArea = view.safeAreaLayoutGuide
        
        [imageScrollView, titleTextField, contentTextView, stackView].forEach(diaryDetailStackView.addArrangedSubview(_:))
        imageScrollView.addSubview(imageView)
        imageScrollView.addSubview(pageControl)
        diaryDetailScrollView.addSubview(diaryDetailStackView)
        view.addSubview(diaryDetailScrollView)
        
        diaryDetailScrollView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(16)
            make.bottom.trailing.equalTo(safeArea).offset(-16)
        }
        diaryDetailStackView.snp.makeConstraints { make in
            make.edges.equalTo(diaryDetailScrollView.contentLayoutGuide)
        }
        imageScrollView.snp.makeConstraints { make in
            make.width.equalTo(diaryDetailScrollView)
            make.height.equalTo(safeArea).multipliedBy(0.5)
        }
        contentTextView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupImageScrollView() {
        imageScrollView.subviews.forEach({ $0.removeFromSuperview() })
        
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
            let configuration: PHPickerConfiguration = {
                var configuration: PHPickerConfiguration = .init()
                
                configuration.selection = .ordered
                configuration.selectionLimit = 5
                configuration.filter = .any(of: [.images])
                
                return configuration
            }()
            
            let picker = PHPickerViewController(configuration: configuration)
            
            picker.delegate = self
            
            self.present(picker, animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupBindData() {
    }
    
    private func setupPageControl() {
        pageControl.addAction(UIAction(handler: { _ in
            print(self.pageControl.currentPage)
        }), for: .valueChanged)
    }
}

extension EditDiaryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
//        for result in results {
//            let itemProvider = result.itemProvider
//
//            if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                    if let diaryImage = image as? UIImage {
//                    }
//                }
//            }
//        }
    }
}

extension EditDiaryViewController: UIScrollViewDelegate {
    
}
