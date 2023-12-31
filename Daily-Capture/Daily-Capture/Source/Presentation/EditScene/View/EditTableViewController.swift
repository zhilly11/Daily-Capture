//  Daily-Capture - EditTableViewController.swift
//  Created by zhilly, vetto on 2023/08/09

import UIKit
import PhotosUI

import RxCocoa
import RxSwift
import SnapKit
import Then

final class EditTableViewController: UITableViewController {
    // MARK: - Properties
    
    private let viewModel: EditViewModel
    private var disposeBag: DisposeBag = .init()
    
    weak var diaryDelegate: DiarySendableDelegate?
    weak var dateDelegate: DateSendableDelegate?
    
    // MARK: - UI Components
    
    @IBOutlet weak private var imageContainerView: UIView!
    @IBOutlet weak private var editTableView: UITableView!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var weatherSelectButton: UIButton!
    @IBOutlet weak private var imageScrollView: UIScrollView!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var pictureSelectCell: UITableViewCell!
    @IBOutlet weak private var createdAtButton: UIButton!
    
    // MARK: - Initializer
    
    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "EditTableViewController", bundle: nil)
    }
    
    init?(_ coder: NSCoder, _ viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        do {
            let date = try viewModel.createDate()
            dateDelegate?.sendDate(date)
        } catch {
            print("error")
        }
    }
    
    // MARK: - Methods
    
    private func configure() {
        setupViews()
        setupNavigationItem()
        setupLayout()
        setupTextViewPlaceHolder()
        setupWeatherSelectButton()
        setupCellTappedAction()
        setupBindData()
        setupNumberOfPage()
    }
    
    private func setupViews() {
        self.tableView.backgroundColor = .systemGray6
        self.isModalInPresentation = true
        self.editTableView.keyboardDismissMode = .onDrag
        
        if !viewModel.isNewDiary {
            contentTextView.textColor = .black
        }
    }
    
    private func setupNavigationItem() {
        let saveButton = UIButton(type: .custom).then {
            $0.setTitle("저장", for: .normal)
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.addAction(UIAction(handler: { _ in self.tappedSaveButton() }), for: .touchUpInside)
        }
        
        let cancelButton = UIButton(type: .custom).then {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.addAction(UIAction(handler: { _ in self.tappedCancelButton()}), for: .touchUpInside)
        }
        
        navigationItem.do {
            $0.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
            $0.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
            $0.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func setupLayout() {
        pageControl.bringSubviewToFront(imageScrollView)
        [imageScrollView, pageControl].forEach(imageContainerView.addSubview(_:))
        
        imageScrollView.snp.makeConstraints {
            $0.width.height.equalTo(imageContainerView)
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.trailing.bottom.equalTo(imageScrollView)
        }
    }
    
    private func setupTextViewPlaceHolder(){
        contentTextView.rx.didBeginEditing
            .subscribe(onNext: { [self] in
                if(contentTextView.text == "내용을 입력하세요.") {
                    contentTextView.text = nil
                    contentTextView.textColor = .black
                }
            })
            .disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [self] in
                if(contentTextView.text == nil || contentTextView.text == "") {
                    contentTextView.text = "내용을 입력하세요."
                    contentTextView.textColor = .systemGray3
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupWeatherSelectButton() {
        let popUpButtonClosure: UIActionHandler = { [weak self] action in
            self?.viewModel.updateWeather(image: action.image)
        }
        
        var weatherMenu: [UIAction] = .init()
        
        Constant.weatherNameList.forEach { weatherName in
            weatherMenu.append(UIAction(title: Constant.weatherDescription[weatherName] ?? .init(),
                                        image: UIImage(named: weatherName),
                                        handler: popUpButtonClosure))
        }
        
        weatherSelectButton.menu = UIMenu(children: weatherMenu)
        weatherSelectButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupCellTappedAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(pictureSelectCellTapped(_:))
        )
        
        pictureSelectCell.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupBindData() {
        viewModel.viewTitle
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.content
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selectedPictures
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, images in
                owner.configureImageScrollView(pictures: images)
            })
            .disposed(by: disposeBag)
        
        viewModel.createdAt
            .map({ date in
                return DateFormatter.convertToDate(from: date)
            })
            .bind(to: createdAtButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        contentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.content)
            .disposed(by: disposeBag)
        
        guard let saveButton = navigationItem.rightBarButtonItem else { return }
        
        viewModel.isSavable
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setupNumberOfPage() {
        pageControl.numberOfPages = viewModel.numberOfPictures
    }
    
    private func configureImageScrollView(pictures: [UIImage]) {
        guard let contentViewWidth = imageContainerView.superview?.frame.width else {
            return
        }
        
        imageScrollView.do {
            $0.subviews.forEach { view in
                view.removeFromSuperview()
            }
            $0.contentSize.width = contentViewWidth * CGFloat(pictures.count)
            $0.contentSize.height = contentViewWidth
        }
        
        for index in 0..<pictures.count {
            let xPosition: CGFloat = contentViewWidth * CGFloat(index)
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                $0.frame = CGRect(x: xPosition, y: 0, width: contentViewWidth, height: contentViewWidth)
                $0.image = pictures[index]
            }
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            let position: CGFloat = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
            selectedPage(currentPage: Int(position))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func changePictures() {
        let configuration: PHPickerConfiguration = {
            var configuration: PHPickerConfiguration = .init(photoLibrary: .shared())
            
            configuration.selection = .ordered
            configuration.selectionLimit = 5
            configuration.filter = .any(of: [.images])
            configuration.preferredAssetRepresentationMode = .current
            configuration.preselectedAssetIdentifiers = viewModel.selectedAssetIdentifiers
            
            return configuration
        }()
        
        let picker: PHPickerViewController = .init(configuration: configuration)
        
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    private func selectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    private func tappedCancelButton() {
        let defaultAction: UIAlertAction = .init(title: "변경사항 폐기", style: .destructive) { _ in
            self.isModalInPresentation = false
            self.dismiss(animated: true)
        }
        let cancelAction: UIAlertAction = .init(title: "계속 편집하기", style: .cancel, handler: nil)
        let alert: UIAlertController = .init(title: nil,
                                             message: "새로운 일기를 폐기하시겠어요?",
                                             preferredStyle: .actionSheet)
        
        [defaultAction, cancelAction].forEach(alert.addAction(_:))
        
        present(alert, animated: true)
    }
    
    private func tappedSaveButton() {
        do {
            try diaryDelegate?.update(of: viewModel.createChangedDairy())
            try viewModel.saveDiary()
            self.isModalInPresentation = false
            dismiss(animated: true)
        } catch {
            print(error.localizedDescription.description)
        }
    }
    
    @objc func pictureSelectCellTapped(_ sender: UITapGestureRecognizer) {
        changePictures()
    }
    
    @IBAction func createdAtButtonTapped(_ sender: UIButton) {
        let viewModel: CalendarViewModel = .init()
        let calendarViewController: CalendarViewController = .init(viewModel: viewModel)
        let navigationViewController: UINavigationController = .init(
            rootViewController: calendarViewController
        )
        
        calendarViewController.delegate = self
        
        self.present(navigationViewController, animated: true)
    }
}

extension EditTableViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var newSelections: [String: PHPickerResult] = [:]
        
        for result in results {
            if let identifier = result.assetIdentifier {
                newSelections[identifier] = viewModel.selections[identifier] ?? result
            }
        }
        
        viewModel.selections = newSelections
        viewModel.selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if viewModel.selectedAssetIdentifiers.count != 0 {
            updatePictures()
        }
    }
    
    private func updatePictures() {
        let dispatchGroup: DispatchGroup = .init()
        var imageDictionary: [String: UIImage] = [:]
        
        for (identifier, result) in viewModel.selections {
            dispatchGroup.enter()
            let itemProvider: NSItemProvider = result.itemProvider
            
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
            
            for identifier in self.viewModel.selectedAssetIdentifiers {
                if let image = imageDictionary[identifier] {
                    pictures.append(image)
                }
            }
            
            self.viewModel.updatePictures(pictures: pictures)
            self.pageControl.numberOfPages = self.viewModel.numberOfPictures
        }
    }
}

extension EditTableViewController: DateSendableDelegate {
    func sendDate(_ date: Date) {
        self.viewModel.updateDate(date: date)
    }
}
