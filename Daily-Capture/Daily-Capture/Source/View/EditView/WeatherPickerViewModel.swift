//  Daily-Capture - WeatherPickerViewModel.swift
//  Created by zhilly, vetto on 2023/07/28

import RxSwift

final class WeatherPickerViewModel {
    let weatherText: BehaviorSubject<String?> = .init(value: "clear")
}
