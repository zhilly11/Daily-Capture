//  Daily-Capture - EditTableViewController.swift
//  Created by zhilly, vetto on 2023/08/09

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import PhotosUI

final class EditTableViewController: UITableViewController {
    
    private let viewModel: EditViewModel = .init()
    private var disposeBag: DisposeBag = .init()
    
    private var selections: [String: PHPickerResult] = [:]
    private var selectedAssetIdentifiers: [String] = []
    
    @IBOutlet weak private var imageContainerView: UIView!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var weatherSelectButton: UIButton!
    @IBOutlet weak private var imageScrollView: UIScrollView!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var pictureSelectCell: UITableViewCell!
    @IBOutlet weak private var createdAtButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupViews()
        setupNavigationItem()
        setupLayout()
        setupText()
        setupWeatherSelectButton()
        setupCellTappedAction()
        setupBindData()
    }
    
    private func setupCellTappedAction() {
        let tapGestureRecognizer: UITapGestureRecognizer = .init(
            target: self,
            action: #selector(pictureSelectCellTapped(_:))
        )
        pictureSelectCell.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupViews() {
        self.tableView.backgroundColor = .systemGray6
    }
    
    private func setupNavigationItem() {
        self.title = "새로운 일기"
        
        let cancelButton = UIBarButtonItem(title: "뒤로",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelButtonTapped))
        
        let saveButton = UIBarButtonItem(title: "저장",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupLayout() {
        pageControl.bringSubviewToFront(imageScrollView)
        [imageScrollView, pageControl].forEach(imageContainerView.addSubview(_:))
        
        imageScrollView.snp.makeConstraints { make in
            make.width.height.equalTo(imageContainerView)
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.bottom.equalTo(imageScrollView)
        }
    }
    
    private func setupWeatherSelectButton() {
        let popUpButtonClosure: UIActionHandler = { [weak self] action in
            self?.viewModel.updateWeather(image: UIImage(named: action.title))
        }
        
        var weatherMenu: [UIAction] = .init()
        
        Constant.weatherNameList.forEach { weatherName in
            weatherMenu.append(UIAction(title: weatherName,
                                        image: UIImage(named: weatherName),
                                        handler: popUpButtonClosure))
        }
        
        weatherSelectButton.menu = UIMenu(children: weatherMenu)
        weatherSelectButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupBindData() {
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
    }
    
    private func configureImageScrollView(pictures: [UIImage]) {
        guard let contentViewWidth = imageContainerView.superview?.frame.width else {
            return
        }
        
        imageScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        imageScrollView.contentSize.width = contentViewWidth * CGFloat(pictures.count)
        imageScrollView.contentSize.height = contentViewWidth
        
        for index in 0..<pictures.count {
            let imageView = UIImageView()
            let xPosition = contentViewWidth * CGFloat(index)
            
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: contentViewWidth,
                                     height: contentViewWidth)
            imageView.image = pictures[index]
            
            imageScrollView.addSubview(imageView)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            let position = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
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
            configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
            
            return configuration
        }()
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    private func selectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    @objc func cancelButtonTapped() {
        print("Left button tapped!")
    }
    
    @objc func saveButtonTapped() {
        do {
            try viewModel.saveDiary()
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
                newSelections[identifier] = selections[identifier] ?? result
            }
        }
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        updatePictures()
    }
    
    private func updatePictures() {
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
            
            self.viewModel.updatePictures(pictures: pictures)
            self.pageControl.numberOfPages = self.viewModel.numberOfPictures
        }
    }
}

extension EditTableViewController: DataSendableDelegate {
    func sendDate(image: UIImage?) {
        self.viewModel.updateWeather(image: image)
    }
    
    func sendDate(date: Date) {
        self.viewModel.updateDate(date: date)
    }
}

extension EditTableViewController {
    func setupText(){
        contentTextView.rx.didBeginEditing
            .subscribe(onNext: { [self] in
                if(contentTextView.text == "내용을 입력하세요." ){
                    contentTextView.text = nil
                    contentTextView.textColor = .black
                }}).disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [self] in
                if(contentTextView.text == nil || contentTextView.text == ""){
                    contentTextView.text = "내용을 입력하세요."
                    contentTextView.textColor = .systemGray3
                }}).disposed(by: disposeBag)
    }
}
