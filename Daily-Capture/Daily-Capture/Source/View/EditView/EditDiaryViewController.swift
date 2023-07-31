//  Daily-Capture - EditDiaryViewController.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation
import UIKit
import Photos
import PhotosUI
import RxSwift
import RxCocoa

final class EditDiaryViewController: UIViewController, UINavigationControllerDelegate {
    private var diaryViewModel: DiaryViewModel
    private var disposeBag: DisposeBag = .init()
    
    private let diaryDetailScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let diaryDetailView: UIView = {
        let view: UIView = .init()
        
        return view
    }()
    
    private let weatherImageView: UIImageView = .init(frame: .zero)
    private let dateLabel: UILabel = .init(frame: .zero)
    
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()

        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        
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
    
    private let imageView: UIImageView = {
        let view: UIImageView = .init(image: UIImage(systemName: "photo"))
        
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let titleTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .title1)
        
        return textView
    }()
    
    private let contentTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let button1: UIButton = {
        let button: UIButton = .init()
        
        button.setTitle("날씨 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let button2: UIButton = {
        let button: UIButton = .init()
        
        button.setTitle("날짜 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let button3: UIButton = {
        let button: UIButton = .init()
        
        button.setTitle("사진 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
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
        setupView()
        setupStackView()
        configureLayout()
        setupBindData()
        configureNavigationBarButton()
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        [imageView, titleTextView, contentTextView, stackView].forEach(diaryDetailView.addSubview(_:))
        diaryDetailScrollView.addSubview(diaryDetailView)
        view.addSubview(diaryDetailScrollView)
        
        weatherImageView.snp.makeConstraints { make in
            make.width.equalTo(weatherImageView.snp.height)
        }
        diaryDetailScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        diaryDetailView.snp.makeConstraints { make in
            make.edges.equalTo(diaryDetailScrollView.contentLayoutGuide)
            make.width.equalTo(diaryDetailScrollView.frameLayoutGuide)
        }
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(safeArea).multipliedBy(0.5)
        }
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupStackView() {
        [button1, button2, button3].forEach(stackView.addArrangedSubview(_:))
        
        button1.addAction(UIAction(handler: { [weak self] _ in
            self?.changeWeather()
        }), for: .touchUpInside)
        button2.addAction(UIAction(handler: { [weak self] _ in
            self?.changeDate()
        }), for: .touchUpInside)
        button3.addAction(UIAction(handler: { [weak self] _ in
            self?.changePicture()
        }), for: .touchUpInside)
    }
    
    private func setupBindData() {
        diaryViewModel.title
            .bind(to: titleTextView.rx.text)
            .disposed(by: disposeBag)
        
        diaryViewModel.content
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        diaryViewModel.weather
            .bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
        
        diaryViewModel.createdAt
            .map {
                DateManger.shared.convertToDate(from: $0)
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBarButton() {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.saveDiary()
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.titleView = createStackView()
    }
    
    private func saveDiary() {
    }
    
    private func createStackView() -> UIStackView {
        let stackView: UIStackView = .init(arrangedSubviews: [weatherImageView, dateLabel])
        
        stackView.axis = .horizontal
        
        return stackView
    }
    
    private func changeWeather() {
        let viewModel: WeatherPickerViewModel = .init()
        let weatherViewController: WeatherPickerViewController = .init(viewModel: viewModel)
        let navigationViewController: UINavigationController = .init(
            rootViewController: weatherViewController
        )
        weatherViewController.delegate = self
        
        self.present(navigationViewController, animated: true)
    }
    
    private func changeDate() {
        let viewModel: CalendarViewModel = .init()
        let calendarViewController: CalendarViewController = .init(viewModel: viewModel)
        let navigationViewController: UINavigationController = .init(
            rootViewController: calendarViewController
        )
        calendarViewController.delegate = self
        
        self.present(navigationViewController, animated: true)
    }
    
    private func changePicture() {
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

extension EditDiaryViewController: DataSendableDelegate {
    func sendDate(image: UIImage?) {
        self.diaryViewModel.changeWeather(image: image)
    }
    
    func sendDate(date: Date) {
        self.diaryViewModel.changeCreatedAt(date: date)
    }
}
