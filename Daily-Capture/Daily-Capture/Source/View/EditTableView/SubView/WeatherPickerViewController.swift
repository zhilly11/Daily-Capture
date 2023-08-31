////  Daily-Capture - WeatherPickerViewController.swift
////  Created by zhilly, vetto on 2023/07/26
//
//import UIKit
//
//import SnapKit
//import RxSwift
//import RxCocoa
//
//final class WeatherPickerViewController: UIViewController {
//    // MARK: - Properties
//
//    private let viewModel: WeatherPickerViewModel
//    private let disposeBag: DisposeBag = .init()
//    weak var delegate: DataSendableDelegate?
//    
//    // MARK: - UI Components
//
//    private let pickerView: UIPickerView = .init()
//    private let weatherImageView: UIImageView = {
//        let imageView: UIImageView = .init(frame: .zero)
//        
//        imageView.image = UIImage(named: "clear")
//        
//        return imageView
//    }()
//    
//    // MARK: - Initializer
//
//    init(viewModel: WeatherPickerViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - View Life Cycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//    }
//    
//    // MARK: - Methods
//
//    private func configure() {
//        setupView()
//        setupPickerView()
//        setupLayout()
//        setupBindData()
//        configureNavigationBarButton()
//    }
//    
//    private func setupView() {
//        view.backgroundColor = .systemBackground
//    }
//    
//    private func setupPickerView() {
//        pickerView.delegate = self
//        pickerView.dataSource = self
//    }
//    
//    private func setupLayout() {
//        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
//        
//        [weatherImageView, pickerView].forEach(view.addSubview(_:))
//        weatherImageView.snp.makeConstraints { make in
//            make.top.left.right.equalTo(safeArea)
//            make.bottom.equalTo(safeArea).multipliedBy(0.5)
//        }
//        pickerView.snp.makeConstraints { make in
//            make.top.equalTo(weatherImageView.snp.bottom)
//            make.left.right.bottom.equalTo(safeArea)
//        }
//    }
//    
//    private func setupBindData() {
//        viewModel.weatherText
//            .bind(to: navigationItem.rx.title)
//            .disposed(by: disposeBag)
//        
//        viewModel.weatherText
//            .map {
//                UIImage(named: $0)
//            }
//            .bind(to: weatherImageView.rx.image)
//            .disposed(by: disposeBag)
//    }
//    
//    private func configureNavigationBarButton() {
//        let saveButton: UIButton = UIButton(type: .custom)
//        saveButton.setTitle("저장", for: .normal)
//        saveButton.setTitleColor(.systemBlue, for: .normal)
//        saveButton.addAction(UIAction(handler: { _ in
//            self.tappedSaveButton()
//        }), for: .touchUpInside)
//        
//        let cancelButton: UIButton = UIButton(type: .custom)
//        cancelButton.setTitle("취소", for: .normal)
//        cancelButton.setTitleColor(.systemBlue, for: .normal)
//        cancelButton.addAction(UIAction(handler: { _ in
//            self.tappedCancelButton()
//        }), for: .touchUpInside)
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
//    }
//    
//    private func tappedCancelButton() {
//        dismiss(animated: true)
//    }
//    
//    private func tappedSaveButton() {
//        delegate?.sendDate(image: viewModel.weatherImage)
//        dismiss(animated: true)
//    }
//}
//
//extension WeatherPickerViewController: UIPickerViewDelegate {
//    func pickerView(
//        _ pickerView: UIPickerView,
//        didSelectRow row: Int,
//        inComponent component: Int
//    ) {
//        viewModel.weatherText.onNext(Constant.weatherNameList[row])
//    }
//    
//    func pickerView(
//        _ pickerView: UIPickerView,
//        viewForRow row: Int,
//        forComponent component: Int,
//        reusing view: UIView?
//    ) -> UIView {
//        let weatherImage: UIImage? = .init(named: Constant.weatherNameList[row])
//        let imageView: UIImageView = .init(image: weatherImage)
//        
//        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        
//        return imageView
//    }
//}
//
//extension WeatherPickerViewController: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return Constant.weatherNameList.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 80
//    }
//}
