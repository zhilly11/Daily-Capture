//  Daily-Capture - DetailViewContoller.swift
//  Created by zhilly, vetto on 2023/08/22

import UIKit

import RxSwift
import Then

final class DetailViewController: UIViewController {
    // MARK: - Properties
    
    private var diaryViewModel: DetailViewModel
    private var disposeBag: DisposeBag = .init()
    weak var dateDelegate: DateSendableDelegate?
    
    // MARK: - UI Components
    
    private let weatherImageView = UIImageView()
    private let dateLabel = UILabel(frame: .zero)
    private let diaryDetailView = UIView(frame: .zero)
    
    private let diaryDetailScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private let imageScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .systemBlue
        $0.currentPage = 0
    }
    
    private let titleTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.isUserInteractionEnabled = false
    }
    
    private let contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .preferredFont(forTextStyle: .body)
        $0.isUserInteractionEnabled = false
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        do {
            let date = try diaryViewModel.createDate()
            dateDelegate?.sendDate(date)
        } catch {
            print("error")
        }
    }
    
    private func setup() {
        setupView()
        setupLayout()
        setupNavigationBarButton()
        setupDelegate()
        setupBindData()
        setupNumberOfPage()
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
        
        weatherImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        diaryDetailScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(keyboardArea.snp.top)
        }
        
        diaryDetailView.snp.makeConstraints {
            $0.edges.equalTo(diaryDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(diaryDetailScrollView.frameLayoutGuide)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(safeAreaWidth)
        }
        
        pageControl.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.trailing.bottom.equalTo(imageScrollView)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBarButton() {
        navigationController?.navigationBar.isHidden = false
        
        let editButton = UIButton(type: .custom).then {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.addAction(UIAction(handler: { _ in self.tappedEditButton() }), for: .touchUpInside)
        }
        
        navigationItem.do {
            $0.rightBarButtonItem = UIBarButtonItem(customView: editButton)
            $0.titleView = createStackView()
        }
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
    
    private func setupNumberOfPage() {
        pageControl.numberOfPages = diaryViewModel.numberOfPictures
    }
    
    private func configureImageScrollView(pictures: [UIImage]) {
        let safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
        
        imageScrollView.do {
            $0.subviews.forEach { view in
                view.removeFromSuperview()
            }
            $0.contentSize.width = safeAreaWidth * CGFloat(pictures.count)
            $0.contentSize.height = safeAreaWidth
        }
        
        for index in 0..<pictures.count {
            let xPosition = safeAreaWidth * CGFloat(index)
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                $0.frame = CGRect(x: xPosition, y: 0, width: safeAreaWidth, height: safeAreaWidth)
                $0.image = pictures[index]
            }
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func tappedEditButton() {
        let editAction: UIAlertAction = .init(title: "수정", style: .default) { _ in
            self.presentEditViewController(with: self.diaryViewModel.diary)
        }
        let deleteAction: UIAlertAction = .init(title: "삭제", style: .destructive) { _ in
            try! DiaryManager.shared.remove(self.diaryViewModel.diary)
            self.isModalInPresentation = false
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction: UIAlertAction = .init(title: "취소", style: .cancel, handler: nil)
        let alert: UIAlertController = .init(title: nil,
                                             message: "일기를 편집하시겠어요?",
                                             preferredStyle: .actionSheet)
        
        [editAction, deleteAction, cancelAction].forEach(alert.addAction(_:))
        
        present(alert, animated: true)
    }
    
    private func presentEditViewController(with diary: Diary?) {
        let storyboard: UIStoryboard = .init(name: "EditTableViewController", bundle: nil)
        let editViewModel: EditViewModel
        
        if let diary {
            editViewModel = .init(diary: diary)
        } else {
            editViewModel = .init()
        }
        
        let editDiaryViewController = storyboard.instantiateInitialViewController { coder -> EditTableViewController in
            return .init(coder, editViewModel) ?? EditTableViewController(viewModel: editViewModel)
        }
        
        if let editDiaryViewController {
            editDiaryViewController.diaryDelegate = self
            let navigationController: UINavigationController = .init(rootViewController: editDiaryViewController)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            let alert: UIAlertController = AlertFactory.make(.failure(title: "새로운 일기 쓰기 실패",
                                                                      message: "나중에 다시 시도해주세요"))
            self.present(alert, animated: true)
        }
    }
    
    private func createStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [weatherImageView, dateLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4
        }
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

extension DetailViewController: DiarySendableDelegate {
    func update(of diary: Diary) {
        diaryViewModel.changeDiary(diary: diary)
    }
}
