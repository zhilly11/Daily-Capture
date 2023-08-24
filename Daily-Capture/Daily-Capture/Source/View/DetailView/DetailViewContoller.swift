//  Daily-Capture - DetailViewContoller.swift
//  Created by zhilly, vetto on 2023/08/22

import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    // MARK: - Properties
    
    private var diaryViewModel: DetailViewModel
    private var disposeBag: DisposeBag = .init()
    
    // MARK: - UI Components

    private let weatherImageView: UIImageView =  .init()
    private let dateLabel: UILabel = .init(frame: .zero)
    private let diaryDetailScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    private let diaryDetailView: UIView = .init(frame: .zero)
    private let imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    private let pageControl: UIPageControl = {
        let control: UIPageControl = .init()
        
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .systemBlue
        control.currentPage = 0
        
        return control
    }()
    private let titleTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .title1)
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    private let contentTextView: UITextView = {
        let textView: UITextView = .init()
        
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: DetailViewModel) {
        self.diaryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupView()
        setupLayout()
        setupNavigationBarButton()
        setupDelegate()
        setupBindData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    // MARK: - Methods

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let safeAreaWidth = safeArea.layoutFrame.width
        let keyboardArea = view.keyboardLayoutGuide
        
        pageControl.bringSubviewToFront(imageScrollView)
        [imageScrollView, pageControl, titleTextView, contentTextView].forEach {
            diaryDetailView.addSubview($0)
        }
        diaryDetailScrollView.addSubview(diaryDetailView)
        view.addSubview(diaryDetailScrollView)
        
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
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
            make.height.equalTo(safeAreaWidth)
        }
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.bottom.equalTo(imageScrollView)
        }
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
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
    
    private func setupNavigationBarButton() {
        navigationController?.navigationBar.isHidden = false
        
        let button: UIButton = .init(type: .custom)
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.editDiary()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.titleView = createStackView()
    }
    
    private func setupDelegate() {
        imageScrollView.delegate = self
    }
    
    private func setupBindData() {
        diaryViewModel.weather
            .bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
        
        diaryViewModel.createdAt
            .map {
                DateFormatter.convertToDate(from: $0)
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        diaryViewModel.selectedPictures
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, images in
                owner.configureImageScrollView(pictures: images)
            })
            .disposed(by: disposeBag)
        
        diaryViewModel.title
            .bind(to: titleTextView.rx.text)
            .disposed(by: disposeBag)
        
        diaryViewModel.content
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureImageScrollView(pictures: [UIImage]) {
        let safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
        
        imageScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        imageScrollView.contentSize.width = safeAreaWidth * CGFloat(pictures.count)
        imageScrollView.contentSize.height = safeAreaWidth
        
        for index in 0..<pictures.count {
            let imageView = UIImageView()
            let xPosition = safeAreaWidth * CGFloat(index)
            
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: safeAreaWidth,
                                     height: safeAreaWidth)
            imageView.image = pictures[index]
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func editDiary() {
        let storyboard: UIStoryboard = .init(name: "EditTableViewController", bundle: nil)
        
        guard let editDiaryViewController = storyboard.instantiateInitialViewController() else {
            return
        }
        let navigationController: UINavigationController = .init(rootViewController: editDiaryViewController)
        
        self.present(navigationController, animated: true)
    }
    
    private func createStackView() -> UIStackView {
        let stackView: UIStackView = .init(arrangedSubviews: [weatherImageView, dateLabel])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        return stackView
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
        selectedPage(currentPage: Int(position))
    }
    
    private func selectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}
