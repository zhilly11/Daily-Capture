//  Daily-Capture - EditDiaryViewController.swift
//  Created by zhilly, vetto on 2023/07/05

import UIKit
import Photos
import PhotosUI
import RxSwift
import RxCocoa

final class EditDiaryViewController: UIViewController {
    // MARK: - Properties
    
    private var diaryViewModel: DiaryViewModel
    private var disposeBag: DisposeBag = .init()
    
    // MARK: - UI Components
    
    private let weatherImageView: UIImageView =  .init()
    private let dateLabel: UILabel = .init(frame: .zero)
    private let diaryDetailScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private let diaryDetailView: UIView = .init(frame: .zero)
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
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
    private let changeWeatherButton: UIButton = {
        let button: UIButton = .init()
        
        button.setImage(UIImage(systemName: "sun.min"), for: .normal)
        button.setTitle("날씨 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    private let changeCreateAtButton: UIButton = {
        let button: UIButton = .init()
        
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.setTitle("날짜 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    private let changePhotoButton: UIButton = {
        let button: UIButton = .init()
        
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.setTitle("사진 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: DiaryViewModel) {
        self.diaryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupStackView()
        configureLayout()
        setupBindData()
        configureNavigationBarButton()
    }
    
    // MARK: - Methods
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let keyboardArea = view.keyboardLayoutGuide
        
        [imageScrollView, titleTextView, contentTextView, buttonStackView].forEach {
            diaryDetailView.addSubview($0)
        }
        diaryDetailScrollView.addSubview(diaryDetailView)
        view.addSubview(diaryDetailScrollView)
        
        weatherImageView.snp.makeConstraints { make in
            make.width.equalTo(weatherImageView.snp.height)
        }
        diaryDetailScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(keyboardArea.snp.top)
        }
        diaryDetailView.snp.makeConstraints { make in
            make.edges.equalTo(diaryDetailScrollView.contentLayoutGuide)
            make.width.equalTo(diaryDetailScrollView.frameLayoutGuide)
        }
        imageScrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(safeArea).multipliedBy(0.6)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupStackView() {
        [changeWeatherButton, changeCreateAtButton, changePhotoButton].forEach(buttonStackView.addArrangedSubview(_:))
        
        changeWeatherButton.addAction(UIAction(handler: { [weak self] _ in
            self?.changeWeather()
        }), for: .touchUpInside)
        changeCreateAtButton.addAction(UIAction(handler: { [weak self] _ in
            self?.changeDate()
        }), for: .touchUpInside)
        changePhotoButton.addAction(UIAction(handler: { [weak self] _ in
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
        
        diaryViewModel.selectedPictures
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] images in
                self?.setupImageScrollView(pictures: images)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupImageScrollView(pictures: [UIImage]) {
        let safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        imageScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        imageScrollView.contentSize.width = safeAreaWidth * CGFloat(pictures.count)
        imageScrollView.contentSize.height = safeAreaHeight * 0.5
        
        for index in 0..<pictures.count {
            let imageView = UIImageView()
            let xPosition = safeAreaWidth * CGFloat(index)
            
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: xPosition, y: 0, width: safeAreaWidth, height: safeAreaHeight * 0.5)
            imageView.image = pictures[index]
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func configureNavigationBarButton() {
        navigationController?.navigationBar.isHidden = false
        
        let button: UIButton = .init(type: .custom)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.saveDiary()
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.titleView = createStackView()
    }
    
    private func saveDiary() {
        do {
            try diaryViewModel.saveDiary()
        } catch {
            print(error.localizedDescription.description)
        }
    }
    
    private func createStackView() -> UIStackView {
        let stackView: UIStackView = .init(arrangedSubviews: [weatherImageView, dateLabel])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        
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
    
    private var selections: [String: PHPickerResult] = [:]
    private var selectedAssetIdentifiers: [String] = []
    
    private func changePicture() {
        let configuration: PHPickerConfiguration = {
            var configuration: PHPickerConfiguration = .init(photoLibrary: .shared())
            
            configuration.selection = .ordered
            configuration.selectionLimit = 5
            configuration.filter = .any(of: [.images])
            configuration.preferredAssetRepresentationMode = .current
            configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
            
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
        var newSelections: [String: PHPickerResult] = [:]
        for result in results {
            if let identifier = result.assetIdentifier {
                newSelections[identifier] = selections[identifier] ?? result
            }
        }
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        changePictures()
    }
    
    private func changePictures() {
        let dispatchGroup = DispatchGroup()
        var imageDictionary: [String: UIImage] = [:]
        
        for (identifier, result) in selections {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { loadImage, error in
                    if let image = loadImage as? UIImage {
                        imageDictionary[identifier] = image
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            var pictures: [UIImage] = []
            
            for identifier in self.selectedAssetIdentifiers {
                if let image = imageDictionary[identifier] {
                    pictures.append(image)
                }
            }
            self.diaryViewModel.updatePictures(pictures: pictures)
        }
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
