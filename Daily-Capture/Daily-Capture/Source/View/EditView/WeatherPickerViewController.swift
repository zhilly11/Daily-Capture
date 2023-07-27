//  Daily-Capture - WeatherPickerViewController.swift
//  Created by zhilly, vetto on 2023/07/26

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class WeatherPickerViewController: UIViewController {
    private let pickerView: UIPickerView = {
        let pickerView: UIPickerView = .init(frame: .zero)
        
        return pickerView
    }()
    
    private let weatherLabel: UILabel = {
        let label: UILabel = .init()
        
        label.text = "clear"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .systemBlue
        label.textAlignment = .center
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        
        imageView.image = UIImage(named: "clear")
        
        return imageView
    }()
    
    private let weatherNameList: [String] = ["clear", "cloudy-rainny", "cloudy-sunny", "cloudy", "fullmoon", "heavyrain-storm", "night-rain", "night", "night-clear", "rain", "sunny", "thunder"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        configureNavigationBarButton()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupLayout() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        [weatherImageView, weatherLabel, pickerView].forEach(view.addSubview(_:))
        weatherImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(safeArea).multipliedBy(0.5)
        }
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.equalTo(safeArea)
        }
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureNavigationBarButton() {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.tappedChoiceButton()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func tappedChoiceButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension WeatherPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weatherImageView.image = UIImage(named: weatherNameList[row])
        weatherLabel.text = weatherNameList[row]
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
