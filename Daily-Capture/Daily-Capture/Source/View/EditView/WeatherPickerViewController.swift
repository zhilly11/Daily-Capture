//  Daily-Capture - WeatherPickerViewController.swift
//  Created by zhilly, vetto on 2023/07/26

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class WeatherPickerViewController: UIViewController {
    private let viewModel: WeatherPickerViewModel
    private let disposeBag: DisposeBag = .init()
    
    private let pickerView: UIPickerView = {
        let pickerView: UIPickerView = .init(frame: .zero)
        
        return pickerView
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        
        imageView.image = UIImage(named: "clear")
        
        return imageView
    }()
    
    private let weatherNameList: [String] = ["clear", "cloudy-rainny", "cloudy-sunny", "cloudy", "fullmoon", "heavyrain-storm", "night-rain", "night", "night-clear", "rain", "sunny", "thunder"]
    
    init(viewModel: WeatherPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPickerView()
        setupLayout()
        setupBindData()
        configureNavigationBarButton()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [weatherImageView, pickerView].forEach(view.addSubview(_:))
        weatherImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(safeArea).multipliedBy(0.5)
        }
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func setupBindData() {
        viewModel.weatherText
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBarButton() {
        let rightButton: UIButton = UIButton(type: .custom)
        rightButton.setTitle("Change", for: .normal)
        rightButton.setTitleColor(.systemBlue, for: .normal)
        rightButton.addAction(UIAction(handler: { _ in
            self.tappedChangeButton()
        }), for: .touchUpInside)
        
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.setTitle("Cancel", for: .normal)
        leftButton.setTitleColor(.systemBlue, for: .normal)
        leftButton.addAction(UIAction(handler: { _ in
            self.tappedCancelButton()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    private func tappedCancelButton() {
        dismiss(animated: true)
    }
    
    private func tappedChangeButton() {
        dismiss(animated: true)
    }
}

extension WeatherPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weatherImageView.image = UIImage(named: weatherNameList[row])
        viewModel.weatherText.onNext(weatherNameList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image: UIImage(named: weatherNameList[row]))
        
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        return imageView
    }
}

extension WeatherPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherNameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
}
